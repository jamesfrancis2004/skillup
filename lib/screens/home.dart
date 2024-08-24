import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:skillup/widgets/home/main_skill_tile.dart';
import 'package:skillup/widgets/home/challenge_tile.dart';
import 'package:skillup/config.dart';


/* 

  NOTE
  Current setup is designed to only work with 1 instance of HomePage at any time

*/ 


// CONFIG
const double _verticalSpacing = majorVerticalSpacing;

const double _challengesVerticalSpacing = 10;
const double _resourcesVerticalSpacing = 10;
const double _resourcesHeight = 60;
const double _resourcesBorderRadius = 4.0;
const Color _resourcesBackgroundColour = Color.fromARGB(255, 70, 70, 75);

const double _subheadingGradientHeight = 3;
const double _subheadingGradientWidth = 60;

const double _filterHorizontalInset = 0;


// WIDGET 
class HomePage extends StatefulWidget {
  const HomePage({super.key});  
  
  @override
  State<HomePage> createState() => _HomePageState();

  // Allow controlling scroll via HomePage
  static final ScrollController _scrollController = ScrollController();
  static void scrollToTop() {
    _scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }
}


// STATE
class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,

      //color: Theme.of(context).colorScheme.primary,
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

      child: RefreshIndicator(
        color: Theme.of(context).colorScheme.onTertiaryContainer,
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 1500));
          setState(() {
            HomePage.scrollToTop();
          });
        },
        child: ListView(
          controller: HomePage._scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [

            // Top padding
            const SizedBox(
              height: _verticalSpacing,
            ),

            // Current goal title
            Padding(
              padding: const EdgeInsets.only(
                left: horizontalInset, 
                right: horizontalInset, 
                bottom: 15
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [

                  // The title of the row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Current Goal",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold, 
                          color: Theme.of(context).colorScheme.onPrimary, 
                          fontSize: 15.0
                        )
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: _filterHorizontalInset),
                        child: SizedBox(
                          width: 0,
                          height: 0
                        )
                      ),
                    ]
                  ),

                  // The gradient subheading 
                  Container(
                    height: _subheadingGradientHeight,
                    width: _subheadingGradientWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: highlightGradient
                    )
                  ),

                ]
              )
            ),
            
            // Main skill tile
            const Padding(
              padding: EdgeInsets.only(
                left: horizontalInset, 
                right: horizontalInset
              ),
              child: MainSkillTile()
            ),

            // Padding
            const SizedBox(
              height: _verticalSpacing,
            ),

            // Challenges title
            Padding(
              padding: const EdgeInsets.only(
                left: horizontalInset, 
                right: horizontalInset, 
                bottom: 15
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [

                  // The title of the row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Challenges",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold, 
                          color: Theme.of(context).colorScheme.onPrimary, 
                          fontSize: 15.0
                        )
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: _filterHorizontalInset),
                        child: SizedBox(
                          width: 0,
                          height: 0
                        )
                      ),
                    ]
                  ),

                  // The gradient subheading 
                  Container(
                    height: _subheadingGradientHeight,
                    width: _subheadingGradientWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: highlightGradient
                    )
                  ),

                ]
              )
            ),

            // Challenges
            Column(
              children: [

                // Challenge 1
                const ChallengeTile(tier: 'bronze', description: 'Bake pretzels', finished: false),

                // Padding
                const SizedBox(
                  height: _challengesVerticalSpacing
                ),

                // Challenge 2
                const ChallengeTile(tier: 'silver', description: 'Bake sour dough', finished: false),

                // Padding
                const SizedBox(
                  height: _challengesVerticalSpacing
                ),

                // Challenge 3
                const ChallengeTile(tier: 'gold', description: 'Bake banana bread', finished: false),
              ],
            ),

            // Padding
            const SizedBox(
              height: _verticalSpacing,
            ),

            // Resources title
            Padding(
              padding: const EdgeInsets.only(
                left: horizontalInset, 
                right: horizontalInset, 
                bottom: 15
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [

                  // The title of the row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Resources",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold, 
                          color: Theme.of(context).colorScheme.onPrimary, 
                          fontSize: 15.0
                        )
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: _filterHorizontalInset),
                        child: SizedBox(
                          width: 0,
                          height: 0
                        )
                      ),
                    ]
                  ),

                  // The gradient subheading 
                  Container(
                    height: _subheadingGradientHeight,
                    width: _subheadingGradientWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: highlightGradient
                    )
                  ),
                ]
              )
            ),

            // Resources
            Padding(
              padding: const EdgeInsets.only(
                left: horizontalInset, 
                right: horizontalInset
              ),
              child: Column(
                children: [

                  // Resource 1
                  SizedBox(
                    height: _resourcesHeight,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _resourcesBackgroundColour,
                        borderRadius: BorderRadius.circular(_resourcesBorderRadius),
                      ),
                    )
                  ),

                  // Padding
                  const SizedBox(
                    height: _resourcesVerticalSpacing
                  ),

                  // Resource 2
                  SizedBox(
                    height: _resourcesHeight,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _resourcesBackgroundColour,
                        borderRadius: BorderRadius.circular(_resourcesBorderRadius),
                      ),
                    )
                  ),

                  // Padding
                  const SizedBox(
                    height: _resourcesVerticalSpacing
                  ),

                  // Resource 3
                  SizedBox(
                    height: _resourcesHeight,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _resourcesBackgroundColour,
                        borderRadius: BorderRadius.circular(_resourcesBorderRadius),
                      ),
                    )
                  ),
                ],
              )
            ),

            // Bottom spacing
            SizedBox(
              height: MediaQuery.of(context).size.height / 4,
            ),

          ]
        )
      )
    );
  }
}
