import 'package:flutter/material.dart';



// WIDGET 
class ContributePage extends StatefulWidget {
  const ContributePage({super.key});  
  
  @override
  State<ContributePage> createState() => _ContributePageState();

  // Allow controlling scroll via FriendsPage
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
class _ContributePageState extends State<ContributePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Contribute",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ]
        )
      ),/*
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).colorScheme.primary,
      child: RefreshIndicator(
        color: Theme.of(context).colorScheme.onTertiaryContainer,
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 1500));
          setState(() {
            ContributePage.scrollToTop();
          });
        },
        child: ListView(
          controller: ContributePage._scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Container(
              height: 100,
              width: 100,
              color: Colors.blue, 
            ),
          ]
        )
      )
      */
    );
  }
}