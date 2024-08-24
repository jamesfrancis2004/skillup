import 'package:flutter/material.dart';
import 'package:skillup/functions/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

const outgoingRequests = ["Bob", "CHOIC", "Daniel"];
const incomingRequests = ["Daniel", "James", "Josh"];

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
  var showRequestError = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    user = await CurrentUser.create(FirebaseAuth.instance.currentUser!.uid);
    setState(() {});
  }

  // Function to update whether showing error
  void getStatusOfRequest() async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 1)); // Simulating network delay
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
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "Send Friend Request",
                      style: TextStyle(color: Color.fromARGB(255, 174, 219, 255), fontSize: 24, fontWeight: FontWeight.w900),
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
                            getStatusOfRequest();
                          },
                        ),
                      ],
                    ),
                    showRequestError
                        ? Text(
                            'Failed to find user',
                            style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w700),
                          )
                        : SizedBox(height: 1),
                    SizedBox(height: 20),
                    const Text(
                      "Pending Requests",
                      style: TextStyle(color: Color.fromARGB(255, 174, 219, 255), fontSize: 24, fontWeight: FontWeight.w900),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: incomingRequests.map((request) {
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
                    const Text(
                      "Sent Requests",
                      style: TextStyle(color: Color.fromARGB(255, 174, 219, 255), fontSize: 24, fontWeight: FontWeight.w900),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: outgoingRequests.map((request) {
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
                    const Text(
                      "Current Friends",
                      style: TextStyle(color: Color.fromARGB(255, 174, 219, 255), fontSize: 36, fontWeight: FontWeight.w900),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: outgoingRequests.map((request) {
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
                    ),// Display current friends similarly
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
