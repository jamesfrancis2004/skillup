import 'package:skillup/widgets/authentication/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../router.dart';


class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String email = "";
  String emailReset = "";
  bool emailSent = false;
  void changeEmailResetText() {
    setState(() {
      emailReset = "A password reset link has been sent to: $email";
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff00274d), // Dark Blue
                    Color(0xff001f3f), // Even Darker Blue
                    Color(0xff000a1b)  // Nearly Black
                  ],
                  // colors: [Colors.grey.shade100, Colors.grey.shade500],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
            ),
            child: Center (
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              "Forgot Password",
                              style: GoogleFonts.montserrat(
                                fontSize: 20.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              )
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 100,
                          ),
                          TextField(
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold,
                                fontSize: 13.0,
                              ),
                              onChanged: (text) {
                                email = text;
                              },
                              decoration: InputDecoration(
                                  hintText: "Email",
                                  filled: true,
                                  fillColor: const Color(0xffffffff).withOpacity(0.2),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide.none,
                                  )
                              )
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 100,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        return context.go(NavigationRoutes.login);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xffffffff).withOpacity(0.2),
                                      ),
                                      child: Text(
                                          "Back",
                                          style: GoogleFonts.montserrat(
                                            color: Color.fromARGB(255, 174, 219, 255),
                                            fontWeight: FontWeight.bold,
                                          )
                                      ),
                                    )
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.03,
                                ),
                                Expanded(
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          try {
                                            await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                                            changeEmailResetText();
                                          } on FirebaseAuthException {
                                            flashErrorAlert(context, "Password Reset Error", "Invalid Email Address");
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xffffffff).withOpacity(0.2),
                                        ),
                                        child: Text(
                                            "Submit",
                                            style: GoogleFonts.montserrat(
                                              color: Color.fromARGB(255, 174, 219, 255),
                                              fontWeight: FontWeight.bold,
                                            )
                                        )
                                    )
                                ),
                              ]
                          ),
                          Text(
                            emailReset,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                        ]
                    )
                )
            )
        )
    );
  }

}