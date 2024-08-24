
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
/*

// Custom Widget for Post Submission
class PostSubmissionContainer extends StatelessWidget {
  final String description;
  const PostSubmissionContainer({
    Key? key,
    required this.description,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Placeholder for media
          Container(
            height: 200,
            color: Colors.grey[300],
            child: Center(child: Text('Media Placeholder')),
          ),
          SizedBox(height: 16),
          // Text description
          Text(
            this.description,
            style: GoogleFonts.montserrat(
              fontSize: 13.0
            )
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


