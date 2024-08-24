import 'package:flutter/material.dart';

import 'package:skillup/widgets/home/main_skill_tile.dart';

/* 

  NOTE
  Current setup is designed to only work with 1 instance of HomePage at any time

*/ 


// CONFIG
const double _selectorRowInsetHorizontal = 20;


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
      color: Theme.of(context).colorScheme.primary,
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
          children: const [
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: _selectorRowInsetHorizontal, 
                right: _selectorRowInsetHorizontal),
              child: MainSkillTile()
            ),
          ]
        )
      )
    );
  }
}
