
import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:skillup/config.dart';


// CONFIG ... 

const double _borderRadius = 4.0;
const double _height = 60;
const Color _challengeBackgroundColour = Color.fromARGB(255, 70, 70, 75);


// Variables

const String skill = "Baking";
const String imageUrl = "https://as2.ftcdn.net/v2/jpg/01/63/66/31/1000_F_163663122_eVANz0UTseAdSbmaZMOBT6tTLv49hvzC.jpg";


// MAIN SKILL TILE ...

class ChallengeTile extends StatefulWidget {

  final String description;
  final String tier;
  final bool finished;

  const ChallengeTile({
    super.key, 
    required this.tier, // STRING | The tier of the challenge. One of ['bronze', 'silver', 'gold']
    required this.description, // STRING | The description of the challenge
    required this.finished, // BOOL | Whether the challenge has been completed
  });
  
  @override
  State<ChallengeTile> createState() => _ChallengeTileState();
}


class _ChallengeTileState extends State<ChallengeTile> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: horizontalInset, 
        right: horizontalInset,
      ),
      child: Container(
        height: _height,
        decoration: BoxDecoration(
          color: _challengeBackgroundColour,
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
      ),
    );
  }
}
