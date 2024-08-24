import 'package:flutter/material.dart';
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
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).colorScheme.primary,
        child: RefreshIndicator(
            color: Theme.of(context).colorScheme.onTertiaryContainer,
            backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
            onRefresh: () async {
              await Future.delayed(const Duration(milliseconds: 1500));
              setState(() {
                FriendsPage.scrollToTop();
              });
            },
            child: ListView(
                controller: FriendsPage._scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    color: Colors.red,
                  ),
                  // Add the button here
                  ElevatedButton(
                    onPressed: printUserInfo, // Call the method when pressed
                    child: Text('Print User Info'),
                  ),
                ])));
  }
}
