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
                          fillColor: const Color(0xffffffff).withOpacity(0.2),
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
                            fillColor: Color(0xffffffff).withOpacity(0.2),
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
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xffffffff).withOpacity(0.2),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        " Login ",
                                        style: GoogleFonts.montserrat(
                                          color: Color.fromARGB(255, 174, 219, 255),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                        )
                                    ),
                                    const Icon(
                                        Icons.arrow_right,
                                        color: Color.fromARGB(255, 174, 219, 255),
                                    ),
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