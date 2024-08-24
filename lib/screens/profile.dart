import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skillup/functions/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../router.dart';


class MedalTally extends StatefulWidget {
  final String medalType; // STRING | The type of the medal. One of ['gold', 'silver', 'bronze']

  const MedalTally({
    super.key,
    required this.medalType,
  });

  @override
  State<MedalTally> createState() => _MedalTallyState();
}

class _MedalTallyState extends State<MedalTally> {
  late IconData _medalIcon;
  late Color _medalColor;

  @override
  void initState() {
    super.initState();
    switch (widget.medalType) {
      case 'gold':
        _medalIcon = Icons.workspace_premium;
        _medalColor = Colors.amber;
        break;
      case 'silver':
        _medalIcon = Icons.workspace_premium;
        _medalColor = Colors.grey;
        break;
      case 'bronze':
        _medalIcon = Icons.workspace_premium;
        _medalColor = Colors.brown;
        break;
      default:
        _medalIcon = Icons.help_outline;
        _medalColor = Colors.black;
    }
  }

  Future<int> _getMedalCount(String medalType) async {
    final userDoc = await FirebaseFirestore.instance.collection("users").doc(
        FirebaseAuth.instance.currentUser?.uid
    ).get();
    if (userDoc.exists) {
      final data = userDoc.data();
      return data?[medalType] as int;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: _getMedalCount(widget.medalType),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show loading indicator while waiting for data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final medalCount = snapshot.data ?? 0;

          return Row(
            children: [
              Icon(_medalIcon, color: _medalColor),
              const SizedBox(width: 8),
              Text(
                '$medalCount',
                style: TextStyle(fontSize: 24, color: _medalColor),
              ),
            ],
          );
        }
      },
    );
  }
}

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
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    user = await CurrentUser.create(FirebaseAuth.instance.currentUser!.uid);
    setState(() {
      _isUserDataLoaded = true;
      _usernameController.text = user.name ?? ''; // Set initial text
    });
  }

  Future<void> _updateUsername() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({'name': _usernameController.text});

    // Update the user object with the new name
    setState(() {
      user.name = _usernameController.text;
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Username updated successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container (
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
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black.withOpacity(0.4),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        user.name ?? '',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        user.email ?? '',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 20),
                      if (_isEditing)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextField(
                            controller: _usernameController,
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                            decoration: InputDecoration(
                              // labelText: "Edit your Username",
                              hintText: "Username",
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_isEditing)
                            IconButton(
                              icon: Icon(Icons.check, color: Colors.white),
                              onPressed: _updateUsername,
                            ),
                          IconButton(
                            icon: Icon(
                              _isEditing ? Icons.cancel : Icons.edit,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _isEditing = !_isEditing;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffffffff).withOpacity(0.2),
                        ),
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          context.go(NavigationRoutes.login);
                        },
                        child: Text(
                          'Log Out',

                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      if (_isEditing)
                        ElevatedButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () {
                            // Delete account functionality
                          },
                          child: Text(
                            'Delete Account',
                            style: GoogleFonts.montserrat (
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      MedalTally(medalType: "gold"),
                      MedalTally(medalType: "silver"),
                      MedalTally(medalType: "bronze"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}