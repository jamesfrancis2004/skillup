import 'package:flutter/material.dart';


// WIDGET 
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});  

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}


// STATE
class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ColoredBox(
        color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('EXPLORE', style: Theme.of(context).textTheme.headlineMedium)
          ],
        )
      )
    );
  }
}
