import 'package:flutter/material.dart';


// WIDGET 
class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});  
  
  @override
  State<FriendsPage> createState() => _FriendsPageState();

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
class _FriendsPageState extends State<FriendsPage> {
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
            FriendsPage.scrollToTop();
          });
        },
        child: ListView(
          controller: FriendsPage._scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Container(
              height: 100,
              width: 100,
              color: Colors.red, 
            ),
          ]
        )
      )
    );
  }
}