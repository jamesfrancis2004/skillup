import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


// WIDGET 
class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});  
  
  @override
  State<ExplorePage> createState() => _ExplorePageState();
}


// STATE
class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.80,
          child: Column(
            children: [
              Text("Community",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,

                  )
              ),

            ]
          )
        )
      )
    );
  }
}
