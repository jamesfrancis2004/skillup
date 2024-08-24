import 'package:flutter/material.dart';


// Pull the user from the database
// (Assume this part of the code will be implemented later)

// WIDGET 
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});  

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
                  margin: EdgeInsets.only(top: 50.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blue,
                  ),
                  height: 400,
                  width: 0.9 * screenWidth,
                  child: Padding(
                    padding: EdgeInsets.only(top: 50.0), // Margin at the top
                    child: Column(
                      children: [
                        Row(children: [
                          Column(children: [
                            const Text(
                              'JamesHocking542',
                              style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w700),
                            ),
                            const Text(
                              'jameshocking542@gmail.com',
                              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                          ]),
                          Icon(
                            Icons.person,
                            size: 100, // Size of the icon
                            color: Colors.blue, // Color of the icon
                          ),
                        ]),
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
                          onPressed: () {},
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