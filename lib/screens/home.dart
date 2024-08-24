import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:skillup/widgets/home/main_skill_tile.dart';
import 'package:skillup/widgets/home/challenge_tile.dart';
import 'package:skillup/functions/skills.dart';
import 'package:skillup/functions/user.dart';
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
const Color _resourcesBackgroundColour = Color.fromARGB(255, 94, 127, 147);

const double _subheadingGradientHeight = 3;
const double _subheadingGradientWidth = 60;

const double _filterHorizontalInset = 0;


bool _isUserDataLoaded = false;
bool _isSkillDataLoaded = false;


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
  late CurrentSkill skill;
  late CurrentUser user;
  late List<bool> completions = [false, false, false];

  @override
    void initState() {
      super.initState();
      _loadSkillData();
      _loadCompletions();
    }

  Future<void> _loadSkillData() async {
    skill = await CurrentSkill.create();
    setState(() {
      _isSkillDataLoaded = true;
    });
  }


  Future<void> _loadUserData() async {
    user = await CurrentUser.create(FirebaseAuth.instance.currentUser!.uid);
    setState(() {
      _isUserDataLoaded = true;
    });
  }

  Future<void> _loadCompletions() async {
    final userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();
    if (userDoc.exists) {
      final data = userDoc.data();
      final challengesCompleted = data?['challengesCompleted'] as List<dynamic>;
      if (challengesCompleted.length >= 3) {
        for (int i = 0; i < challengesCompleted.length; ++i) {
          if (i < completions.length) {
            completions[i] = challengesCompleted[i] as bool;
          }
        }
      }
    }
    else {
      print("User document does not exist");
    }
  }

  @override
  Widget build(BuildContext context) {
    return (_isSkillDataLoaded) 
    ?
    Container(
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
          await _loadSkillData();
          await _loadCompletions();
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
            Padding(
              padding: const EdgeInsets.only(
                left: horizontalInset, 
                right: horizontalInset
              ),
              child: MainSkillTile(
                category: skill.category,
                description: skill.description,
                imageUrl: skill.imageUrl,
              )
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
                ChallengeTile(tier: 'bronze', description: skill.challenge3,
                    finished: this.completions[2]),

                // Padding
                const SizedBox(
                  height: _challengesVerticalSpacing
                ),

                // Challenge 2
                ChallengeTile(tier: 'silver', description: skill.challenge2,
                    finished: this.completions[1]),

                // Padding
                const SizedBox(
                  height: _challengesVerticalSpacing
                ),

                // Challenge 3
                ChallengeTile(tier: 'gold', description: skill.challenge1,
                    finished: this.completions[0]),
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
                    width: MediaQuery.of(context).size.width - 2 * horizontalInset,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _resourcesBackgroundColour,
                        borderRadius: BorderRadius.circular(_resourcesBorderRadius),
                      ),
                      child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                          left: 12, 
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 150,
                              height: 15,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 112, 147, 169),
                                borderRadius: BorderRadius.circular(_resourcesBorderRadius),
                              ),
                            ),
                            const SizedBox(
                              height: 10
                            ),
                            Container(
                              width: 300,
                              height: 15,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 112, 147, 169),
                                borderRadius: BorderRadius.circular(_resourcesBorderRadius),
                              ),
                            )
                          ],
                        )
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
                    width: MediaQuery.of(context).size.width - 2 * horizontalInset,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _resourcesBackgroundColour,
                        borderRadius: BorderRadius.circular(_resourcesBorderRadius),
                      ),
                      child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                          left: 12, 
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 150,
                              height: 15,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 112, 147, 169),
                                borderRadius: BorderRadius.circular(_resourcesBorderRadius),
                              ),
                            ),
                            const SizedBox(
                              height: 10
                            ),
                            Container(
                              width: 300,
                              height: 15,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 112, 147, 169),
                                borderRadius: BorderRadius.circular(_resourcesBorderRadius),
                              ),
                            )
                          ],
                        )
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
                    width: MediaQuery.of(context).size.width - 2 * horizontalInset,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _resourcesBackgroundColour,
                        borderRadius: BorderRadius.circular(_resourcesBorderRadius),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                          left: 12, 
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 150,
                              height: 15,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 112, 147, 169),
                                borderRadius: BorderRadius.circular(_resourcesBorderRadius),
                              ),
                            ),
                            const SizedBox(
                              height: 10
                            ),
                            Container(
                              width: 300,
                              height: 15,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 112, 147, 169),
                                borderRadius: BorderRadius.circular(_resourcesBorderRadius),
                              ),
                            )
                          ],
                        )
                      ),
                    )
                  ),
                ],
              )
            ),

            // Bottom spacing
            const SizedBox(
              height: horizontalInset * 1.5,
            ),

          ]
        )
      )
    )
    :
    Container(
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
      child: const Center(
        child: CircularProgressIndicator()
      )
    );
  }
}
