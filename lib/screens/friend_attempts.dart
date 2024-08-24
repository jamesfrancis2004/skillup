import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Widgets/video_player.dart';
import '../router.dart';

class AttemptPage extends StatefulWidget {
  final String challenge;
  const AttemptPage({super.key, required this.challenge});

  @override
  State<AttemptPage> createState() => _AttemptPage();

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

class _AttemptPage extends State<AttemptPage> {

  // Method to retrieve posts based on friends' UIDs and the challenge
  // In the _postsStream() method:
  Stream<List<Map<String, dynamic>>> _postsStream() {
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .snapshots()
        .asyncExpand((userSnapshot) {
      if (!userSnapshot.exists) {
        return Stream.value([]);
      }

      List<String> friendsUids = List<String>.from(userSnapshot.data()?['friends'] ?? []);

      List<Stream<QuerySnapshot>> friendsPostsStreams = friendsUids.map((friendUid) {
        return FirebaseFirestore.instance
            .collection('users')
            .doc(friendUid)
            .collection(widget.challenge)
            .orderBy('timestamp', descending: true)
            .snapshots();
      }).toList();

      return CombineLatestStream.list(friendsPostsStreams).map((snapshots) {
        List<Map<String, dynamic>> allDocs = [];

        for (var snapshot in snapshots) {
          for (var doc in snapshot.docs) {
            allDocs.add(doc.data() as Map<String, dynamic>);
          }
        }

        allDocs.sort((a, b) {
          Timestamp timestampA = a['timestamp'] as Timestamp;
          Timestamp timestampB = b['timestamp'] as Timestamp;
          return timestampB.compareTo(timestampA);
        });

        return allDocs;
      });
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
        child: Padding(
            padding: EdgeInsets.all(30.0),

              child: Column(
                children: [
                  ElevatedButton(
                      child: Text("Back"),
                      onPressed: () {
                          return context.go(NavigationRoutes.home);
                          }
                          ),
                  Expanded(
                      child: StreamBuilder<List<Map<String, dynamic>>>(
                        stream: _postsStream(),
                        builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          }

                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(child: Text('No posts available'));
                          }

                          return ListView.builder(
                            controller: AttemptPage._scrollController,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              var post = snapshot.data![index];

                              // Safely access fields with default values
                              String mediaUrl = post.containsKey('mediaUrl') ? post['mediaUrl'] : '';
                              String description = post.containsKey('description') ? post['description'] : '';
                              String mediaType = post.containsKey('mediaType') ? post['mediaType'] : 'unknown';

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: PostSubmissionContainer(
                                  mediaUrl: mediaUrl,
                                  description: description,
                                  mediaType: mediaType,
                                  // You can add more fields from the post document as needed
                                ),
                              );
                            },
                          );
                        },
                      )
                  )
                ]

              )

        )
    );
  }
}

/*
class AttemptPage extends StatefulWidget {
  final String challenge;
  const AttemptPage({super.key, required this.challenge});

  @override
  State<AttemptPage> createState() => _AttemptPage();

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

class _AttemptPage extends State<AttemptPage> {

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
        child: Expanded(
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
    )
    )
    );
  }
}

 */



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