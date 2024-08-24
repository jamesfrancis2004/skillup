import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:skillup/config.dart';


// CONFIG ... 

const double _textHorizontalInset = 10.0;
const double _testVerticalInset = 5.0;
const double _height = 100.0;
const double _borderRadius = 4.0;
const double _gradientBorderWidth = 1.0;




// Variables

const String skill = "Baking";


// MAIN SKILL TILE ...

class MainSkillTile extends StatefulWidget {
  const MainSkillTile({
    super.key, 
  });
  
  @override
  State<MainSkillTile> createState() => _MainSkillTileState();
}


class _MainSkillTileState extends State<MainSkillTile> {
  String _skillDataFuture = "";

  @override
  void initState() {
    super.initState();
    _skillDataFuture = skill;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: _height,  
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_borderRadius),
        child: Stack(
          fit: StackFit.expand,
          children: [

            // Background image for the widget
            CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: (
                Theme.of(context).brightness == Brightness.light ?
                _skillDataFuture : 'https://as2.ftcdn.net/v2/jpg/01/63/66/31/1000_F_163663122_eVANz0UTseAdSbmaZMOBT6tTLv49hvzC.jpg'), // https://as2.ftcdn.net/v2/jpg/01/63/66/31/1000_F_163663122_eVANz0UTseAdSbmaZMOBT6tTLv49hvzC.jpg
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

            // Text shading underlay
            Padding(
              padding: const EdgeInsets.only(top: _height - 50),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color.fromARGB(0, 0, 0, 0), Color.fromARGB(150, 0, 0, 0), Color.fromARGB(150, 0, 0, 0)]
                  )
                ),
              ),
            ),

            // Coloured / gradient overlay for the image
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_borderRadius),
                border: GradientBoxBorder(
                  gradient: (
                    Theme.of(context).brightness == Brightness.dark ? 
                    highlightGradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFF4C9DD8), Color(0xFF4C9DD8)],
                    )
                  ),
                  width: _gradientBorderWidth,
                ),

                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0x1182F0FF), Color(0x114C9DD8), Color(0x110861A8)]
                ),
              )
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
                      skill,
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
                      'Learn to bake bread',
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
                  'See more',
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
            ),

            // NOTE: Use IgnorePointer class to allow elements on top of inkwell to let clicks through

          ]
        )
      )
    );
  }
}
