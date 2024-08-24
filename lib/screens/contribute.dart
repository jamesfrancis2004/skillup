
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
      if (_imagePath != null) {
        mediaType = 'image';
        mediaPath = _imagePath!;
      } else if (_videoFile != null) {
        mediaType = 'video';
        mediaPath = _videoFile!.path;
      } else {
        throw Exception('No media selected');
      }

      // Prepare data for Firestore
      final data = {
        'timestamp': Timestamp.now(),
        'media_path': mediaPath,
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Contribute'),
      ),
      body: Column(
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



/*
class ContributePage extends StatefulWidget {
  const ContributePage({super.key});

  @override
  State<ContributePage> createState() => _ContributePageState();
}

class _ContributePageState extends State<ContributePage> {
  late List<CameraDescription> cameras;
  late CurrentSkill skill;
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  String? _imagePath;
  bool _isRecording = false;
  XFile? _videoFile;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCameras();
    _loadSkill();
  }

  Future<void> _loadSkill() async {
    this.skill = await CurrentSkill.create();

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

  void _sendContent() {
    // Implement the send functionality here
    print('Send button pressed');
    print('Caption: ${_textController.text}');
    print('Image Path: $_imagePath');
    print('Video File: $_videoFile');
    // Reset fields after sending
    setState(() {
      _imagePath = null;
      _videoFile = null;
      _textController.clear();
    });
  }

  void _removeMedia() {
    setState(() {
      _imagePath = null;
      _videoFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contribute'),
      ),
      body: Column(
        children: [
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

 */

/*

class ContributePage extends StatefulWidget {
  const ContributePage({super.key});

  @override
  State<ContributePage> createState() => _ContributePageState();

  // Allow controlling scroll via FriendsPage
  static final ScrollController _scrollController = ScrollController();
  static void scrollToTop() {
    _scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }
}

// STATE

class _ContributePageState extends State<ContributePage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedMedia;
  bool _isImage = true;
  TextEditingController _textController = TextEditingController();

  Future<void> _uploadMediaAndSendMessage() async {
    if (_selectedMedia != null) {
      try {
        // Get the current user
        User? user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          throw FirebaseAuthException(
            code: 'no-user',
            message: 'No user signed in',
          );
        }

        // Upload the media file to Firebase Storage
        String fileName = _selectedMedia!.name;
        String filePath = 'user_uploads/${user.uid}/$fileName';
        File file = File(_selectedMedia!.path);

        // Reference to Firebase Storage
        Reference storageRef = FirebaseStorage.instance.ref().child(filePath);

        // Upload the file
        UploadTask uploadTask = storageRef.putFile(file);

        // Wait until the file is uploaded and get the download URL
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();

        // Create a new post in Firestore
        CollectionReference postsRef = FirebaseFirestore.instance.collection('posts');
        await postsRef.add({
          'mediaUrl': downloadUrl,
          'description': _textController.text,
          'userId': user.uid,
          'timestamp': FieldValue.serverTimestamp(),
          'mediaType': _isImage ? 'image' : 'video',
        });

        // Clear the selected media and text field
        setState(() {
          _selectedMedia = null;
          _textController.clear();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Post uploaded successfully!')),
        );
      } catch (e) {
        print('Error uploading media: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload post')),
        );
      }
    }
  }

  Future<void> _pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      setState(() {
        _selectedMedia = video;
        _isImage = false;
      });
    }
  }
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedMedia = image;
        _isImage = true;
      });
    }
  }
  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150,
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage();
                },
              ),
              ListTile(
                leading: Icon(Icons.video_call),
                title: Text('Video'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickVideo();
                },
              ),
            ],
          ),
        );
      },
    );
  }
  Stream<QuerySnapshot> _postsStream() {
    return FirebaseFirestore.instance
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots();
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _postsStream(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No posts available'));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var post = snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: PostSubmissionContainer(
                          mediaUrl: post['mediaUrl'] ?? '',
                          description: post['description'] ?? '',
                          mediaType: post['mediaType'] ?? '',
                          // You can add more fields from the post document as needed
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color(0xffffffff).withOpacity(0.2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_selectedMedia != null)
                          _isImage
                              ? Image.file(
                            File(_selectedMedia!.path),
                            fit: BoxFit.cover,
                            height: 150,
                            width: double.infinity,
                          )
                              : VideoPlayerWidget(
                            videoPath: _selectedMedia!.path,
                          ),
                        if (_selectedMedia != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _textController,
                              decoration: InputDecoration(
                                hintText: "Enter additional comments or details",
                                fillColor: Color(0xffffffff).withOpacity(0.2),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        if (_selectedMedia != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () async {
                                setState(() {
                                  _selectedMedia = null;
                                  _textController.clear();
                                });
                              },
                              child: Text(
                                'Remove',
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        if (_selectedMedia == null)
                          TextField(
                            controller: _textController,
                            decoration: InputDecoration(
                              hintText: "Enter additional comments or details",
                              filled: true,
                              fillColor: Color(0xffffffff).withOpacity(0.2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            minLines: 1,
                            maxLines: 5,
                          ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.attach_file),
                  onPressed: () {
                    _showAttachmentOptions(context);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    await _uploadMediaAndSendMessage();
                    _textController.clear();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class PostSubmissionContainer extends StatelessWidget {
  final String description;
  final String? mediaUrl;
  final String mediaType; // "image" or "video"

  const PostSubmissionContainer({
    Key? key,
    required this.description,
    this.mediaUrl,
    required this.mediaType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white.withOpacity(0.20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Media display
          mediaType == 'image'
              ? mediaUrl != null
              ? CachedNetworkImage(
            imageUrl: mediaUrl!,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
          )
              : Container(
            height: 200,
            color: Colors.grey[300],
            child: Center(child: Text('No image available')),
          )
              : mediaType == 'video'
              ? mediaUrl != null
              ? VideoPlayerWidget(videoPath: mediaUrl!)
              : Container(
            height: 200,
            color: Colors.grey[300],
            child: Center(child: Text('No video available')),
          )
              : Container(
            height: 200,
            color: Colors.grey[300],
            child: Center(child: Text('Unsupported media type')),
          ),
          SizedBox(height: 16),
          // Text description
          Text(
            description,
            style: GoogleFonts.montserrat(
              fontSize: 13.0,
            ),
          ),
          SizedBox(height: 16),
          // Approval buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Handle approval action
                },
                child: Text("Approve"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  // Handle non-approval action
                },
                child: Text("Reject"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

 */
