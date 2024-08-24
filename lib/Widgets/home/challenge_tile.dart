
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
const Color _challengeBackgroundColour = Color.fromARGB(255, 94, 127, 147);
const Color _completionStrikethroughColour = Color.fromARGB(255, 20, 20, 20);
const double _completionStrikethroughHeight = 3;

// Variables

const String skill = "Baking";
const String imageUrl = "https://as2.ftcdn.net/v2/jpg/01/63/66/31/1000_F_163663122_eVANz0UTseAdSbmaZMOBT6tTLv49hvzC.jpg";



// TILE ...


class _SimpleChallengeTile extends StatefulWidget {

  final String description;
  final String tier;
  final bool finished;

  const _SimpleChallengeTile({
    super.key, 
    required this.tier, // STRING | The tier of the challenge. One of ['bronze', 'silver', 'gold']
    required this.description, // STRING | The description of the challenge
    required this.finished, // BOOL | Whether the challenge has been completed
  });
  
  @override
  State<_SimpleChallengeTile> createState() => _SimpleChallengeTileState();
}

class _SimpleChallengeTileState extends State<_SimpleChallengeTile> {

  @override
  Widget build(BuildContext context) {
    return (() {

      // Build basic tile
      Widget simpleTile = Container(
        height: _height,
        width: MediaQuery.of(context).size.width - (2 * horizontalInset),
        decoration: BoxDecoration(
          color: _challengeBackgroundColour,
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: horizontalInset * 0.8,
            ),
            Icon(
              Icons.workspace_premium,
              size: 32,
              color: getMedalColour(widget.tier)
            ),
            const SizedBox(
              width: horizontalInset * 0.8,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - (5.5 * horizontalInset),
              child: Text(
                widget.description,
                // overflow: TextOverflow.fade,
                // softWrap: true,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold, 
                  color: Theme.of(context).colorScheme.onPrimary, 
                  fontSize: 15.0,
                )
              ),
            )
          ],
        ),
      );
      
      // Add crossout and shading if completed
      if (widget.finished) {
        simpleTile = Stack(
          children: [
            simpleTile,
            Container(
              height: _height,
              width: MediaQuery.of(context).size.width - (2 * horizontalInset),
              decoration: BoxDecoration(
                color: const Color.fromARGB(150, 0, 0, 0),
                borderRadius: BorderRadius.circular(_borderRadius),
              ),
            ),
            // Center(
            //   child: Container(
            //     width: MediaQuery.of(context).size.width - (3.25 * horizontalInset),
            //     height: _completionStrikethroughHeight,
            //     color: _completionStrikethroughColour
            //   )
            // )
          ],
        );
      }

      return simpleTile;
    })();
  }
}



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
    return SizedBox(
      height: _height,
      child: 
      
      // Container(
      //   width: 100,
      //   height: 100,
      //   decoration: BoxDecoration(
      //     color: _challengeBackgroundColour,
      //     borderRadius: BorderRadius.circular(_borderRadius),
      //   ),
      // ),
      
      ListView( 
        scrollDirection: Axis.horizontal,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [

          // Padding left
          const SizedBox(
            width: horizontalInset
          ),

          widget.finished ? 
          _SimpleChallengeTile(
              tier: widget.tier,
              description: widget.description,
              finished: true,
          )
          : 
          Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.startToEnd,  // Swipe left to right
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {
                print("Dismissed :)");  // Run script when swiped left
              }
            },
            background: _SimpleChallengeTile(
              tier: widget.tier,
              description: widget.description,
              finished: true,
            ),
            child: _SimpleChallengeTile(
              tier: widget.tier,
              description: widget.description,
              finished: widget.finished,
            ),
          ),


          // // Main challenge tile
          // Container(
          //   height: _height,
          //   width: MediaQuery.of(context).size.width - (2 * horizontalInset),
          //   decoration: BoxDecoration(
          //     color: _challengeBackgroundColour,
          //     borderRadius: BorderRadius.circular(_borderRadius),
          //   ),
          // ),

          // Padding right
          const SizedBox(
            width: horizontalInset
          )
        ]
      )
    );
  }
}
