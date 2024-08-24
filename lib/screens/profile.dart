import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skillup/functions/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../router.dart';

// Pull the user from the database
// (Assume this part of the code will be implemented later)

// WIDGET
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late CurrentUser user;
  final TextEditingController _usernameController =
      TextEditingController(text: "");
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
      _usernameController.text =
          user.name ?? ''; // Optionally set the initial text
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
      child: _isUserDataLoaded
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
                          color: Colors.black.withOpacity(0.4),
                          /*gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 174, 219, 255),
                              Colors.white
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),*/
                        ),
                        height: 370,
                        width: 0.9 * screenWidth,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.person,
                                    size: 100,
                                    color: Colors.white,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        user.name ?? '',
                                        style: GoogleFonts.montserrat(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        user.email ?? '',
                                        style: GoogleFonts.montserrat(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Container(
                                      width: 270,
                                      child: TextField(
                                        style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.0,
                                        ),
                                        controller: _usernameController,
                                        decoration: InputDecoration(
                                          labelText: "Edit your Username",
                                          hintText: "Username",
                                          filled: true,
                                          fillColor: const Color(0xffffffff).withOpacity(0.2),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10.0),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 30.0,
                                    ),
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(FirebaseAuth.instance.currentUser?.uid)
                                          .update({
                                        'name': _usernameController.text,
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Checkmark button pressed')),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 70,
                              ),
                              ElevatedButton(
                                style: TextButton.styleFrom(
                                  backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                                ),
                                onPressed: () {
                                  FirebaseAuth.instance.signOut();
                                  context.go(NavigationRoutes.login);// Log out functionality
                                },
                                child: const Text(
                                  'Log Out',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              ElevatedButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () {
                                  // Delete account functionality
                                },
                                child: const Text(
                                  'Delete Account',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
