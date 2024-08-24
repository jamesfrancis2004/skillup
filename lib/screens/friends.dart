import 'package:flutter/material.dart';
import 'package:skillup/functions/skills.dart';
import 'package:skillup/functions/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  late CurrentSkill skill;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    user = await CurrentUser.create(FirebaseAuth.instance.currentUser!.uid);
    skill = await CurrentSkill.create(DateTime.now());
    print(skill);
    setState(() {});
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
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "Send Friend Request",
                      style: TextStyle(
                          color: Color.fromARGB(255, 174, 219, 255),
                          fontSize: 24,
                          fontWeight: FontWeight.w900),
                    ),
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
                            print('Send button pressed');
                            print(
                                'Entered text: ${_friendSearchController.text}');
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    const Text(
                      "Current Friends",
                      style: TextStyle(
                          color: Color.fromARGB(255, 174, 219, 255),
                          fontSize: 36,
                          fontWeight: FontWeight.w900),
                    )
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
