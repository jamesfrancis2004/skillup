import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();

}


class _LoginPageState extends State<LoginPage> {
  String username = "";
  String password = "";
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: const [Color(0xff82f0ff),Color(0xff4c9dd8),Color(0xff0861a8)],
            begin: Alignment.center,
            end: Alignment.bottomCenter,
          )
        ),
        child: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
            )

          )
        )


      )
    );


  }


}