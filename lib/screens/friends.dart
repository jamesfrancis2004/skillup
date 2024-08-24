import 'package:flutter/material.dart';
import 'package:skillup/functions/skills.dart';
import 'package:skillup/functions/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:skillup/config.dart';

const double _selectorRowInsetHorizontal = horizontalInset;
const double _verticalSpacing = majorVerticalSpacing;

const double _challengesVerticalSpacing = 10;
const double _challengesHeight = 60;
const double _challengeBorderRadius = 4.0;
const Color _challengeBackgroundColour = Color.fromARGB(255, 70, 70, 75);

const double _subheadingGradientHeight = 3;
const double _subheadingGradientWidth = 60;

const double filterHorizontalInset = 0;

// WIDGET
class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();

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
class _FriendsPageState extends State<FriendsPage> {
  final TextEditingController _friendSearchController =
      TextEditingController(text: '');
  late CurrentUser user;
  var showRequestError = false;
  late CurrentSkill skill;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    user = await CurrentUser.create(FirebaseAuth.instance.currentUser!.uid);
    setState(() {});
    skill = await CurrentSkill.create();
    setState(() {});
  }

  // Function to update whether showing error
  void getStatusOfRequest(String name) async {
    // Simulate API call
    user.sendFriendRequest(name); // Simulating network delay
    setState(() {
      showRequestError = true; // Update state to show the error
    });
  }

  // Function to update whether showing error
  void getStatusOfRequest(String name) async {
    // Simulate API call
    user.sendFriendRequest(name); // Simulating network delay
    setState(() {
      showRequestError = true; // Update state to show the error
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: RefreshIndicator(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(
                    left: _selectorRowInsetHorizontal,
                    right: _selectorRowInsetHorizontal,
                    top: 16,
                    bottom: 16),
                child: Column(
                  children: [
                    SizedBox(height: 20),

                    // Challenges title
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // The title of the row
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Add Friends",
                                    style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                        fontSize: 15.0)),
                                const Padding(
                                    padding: EdgeInsets.only(
                                        right: filterHorizontalInset),
                                    child: SizedBox(width: 0, height: 0)),
                              ]),

                          // The gradient subheading
                          Container(
                              height: _subheadingGradientHeight,
                              width: _subheadingGradientWidth,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: highlightGradient)),
                        ]),

                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                                right:
                                    8.0), // Add margin between the text field and the icon
                            child: TextField(
                              style: TextStyle(color: Colors.white),
                              controller: _friendSearchController,
                              decoration: InputDecoration(
                                labelText: "Enter Friend's Username",
                                labelStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white), // Border color
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .white), // Border color when focused
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .white), // Border color when enabled
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.send, // Send message icon
                            color: Colors.white, // Icon color
                            size: 30.0, // Icon size
                          ),
                          onPressed: () {
                            // Handle button press
                            getStatusOfRequest(_friendSearchController.text);
                          },
                        ),
                      ],
                    ),
                    showRequestError
                        ? Text(
                            'Failed to find user',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          )
                        : SizedBox(height: 1),
                    SizedBox(height: 20),

                    // Challenges title
                    Padding(
                        padding: const EdgeInsets.only(
                            left: _selectorRowInsetHorizontal, bottom: 15),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // The title of the row
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Pending Request",
                                        style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                            fontSize: 15.0)),
                                    const Padding(
                                        padding: EdgeInsets.only(
                                            right: filterHorizontalInset),
                                        child: SizedBox(width: 0, height: 0)),
                                  ]),

                              // The gradient subheading
                              Container(
                                  height: _subheadingGradientHeight,
                                  width: _subheadingGradientWidth,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: highlightGradient)),
                            ])),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: user.inboundRequests.map((request) {
                        return ListTile(
                          title: Text(
                            request, // Display the username of the incoming request
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.check, color: Colors.green),
                                onPressed: () {
                                  // Accept friend request logic
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.close, color: Colors.red),
                                onPressed: () {
                                  // Decline friend request logic
                                },
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Challenges title
                    Padding(
                        padding: const EdgeInsets.only(
                            left: _selectorRowInsetHorizontal, bottom: 15),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // The title of the row
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Sent Requests",
                                        style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                            fontSize: 15.0)),
                                    const Padding(
                                        padding: EdgeInsets.only(
                                            right: filterHorizontalInset),
                                        child: SizedBox(width: 0, height: 0)),
                                  ]),

                              // The gradient subheading
                              Container(
                                  height: _subheadingGradientHeight,
                                  width: _subheadingGradientWidth,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: highlightGradient)),
                            ])),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: user.outboundRequests.map((request) {
                        return ListTile(
                          title: Text(
                            request, // Display the username of the outgoing request
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.cancel, color: Colors.red),
                            onPressed: () {
                              // Cancel friend request logic
                            },
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Challenges title
                    Padding(
                        padding: const EdgeInsets.only(
                            left: _selectorRowInsetHorizontal, bottom: 15),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // The title of the row
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Current Friends",
                                        style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                            fontSize: 15.0)),
                                    const Padding(
                                        padding: EdgeInsets.only(
                                            right: filterHorizontalInset),
                                        child: SizedBox(width: 0, height: 0)),
                                  ]),

                              // The gradient subheading
                              Container(
                                  height: _subheadingGradientHeight,
                                  width: _subheadingGradientWidth,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: highlightGradient)),
                            ])),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: user.outboundRequests.map((request) {
                        return ListTile(
                          title: Text(
                            request, // Display the username of the outgoing request
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.cancel, color: Colors.red),
                            onPressed: () {
                              // Cancel friend request logic
                            },
                          ),
                        );
                      }).toList(),
                    ), // Display current friends similarly
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
