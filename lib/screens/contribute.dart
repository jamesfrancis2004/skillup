
import 'dart:ui';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../Widgets/video_player.dart';
import '../functions/skills.dart';
import 'package:path_provider/path_provider.dart';
import 'package:camera/camera.dart';


class ContributePage extends StatefulWidget {
  const ContributePage({super.key});
  @override
  State<ContributePage> createState() => _ContributePageState();
}
class _ContributePageState extends State<ContributePage> {
  late List<CameraDescription> cameras;
  late CameraController _controller;
  CurrentSkill? skill;  // Allow null until initialized
  late String challenge1;
  late String challenge2;
  late String challenge3;
  late Future<void> _initializeControllerFuture;
  String? _imagePath;
  bool _isRecording = false;
  XFile? _videoFile;
  final TextEditingController _textController = TextEditingController();
  bool _isSkillInitialized = false;
  String? _selectedChallenge;
  int _selectedChallengeIndex = 0;
  @override
  void initState() {
    super.initState();
    _loadCameras();
    _loadSkill();
  }
  Future<void> _loadSkill() async {
    if (!_isSkillInitialized) {
      try {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('skills') // Assuming your collection is named 'skills'
            .where('selected',
            isEqualTo:
            1) // Assuming 'date' is the field storing the integer value
            .limit(1) // Get only the first matching document
            .get();
        final data = querySnapshot.docs.first.data();
        print(data);
        setState(() {
          challenge1 = data['challenge1'];
          challenge2 = data['challenge2'];
          challenge3 = data['challenge3'];
          _isSkillInitialized = true;
          _selectedChallenge = challenge1;
          _selectedChallengeIndex = {
            data['challenge1']: 0,
            data['challenge2']: 1,
            data['challenge3']: 2,
          }[_selectedChallenge] ?? 0;
        });
      } catch (e) {
        print('Error loading skill: $e');
      }
    }
  }
  Future<void> _loadCameras() async {
    try {
      cameras = await availableCameras();
      _controller = CameraController(
        cameras.first,
        ResolutionPreset.high,
      );
      _initializeControllerFuture = _controller.initialize();
      setState(() {});
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }
  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _sendContent() async {
    try {
      // Determine the selected challenge based on index
      String challengeField;
      switch (_selectedChallengeIndex) {
        case 1:
          challengeField = "challenge2";
          break;
        case 2:
          challengeField = "challenge3";
          break;
        case 0:
        default:
          challengeField = "challenge1";
          break;
      }

      // Define the media type and path
      String mediaType;
      String mediaPath;
      File? mediaFile;
      if (_imagePath != null) {
        mediaType = 'image';
        mediaPath = _imagePath!;
        mediaFile = File(mediaPath);
      } else if (_videoFile != null) {
        mediaType = 'video';
        mediaPath = _videoFile!.path;
        mediaFile = File(mediaPath);
      } else {
        throw Exception('No media selected');
      }

      final storageRef = FirebaseStorage.instance.ref().child('user_media')
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child('${DateTime.now().millisecondsSinceEpoch}.mp4'); // Ensure the extension is correct

      final uploadTask = storageRef.putFile(mediaFile!);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Prepare data for Firestore
      final data = {
        'timestamp': Timestamp.now(),
        'media_path': downloadUrl,
        'media_type': mediaType,
        'description': _textController.text,
      };

      // Get the current user's ID
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Push data to Firestore in the respective challenge subcollection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection(challengeField)
          .add(data);

      // Reset fields after sending
      setState(() {
        _imagePath = null;
        _videoFile = null;
        _textController.clear();
        _selectedChallenge = challenge1;
        _selectedChallengeIndex = 0;
      });

      print('Content sent successfully');
    } catch (e) {
      print('Error sending content: $e');
    }
  }


  Future<void> _takePhoto() async {
    try {
      final image = await _controller.takePicture();
      setState(() {
        _imagePath = image.path;
      });
    } catch (e) {
      print('Error taking photo: $e');
    }
  }
  Future<void> _startVideoRecording() async {
    try {
      final directory = await getTemporaryDirectory();
      final videoPath = '${directory.path}/video_${DateTime.now().millisecondsSinceEpoch}.mp4';
      await _controller.startVideoRecording();
      setState(() {
        _isRecording = true;
      });
    } catch (e) {
      print('Error starting video recording: $e');
    }
  }
  Future<void> _stopVideoRecording() async {
    try {
      final videoFile = await _controller.stopVideoRecording();
      setState(() {
        _videoFile = videoFile;
        _isRecording = false;
      });
    } catch (e) {
      print('Error stopping video recording: $e');
    }
  }



  void _removeMedia() {
  setState(() {
    _imagePath = null;
    _videoFile = null;
  });
}
void _onChallengeChanged(String? newValue) {
  setState(() {
    _selectedChallenge = newValue;
    _selectedChallengeIndex = {
      this.challenge1: 0,
      this.challenge2: 1,
      this.challenge3: 2,
    }[newValue] ?? 0;
  });
}
@override
Widget build(BuildContext context) {
  return Container(
    decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors:  [
            Color(0xff00274d), // Dark Blue
            Color(0xff001f3f), // Even Darker Blue
            Color(0xff000a1b)  // Nearly Black
          ],

          begin: Alignment.center,
          end: Alignment.bottomCenter,
        )
    ),
    child: Column(
      children: [
        // Dropdown for selecting the challenge
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: !_isSkillInitialized  // Check if skill is null
              ? Text('Loading challenges...')
              : DropdownButton<String>(
            value: _selectedChallenge,
            items: [
              DropdownMenuItem(
                value: challenge1,
                child: Text(challenge1),
              ),
              DropdownMenuItem(
                value: challenge2,
                child: Text(challenge2),
              ),
              DropdownMenuItem(
                value: challenge3,
                child: Text(challenge3),
              ),
            ],
            onChanged: _onChallengeChanged,
            hint: Text('Select Challenge'),
          ),
        ),
        Expanded(
          child: FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_controller);
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.camera),
              onPressed: _takePhoto,
            ),
            _isRecording
                ? IconButton(
              icon: Icon(Icons.stop),
              onPressed: _stopVideoRecording,
            )
                : IconButton(
              icon: Icon(Icons.videocam),
              onPressed: _startVideoRecording,
            ),
          ],
        ),
        if (_imagePath != null || _videoFile != null)
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Color(0xffffffff).withOpacity(0.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_imagePath != null)
                    Expanded(
                      child: Image.file(
                        File(_imagePath!),
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  if (_videoFile != null)
                    Expanded(
                      child: VideoPlayerWidget(
                        videoPath: _videoFile!.path,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: "Add a caption...",
                        fillColor: Color(0xffffffff).withOpacity(0.2),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: _sendContent,
                          child: Text(
                            'Send',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: _removeMedia,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    ),
  );
}
}

