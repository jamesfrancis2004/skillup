
import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:skillup/config.dart';


// CONFIG ... 

const double _textHorizontalInset = 10.0;
const double _testVerticalInset = 5.0;
const double _mainSkillTileHeight = 150.0;
const double _borderRadius = 4.0;
const double _gradientBorderWidth = 1.0;

const double _challengesVerticalSpacing = 10;
const double _challengesHeight = 60;
const double _challengeBorderRadius = 4.0;
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

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: horizontalInset, 
        right: horizontalInset,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_borderRadius),
        child: SizedBox(
          height: _challengesHeight,
          child: Container(
            decoration: BoxDecoration(
              color: _challengeBackgroundColour,
              borderRadius: BorderRadius.circular(_challengeBorderRadius),
            ),
          ),
        ),
      )
    );
  }
}
