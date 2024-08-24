import 'package:flutter/material.dart';
import 'package:skillup/functions/skills.dart';
import 'package:skillup/functions/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skillup/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const double _selectorRowInsetHorizontal = horizontalInset;
const double _verticalSpacing = majorVerticalSpacing;

const double _challengesVerticalSpacing = 10;
const double _challengesHeight = 60;
const double _challengeBorderRadius = 4.0;
const Color _challengeBackgroundColour = Color.fromARGB(255, 70, 70, 75);

const double _subheadingGradientHeight = 3;
const double _subheadingGradientWidth = 60;

const double filterHorizontalInset = 0;

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();

  static final ScrollController _scrollController = ScrollController();
  static void scrollToTop() {
    _scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }
}

class _FriendsPageState extends State<FriendsPage> {
  final TextEditingController _friendSearchController =
      TextEditingController(text: '');
  late CurrentUser user;
  var showRequestError = false;
  late CurrentSkill skill;
  bool _isUserDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    user = await CurrentUser.create(FirebaseAuth.instance.currentUser!.uid);
    setState(() {
      _isUserDataLoaded = true;
    });
  }

  Future<String> _getNameFromId(String id) async {
    try {
      String? name = await CurrentUser.getNameFromId(id);
      return name ?? 'Unknown';
    } catch (e) {
      return 'Error';
    }
  }

  void getStatusOfRequest(String name) async {
    bool requestStatus = await user.sendFriendRequest(name);
    setState(() {
      showRequestError = !requestStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isUserDataLoaded
          ? Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff00274d),
                  Color(0xff001f3f),
                  Color(0xff000a1b),
                ],
                begin: Alignment.center,
                end: Alignment.bottomCenter,
              ),
            ),
            child: RefreshIndicator(
              color: Theme.of(context).colorScheme.onTertiaryContainer,
              backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
              onRefresh: () async {
                await Future.delayed(const Duration(milliseconds: 1500));
                setState(() {
                  FriendsPage.scrollToTop();
                });
              },
              child: SingleChildScrollView(
                controller: FriendsPage._scrollController,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.only(
                      left: _selectorRowInsetHorizontal,
                      right: _selectorRowInsetHorizontal,
                      top: 16,
                      bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      _buildCurrentFriendsSection(),
                      SizedBox(height: 20),
                      _buildAddFriendsSection(),
                      SizedBox(height: 20),
                      _buildPendingRequestsSection(),
                      SizedBox(height: 20),
                      _buildSentRequestsSection(),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            )
          )
          : Center(child: CircularProgressIndicator()),
    );
  }

    Widget _buildSentRequestsSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 0, bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Sent Requests",
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 15.0)),
              const Padding(
                padding: EdgeInsets.only(right: filterHorizontalInset),
                child: SizedBox(width: 0, height: 0),
              ),
            ],
          ),
          Container(
            height: _subheadingGradientHeight,
            width: _subheadingGradientWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: highlightGradient,
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.red)),
                );
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text('No outgoing requests',
                      style: TextStyle(color: Colors.white)),
                );
              } else {
                var userDoc = snapshot.data!.docs
                    .where((doc) =>
                        doc.id == FirebaseAuth.instance.currentUser!.uid)
                    .firstOrNull;

                List<String> userList = [];
                if (userDoc != null) {
                  userList =
                      List<String>.from(userDoc["outboundRequests"] ?? []);
                }

                return Column(
                  children: userList.map((requestId) {
                    return FutureBuilder<String>(
                      future: _getNameFromId(requestId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ListTile(
                            title: Text(
                              'Loading...',
                              style: TextStyle(color: Colors.white),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.close, color: Colors.red),
                                  onPressed: null,
                                ),
                              ],
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return ListTile(
                            title: Text(
                              'Error',
                              style: TextStyle(color: Colors.white),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.close, color: Colors.red),
                                  onPressed: null,
                                ),
                              ],
                            ),
                          );
                        } else {
                          String name = snapshot.data ?? 'Unknown';
                          return ListTile(
                            title: Text(
                              name,
                              style: TextStyle(color: Colors.white),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.close, color: Colors.red),
                                  onPressed: () async {
                                    bool success = await user.cancelFriendRequest(requestId);
                                    if (success) {
                                      setState(() {
                                        // Optionally update the UI to reflect the rejection
                                        userList.remove(requestId);
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text('Friend request rejected')),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text('Failed to reject friend request')),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    );
                  }).toList(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentFriendsSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 0, bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Current Friends",
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 32.0)),
              const Padding(
                padding: EdgeInsets.only(right: filterHorizontalInset),
                child: SizedBox(width: 0, height: 0),
              ),
            ],
          ),
          Container(
            height: _subheadingGradientHeight,
            width: _subheadingGradientWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: highlightGradient,
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.red)),
                );
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text('No incoming requests',
                      style: TextStyle(color: Colors.white)),
                );
              } else {
                var userDoc = snapshot.data!.docs
                    .where((doc) =>
                        doc.id == FirebaseAuth.instance.currentUser!.uid)
                    .firstOrNull;

                List<String> userList = [];
                if (userDoc != null) {
                  userList =
                      List<String>.from(userDoc["friends"] ?? []);
                }

                return Column(
                  children: userList.map((requestId) {
                    return FutureBuilder<String>(
                      future: _getNameFromId(requestId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ListTile(
                            title: Text(
                              'Loading...',
                              style: TextStyle(color: Colors.white),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.check, color: Colors.green),
                                  onPressed: null,
                                ),
                                IconButton(
                                  icon: Icon(Icons.close, color: Colors.red),
                                  onPressed: null,
                                ),
                              ],
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return ListTile(
                            title: Text(
                              'Error',
                              style: TextStyle(color: Colors.white),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.check, color: Colors.green),
                                  onPressed: null,
                                ),
                                IconButton(
                                  icon: Icon(Icons.close, color: Colors.red),
                                  onPressed: null,
                                ),
                              ],
                            ),
                          );
                        } else {
                          String name = snapshot.data ?? 'Unknown';
                          return ListTile(
                            title: Text(
                              name,
                              style: TextStyle(color: Colors.white),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.close, color: Colors.red),
                                  onPressed: () async {
                                    bool success = await user.deleteFriend(requestId);
                                    if (success) {
                                      setState(() {
                                        // Optionally update the UI to reflect the rejection
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text('Friend request rejected')),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text('Failed to reject friend request')),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    );
                  }).toList(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAddFriendsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Add Friends",
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 15.0)),
            const Padding(
              padding: EdgeInsets.only(right: filterHorizontalInset),
              child: SizedBox(width: 0, height: 0),
            ),
          ],
        ),
        Container(
          height: _subheadingGradientHeight,
          width: _subheadingGradientWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: highlightGradient,
          ),
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 8.0),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  controller: _friendSearchController,
                  decoration: InputDecoration(
                    labelText: "Enter Friend's Username",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.send,
                color: Colors.white,
                size: 30.0,
              ),
              onPressed: () {
                getStatusOfRequest(_friendSearchController.text);
              },
            ),
          ],
        ),
        showRequestError
            ? Text(
                'Error finding user:',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              )
            : SizedBox(height: 1),
      ],
    );
  }

  Widget _buildPendingRequestsSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 0, bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Pending Request",
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 15.0)),
              const Padding(
                padding: EdgeInsets.only(right: filterHorizontalInset),
                child: SizedBox(width: 0, height: 0),
              ),
            ],
          ),
          Container(
            height: _subheadingGradientHeight,
            width: _subheadingGradientWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: highlightGradient,
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.red)),
                );
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text('No incoming requests',
                      style: TextStyle(color: Colors.white)),
                );
              } else {
                var userDoc = snapshot.data!.docs
                    .where((doc) =>
                        doc.id == FirebaseAuth.instance.currentUser!.uid)
                    .firstOrNull;

                List<String> userList = [];
                if (userDoc != null) {
                  userList =
                      List<String>.from(userDoc["inboundRequests"] ?? []);
                }

                return Column(
                  children: userList.map((requestId) {
                    return FutureBuilder<String>(
                      future: _getNameFromId(requestId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ListTile(
                            title: Text(
                              'Loading...',
                              style: TextStyle(color: Colors.white),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.check, color: Colors.green),
                                  onPressed: null,
                                ),
                                IconButton(
                                  icon: Icon(Icons.close, color: Colors.red),
                                  onPressed: null,
                                ),
                              ],
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return ListTile(
                            title: Text(
                              'Error',
                              style: TextStyle(color: Colors.white),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.check, color: Colors.green),
                                  onPressed: null,
                                ),
                                IconButton(
                                  icon: Icon(Icons.close, color: Colors.red),
                                  onPressed: null,
                                ),
                              ],
                            ),
                          );
                        } else {
                          String name = snapshot.data ?? 'Unknown';
                          return ListTile(
                            title: Text(
                              name,
                              style: TextStyle(color: Colors.white),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.check, color: Colors.green),
                                  onPressed: () async {
                                    bool success = await user.acceptFriendRequest(requestId);
                                    if (success) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text('Friend request accepted')),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text('Failed to accept friend request')),
                                      );
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.close, color: Colors.red),
                                  onPressed: () async {
                                    bool success = await user.rejectFriendRequest(requestId);
                                    if (success) {
                                      setState(() {
                                        // Optionally update the UI to reflect the rejection
                                        userList.remove(requestId);
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text('Friend request rejected')),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text('Failed to reject friend request')),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    );
                  }).toList(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
