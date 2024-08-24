import 'package:flutter/material.dart';
import 'package:skillup/functions/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Pull the user from the database
// (Assume this part of the code will be implemented later)



// WIDGET 
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});  

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _usernameController = TextEditingController(text: 'JamesHocking542');
  late CurrentUser user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    user = await CurrentUser.create(FirebaseAuth.instance.currentUser!.uid);
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start, // Keep it at the top
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              double screenWidth = constraints.maxWidth;

              return Center(
                child: Container(
                  
                  margin: const EdgeInsets.only(top: 50.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [Color.fromARGB(255, 174, 219, 255), Colors.white], // Gradient colors
                      begin: Alignment.topLeft, // Start position of the gradient
                      end: Alignment.bottomRight, // End position of the gradient
                    ),
                  ),
                  height: 370,
                  width: 0.9 * screenWidth,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0), // Margin at the top
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Icon(
                            Icons.person,
                            size: 100, // Size of the icon
                            color: Colors.black, // Color of the icon
                          ),
                          Column(children: [
                            Text(
                              'JamesHocking542',
                              style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                            Text(
                              'jameshocking542@gmail.com',
                              style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                          ]),
                        ]),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Center(
                          child: Container(
                            width: 270, // Set the width of the container
                            child: TextField(
                              style: TextStyle(color: Colors.black),
                              controller: _usernameController, // Default username
                              decoration: InputDecoration(
                                labelText: 'Change your username',
                                labelStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black), // Border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black), // Border color when focused
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black), // Border color when enabled
                                    ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                            icon: Icon(
                                Icons.check, // Send message icon
                                color: Colors.black, // Icon color
                                size: 30.0, // Icon size
                              ), // Checkmark icon
                            onPressed: () {
                              // Handle button press
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Checkmark button pressed')),
                              );
                            },
                          ),
                        ],),            
                        SizedBox(height: 50),
                        ElevatedButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: null,
                          child: const Text(
                          'Log Out',
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                        ),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text(
                          'Delete Account',
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                        ),
                          onPressed: () {
                            user.deleteUserFromFirestore();
                            user.removeUserFromAllFriendsLists();
                          },
                        ),
                      ],
                    ),
                  )
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}