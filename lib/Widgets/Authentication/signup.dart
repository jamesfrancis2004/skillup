import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skillup/Widgets/Authentication/password_error_box.dart';

import '../../router.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

flashErrorAlert(BuildContext context, String error, String errorMessage) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text(error),
            content: Text(errorMessage),
            actions: <Widget> [
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



class SignUpController {
  static bool validSignUpInputs(
      String firstName,
      String lastName,
      String email,
      String password,
      String confirmPassword,
      BuildContext context) {
    if (firstName == "") {
      flashErrorAlert(context, "No First Name", "Please Enter First Name");
    } else if (lastName == "") {
      flashErrorAlert(context, "No Last Name", "Please Enter Last Name");
    } else if (email == "") {
      flashErrorAlert(context, "No Email Address", "Please Enter Your Email");
    } else {
      if (password != confirmPassword) {
        flashErrorAlert(context, "Passwords do not match", "Password and Confirmed Password are not the same");
      } else if (password.length < 8) {
        flashErrorAlert(context, "Password too short", "Password must be at least 8 characters long");
      } else {
        int sum = 0;
        for (var x in password.characters) {sum += double.tryParse(x) != null ? 1 : 0;}
        if (sum == 0) {
          flashErrorAlert(context, "No Numeric Characters in Password", "Password must contain numeric characters");
        } else {
          return true;
        }
      }
    }
    return false;
  }
}



class _SignUpPageState extends State<SignUpPage> {
  String firstName = "";
  String lastName = "";
  String email = "";
  String password = "";
  String confirmPassword = "";
  bool _obscurePasswordText = true;
  bool _obscureConfirmPasswordText = true;
  bool _passwordError = true;
  void changePassword(String text) {
    setState(() {
      password = text;
    });
  }
  void changeConfirmPassword(String text) {
    setState(() {
      confirmPassword = text;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff82f0ff),Color(0xff4c9dd8),Color(0xff0861a8)],
              // colors: [Colors.grey.shade100, Colors.grey.shade500],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )
        ),
        child: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: Column(
                children: [
                  Text(
                      "Create a Profile",
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 22.0
                      )
                  ),
                  Padding (
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 50),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextField(
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.0,
                                  ),
                                  onChanged: (text) {
                                    firstName = text;
                                  },
                                  decoration: InputDecoration(
                                      hintText: "First Name",
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: BorderSide.none,
                                      )
                                  )
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.03,
                            ),
                            Expanded(
                                child: TextField(
                                    onChanged: (text) {
                                      lastName = text;
                                    },
                                    decoration: InputDecoration(
                                        hintText: "Last Name",
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                          borderSide: BorderSide.none,
                                        )
                                    ),
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.0,
                                    )
                                )
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 80,
                            ),

                          ],

                      ),

                    ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 80,
                  ),
                  TextField(
                    onChanged: (text) {
                      email = text;
                    },
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0,
                    ),
                    decoration: InputDecoration(
                      hintText: "Email",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 80,
                  ),
                  TextField(
                    onChanged: (text) {
                      changePassword(text);
                      //this.password = text;
                    },
                    obscureText: _obscurePasswordText,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0,
                    ),
                    decoration: InputDecoration(
                        hintText: "Password",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePasswordText ? Icons.visibility :
                              Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePasswordText = !_obscurePasswordText;
                              });
                            }
                        )
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 80,
                  ),
                  TextField(
                    onChanged: (text) {
                      changeConfirmPassword(text);
                    },
                    obscureText: _obscureConfirmPasswordText,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0,
                    ),
                    decoration: InputDecoration(
                        hintText: "Confirm Password",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                            icon: Icon(_obscureConfirmPasswordText ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPasswordText = !_obscureConfirmPasswordText;
                              });
                            }
                        )

                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 100,
                  ),
                  PasswordErrorBox(
                    password: password,
                    confirmPassword: confirmPassword,

                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 200,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (SignUpController.validSignUpInputs(
                          firstName,
                          lastName,
                          email,
                          password,
                          confirmPassword,
                          context,
                        )) {
                          try {
                            UserCredential userCredential = await FirebaseAuth
                                .instance.createUserWithEmailAndPassword(
                              email: email,
                              password: password,
                            );
                            await FirebaseFirestore.instance.collection("users")
                                .doc(userCredential.user?.uid).set(
                                {
                                  'name': firstName,
                                  'friends': [],
                                  'email': email,
                                });
                            return context.go(NavigationRoutes.home);
                          } on FirebaseAuthException catch (e) {
                            print(e.message);
                            flashErrorAlert(context, "Error Signing up", "There was an error signing up");
                          }


                        }
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                "Sign Up",
                                style: GoogleFonts.montserrat (
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )
                            ),
                          ]
                      )
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 200,
                          bottom: MediaQuery.of(context).size.height / 200),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                                "Already have an account?",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.0,
                                )
                            ),
                            TextButton(
                                onPressed: () {
                                  return context.go(NavigationRoutes.login);
                                },
                                child: Text(
                                  "Sign In",
                                  style: GoogleFonts.montserrat (
                                    color: Colors.white,
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white,
                                    decorationThickness: 0.7,
                                  ),
                                )
                            )
                          ]
                      )
                  ),






                ],



                )
              )
            )
          )
        )


      );
  }

}



