import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class OutgoingMessage extends StatelessWidget {
  final String username;
  final String message;
  final String datetime;
  final String? mediaUrl; // Optional media URL
  final bool? isImage; // Boolean to indicate if the media is an image

  const OutgoingMessage({
    Key? key,
    required this.username,
    required this.message,
    required this.datetime,
    this.mediaUrl,
    this.isImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(8.0),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: Colors.blue, // Outgoing message color
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  username,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 8.0),
                Text(
                  datetime,
                  style: GoogleFonts.montserrat(
                    fontSize: 12.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.0),
            if (mediaUrl != null && isImage == true)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Image.network(mediaUrl!), // Display image
              )
            else if (mediaUrl != null && isImage == false)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: VideoPlayerWidget(videoPath: mediaUrl!), // Display video
              ),
            Text(
              message,
              style: GoogleFonts.montserrat(
                fontSize: 14.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IncomingMessage extends StatelessWidget {
  final String username;
  final String message;
  final String datetime;
  final String? mediaUrl; // Optional media URL
  final bool? isImage; // Boolean to indicate if the media is an image

  const IncomingMessage({
    Key? key,
    required this.username,
    required this.message,
    required this.datetime,
    this.mediaUrl,
    this.isImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(8.0),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: Colors.grey.shade300, // Incoming message color
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  username,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 8.0),
                Text(
                  datetime,
                  style: GoogleFonts.montserrat(
                    fontSize: 12.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.0),
            if (mediaUrl != null && isImage == true)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Image.network(mediaUrl!), // Display image
              )
            else if (mediaUrl != null && isImage == false)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: VideoPlayerWidget(videoPath: mediaUrl!), // Display video
              ),
            Text(
              message,
              style: GoogleFonts.montserrat(
                fontSize: 14.0,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  _ExplorePageState createState() => _ExplorePageState();
}




class _ExplorePageState extends State<ExplorePage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedMedia;
  bool _isImage = true;
  TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedMedia = image;
        _isImage = true;
      });
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

  Future<void> _uploadMediaAndSendMessage() async {
    String? mediaUrl;

    if (_selectedMedia != null) {
      String fileName = 'uploads/${DateTime.now().millisecondsSinceEpoch}_${_isImage ? 'image' : 'video'}';
      try {
        final ref = FirebaseStorage.instance.ref().child(fileName);
        await ref.putFile(File(_selectedMedia!.path));
        mediaUrl = await ref.getDownloadURL();
      } catch (e) {
        print('Failed to upload media: $e');
        return;
      }
    }

    try {
      await FirebaseFirestore.instance.collection("messages").doc().set({
        'uid': FirebaseAuth.instance.currentUser?.uid,
        'message': _textController.text,
        'mediaUrl': mediaUrl,
        'isImage': _isImage,
        'timestamp': FieldValue.serverTimestamp(),
      });
      setState(() {
        _selectedMedia = null;
        _textController.clear();
      });
    } catch (e) {
      print('Failed to send message: $e');
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


  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Community",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.black,
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.60,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('messages')
                        .orderBy('timestamp', descending: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      var messages = snapshot.data!.docs;
                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          var message = messages[index];
                          bool isOutgoing = message['uid'] ==
                              FirebaseAuth.instance.currentUser?.uid;
                          return Padding(
                            padding: EdgeInsets.all(8.0),
                            child: isOutgoing
                                ? OutgoingMessage(
                              username: "You",
                              message: message['message'],
                              datetime: message['timestamp']
                                  .toDate()
                                  .toString(),
                              mediaUrl: message['mediaUrl'],
                              isImage: message['isImage'],
                            )
                                : IncomingMessage(
                              username: "Someone",
                              message: message['message'],
                              datetime: message['timestamp']
                                  .toDate()
                                  .toString(),
                              mediaUrl: message['mediaUrl'],
                              isImage: message['isImage'],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 70,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey[200],
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
                                  hintText: "Add a caption...",
                                  fillColor: Colors.grey,
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
                                child: Text('Remove'),
                              ),
                            ),
                          if (_selectedMedia == null)
                            TextField(
                              controller: _textController,
                              decoration: InputDecoration(
                                hintText: "Send a message",
                                filled: true,
                                fillColor: Colors.grey,
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
      ),
    );
  }
}




class VideoPlayerWidget extends StatefulWidget {
  final String videoPath; // This is the URL of the video

  const VideoPlayerWidget({Key? key, required this.videoPath}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoPath);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
              VideoProgressIndicator(
                _controller,
                allowScrubbing: true,
                padding: EdgeInsets.all(8.0),
              ),
              IconButton(
                icon: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 30.0,
                ),
                onPressed: () {
                  setState(() {
                    if (_controller.value.isPlaying) {
                      _controller.pause();
                    } else {
                      _controller.play();
                    }
                  });
                },
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading video'));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}


