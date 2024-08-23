import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class OutgoingMessage extends StatelessWidget {
  final String username;
  final String message;
  final String datetime;

  const OutgoingMessage({
    Key? key,
    required this.username,
    required this.message,
    required this.datetime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(8.0),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: Colors.grey,
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
                  ),
                ),
                SizedBox(width: 8.0),
                Text(
                  datetime,
                  style: GoogleFonts.montserrat(
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.0),
            Text(
              message,
              style: GoogleFonts.montserrat(
                fontSize: 14.0,
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

  const IncomingMessage({
    Key? key,
    required this.username,
    required this.message,
    required this.datetime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(8.0),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: Colors.grey,  // Change color to distinguish incoming messages
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
                  ),
                ),
                SizedBox(width: 8.0),
                Text(
                  datetime,
                  style: GoogleFonts.montserrat(
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.0),
            Text(
              message,
              style: GoogleFonts.montserrat(
                fontSize: 14.0,
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
  bool _isImage = true; // Track if the selected media is an image
  TextEditingController _textController = TextEditingController();

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
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          IncomingMessage(
                            username: "Jimbo",
                            message: "This is an example message",
                            datetime: "12/11/2000 6:56pm",
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 70,
                          ),
                          OutgoingMessage(
                            username: "ethtuah",
                            message: "This is an outgoing message",
                            datetime: "12/11/2000 6:57pm",
                          ),
                        ],
                      ),
                    ),
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
                                onPressed: () {
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
                    onPressed: () {
                      // Handle send action
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

// Add a VideoPlayerWidget to handle video playback
class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;

  const VideoPlayerWidget({Key? key, required this.videoPath})
      : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    )
        : Center(child: CircularProgressIndicator());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
/*
class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedMedia;
  bool _isImage = true; // Track if the selected media is an image
  TextEditingController _textController = TextEditingController();

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
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          IncomingMessage(
                            username: "Jimbo",
                            message: "This is an example message",
                            datetime: "12/11/2000 6:56pm",
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 70,
                          ),
                          OutgoingMessage(
                            username: "ethtuah",
                            message: "This is an outgoing message",
                            datetime: "12/11/2000 6:57pm",
                          ),
                        ],
                      ),
                    ),
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
                      child: Stack(
                        children: [
                          if (_selectedMedia != null)
                            Positioned(
                              right: 8,
                              top: 8,
                              child: IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    _selectedMedia = null;
                                    _textController.clear();
                                  });
                                },
                              ),
                            ),
                          Column(
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
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          if (_selectedMedia == null)
                            TextField(
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
                    onPressed: () {
                      // Handle send action
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

// Add a VideoPlayerWidget to handle video playback
class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;

  const VideoPlayerWidget({Key? key, required this.videoPath})
      : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    )
        : Center(child: CircularProgressIndicator());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

 */


