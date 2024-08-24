import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class PasswordErrorBox extends StatefulWidget {
  final String password;
  final String confirmPassword;
  PasswordErrorBox({super.key,
    required this.password,
    required this.confirmPassword});

  @override
  _PasswordErrorBox createState() => _PasswordErrorBox();
}



class _PasswordErrorBox extends State<PasswordErrorBox>{
  bool error = false;
  String message = "";
  @override
  Widget build(BuildContext context) {
    int sum = 0;
    for (var x in widget.password.characters) {sum += double.tryParse(x) != null ? 1 : 0;}
    if (widget.password.length < 8) {
      error = true;
      message = "Password must be at least 8 characters";
    } else if (sum < 1) {
      error = true;
      message = "Password must contain one numeric character";
    } else if (widget.password != widget.confirmPassword) {
      error = true;
      message = "Passwords do not match";
    } else {
      error = false;
    }
    if (widget.password == "") {
      return Container(height: 0);
    }
    if (!error) {
      return Container(
          height: MediaQuery.of(context).size.height * 0.03,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              gradient: LinearGradient(
                colors: [Colors.green, Color(0x0ff489d7)],
              )
          ),
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.03,
                ),
                Text(
                    "Strong Password",
                    style: GoogleFonts.montserrat (
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 12.0,
                    )
                )]
          )
      );
    }
    return Container(
        height: MediaQuery.of(context).size.height * 0.03,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Color(0xFFf6c3c2),
        ),
        child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.03,
              ),
              Text(
                  message,
                  style: GoogleFonts.montserrat(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                  )
              )
            ]
        )

    );

  }
}