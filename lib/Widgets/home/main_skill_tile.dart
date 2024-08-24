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




// Variables

const String skill = "Baking";
const String imageUrl = "https://as2.ftcdn.net/v2/jpg/01/63/66/31/1000_F_163663122_eVANz0UTseAdSbmaZMOBT6tTLv49hvzC.jpg";


// MAIN SKILL TILE ...

class MainSkillTile extends StatefulWidget {
  final String category;
  final String description;

  const MainSkillTile({
    super.key, 
    required this.category,
    required this.description
  });
  
  @override
  State<MainSkillTile> createState() => _MainSkillTileState();
}


class _MainSkillTileState extends State<MainSkillTile> {
  String _skillDataFuture = "";

  @override
  void initState() {
    super.initState();
    _skillDataFuture = imageUrl; // skill
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: _mainSkillTileHeight,  
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_borderRadius),
        child: Stack(
          fit: StackFit.expand,
          children: [

            // Background image for the widget
            CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: _skillDataFuture, // https://as2.ftcdn.net/v2/jpg/01/63/66/31/1000_F_163663122_eVANz0UTseAdSbmaZMOBT6tTLv49hvzC.jpg
              placeholder: (context, url) => SkeletonAnimation(
                shimmerColor: Theme.of(context).colorScheme.onTertiaryContainer,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                  ),
                )
              ),
              // errorWidget: BoxDecoration(),
            ),

            // Coloured / gradient overlay for the image
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_borderRadius),
                border: const GradientBoxBorder(
                  gradient: highlightGradient,
                  width: _gradientBorderWidth,
                ),

                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color.fromARGB(100, 61, 113, 119), Color.fromARGB(100, 34, 71, 97), Color.fromARGB(100, 3, 46, 81)]
                  // colors: [Color(0x88000000), Color(0x66000000), Color(0x88000000)]
                  // colors: [Color(0x1182F0FF), Color(0x114C9DD8), Color(0x110861A8)]
                ),
              )
            ),
            
            // Text shading underlay
            Padding(
              padding: const EdgeInsets.only(top: _mainSkillTileHeight - 60),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(0, 0, 0, 0), Color.fromARGB(100, 0, 0, 0), 
                      Color.fromARGB(100, 0, 0, 0), Color.fromARGB(100, 0, 0, 0)
                    ]
                  )
                ),
              ),
            ),

            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                // Skill type
                Padding(
                  padding: const EdgeInsets.only(
                    left: _textHorizontalInset
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child : Text(
                      widget.category,
                      softWrap: false,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w800, 
                        color: Colors.grey.shade300, 
                        fontSize: 18.0,
                        height: 0.85
                      ),
                    )
                  )
                ),

                // Skill description
                Padding(
                  padding: const EdgeInsets.only(
                    left: _textHorizontalInset,
                    bottom: _testVerticalInset
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child : Text(
                      widget.description,
                      softWrap: false,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600, 
                        color: Colors.grey.shade300, 
                        fontSize: 12.0,
                      )
                    )
                  )
                ),

              ],
            ),

            // Right side prompt
            Padding(
              padding: const EdgeInsets.only(
                right: _textHorizontalInset,
                bottom: _testVerticalInset
              ),
              child: Align(
                alignment: Alignment.bottomRight,
                child : Text(
                  'Learn more',
                  softWrap: false,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600, 
                    color: Colors.grey.shade500, 
                    fontSize: 12.0
                  )
                )
              )
            ),

            // InkWell object that handles clicks and renders the click effects
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => {print('pressed main skill tile')}
              ),
            )
          ]
        )
      )
    );
  }
}