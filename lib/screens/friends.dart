import 'package:flutter/material.dart';
import 'package:skillup/functions/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

const currentFriendRequests = []; // Example empty list

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

  final TextEditingController _friendSearchController = TextEditingController(text: '');
  late CurrentUser user;

  @override
  void initState() {
    super.initState();
    user = CurrentUser(id: FirebaseAuth.instance.currentUser!.uid);
    user.fetchUserData();
  }

  // Method to print user information
  void printUserInfo() {
    if (user != null) {
      print('User ID: ${user.id}');
      print('User Email: ${user.email}');
      print('User Friends: ${user.friends}');
      // Add more fields if needed
    } else {
      print('No user is currently logged in.');
    }
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
                      style: TextStyle(color: Color.fromARGB(255, 174, 219, 255), fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 8.0), // Add margin between the text field and the icon
                            child: TextField(
                              style: TextStyle(color: Colors.white),
                              controller: _friendSearchController,
                              decoration: InputDecoration(
                                labelText: "Enter Friend's Username",
                                labelStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white), // Border color
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white), // Border color when focused
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white), // Border color when enabled
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
                            print('Entered text: ${_friendSearchController.text}');
                          },
                        ),
                      ],
                    ),
                    SizedBox(height:20),
                    Text(
                      "Current Friend Requests",
                      style: TextStyle(color: Color.fromARGB(255, 174, 219, 255), fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                    SizedBox(height: 10),
                    // Conditional rendering based on friend requests
                    currentFriendRequests.isNotEmpty
                        ? Column(
                            children: currentFriendRequests.map((request) {
                              return ListTile(
                                title: Text(
                                  request,
                                  style: TextStyle(color: Colors.white),
                                ),
                                tileColor: Colors.blueAccent,
                                contentPadding: EdgeInsets.all(8.0),
                              );
                            }).toList(),
                          )
                        : Text(
                            "No new friend requests",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                    SizedBox(height: 20),
                    Text(
                      "Current Friends",
                      style: TextStyle(color: Color.fromARGB(255, 174, 219, 255), fontSize: 36, fontWeight: FontWeight.w900),
                    ),
                    // You can add content here for current friends if needed
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