import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../router.dart';




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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "SkillUp",
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                    ),
                  ),
                  Text(
                    "Making a better you",
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    )
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 80,
                  ),
                  TextField(
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0,
                      ),
                      onChanged: (text) {
                        username = text;
                      },
                      decoration: InputDecoration(
                          hintText: "Email or Username",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          )
                      )
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height / 70, 0, 0),
                    child: TextField(
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.0
                        ),
                        obscureText: _obscureText,
                        onChanged: (text) {
                          password = text;
                        },
                        decoration: InputDecoration(
                            hintText: "Password",
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText ? Icons.visibility : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                }
                            )
                        )

                    ),

                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0.0, MediaQuery.of(context).size.height / 150, 0, 0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: (){
                                return context.go(NavigationRoutes.forgotPassword);
                              },
                              child: Row(
                                  children: [
                                    Text(
                                        "Forgot Password",
                                        style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        )
                                    ),
                                    Icon(
                                        Icons.arrow_right,
                                        color: Colors.white),
                                  ]
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  try {
                                    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                      email: username,
                                      password: password,
                                    );
                                    return context.go(NavigationRoutes.home);
                                  } on FirebaseAuthException {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                              title: const Text("Error logging in"),
                                              content: const Text("Invalid email or password"),
                                              actions: <Widget>[
                                                ElevatedButton(
                                                    child: Text("Ok"),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    }

                                                )
                                              ]
                                          );
                                        }
                                    );

                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        " Login ",
                                        style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 20.0,
                                        )
                                    ),
                                    // Icon(
                                    //     Icons.arrow_right,
                                    //     color: Colors.black
                                    // ),
                                  ],
                                )
                            ),
                          ]
                      )
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0.0, MediaQuery.of(context).size.height / 100, 0.0, 0.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                  color: Colors.white,
                                  width: 2.0,
                                )
                            )
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  "Don't have an account?",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                  )
                              ),
                              TextButton(
                                onPressed: () {
                                  return context.go(NavigationRoutes.signUp);
                                },
                                child: Text(
                                    "Sign Up",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.white,
                                      decorationThickness: 0.7,
                                    )
                                ),
                              )
                            ]
                        ),
                      )
                  ),



                ]
              )



            )

          )
        )


      )
    );


  }


}