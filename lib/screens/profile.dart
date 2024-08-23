import 'package:flutter/material.dart';


// pull the user from the database


//


// WIDGET 
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});  

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}


// STATE
class _ProfilePageState extends State<ProfilePage> {
  @ override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              double screenWidth = constraints.maxWidth;
              double screenHeight = constraints.maxHeight;

              return Container(
                width: screenWidth * 0.8, // 50% of the screen width
                height: screenHeight * 0.3, // 30% of the screen height
                color: Colors.blue,
                child: Center(
                  child: Text(
                    'Username',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
