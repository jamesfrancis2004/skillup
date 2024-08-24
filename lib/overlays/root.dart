import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import 'package:skillup/router.dart';
import 'package:skillup/config.dart';
import 'package:skillup/screens/home.dart';
import 'package:skillup/overlays/app_bar_solid.dart';


/* Docs / useful info

  AppBar: https://api.flutter.dev/flutter/material/AppBar-class.html
  
*/


// CONFIG
const double _bottomBarGradientWidth = 1.0;


// SCAFFOLD
class AppScaffold extends StatefulWidget {
  final Widget child;
  const AppScaffold({super.key, required this.child});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}


// STATE
class _AppScaffoldState extends State<AppScaffold> {

  // The currrently selected index from the bottom navigation bar
  int _selectedIndex = NavigationRoutes.startingBottomNavBarIndex;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const AppBarSolid(),

      // Set the body to the content of whichever page is using this overlay
      body: widget.child,

      // The bottom navigation bar
      bottomNavigationBar: Stack(
        children: [
          BottomNavigationBar(
            onTap: _onItemTapped,
            currentIndex: _selectedIndex,
            type: BottomNavigationBarType.fixed,
            // showSelectedLabels: false,
            // showUnselectedLabels: false,
            selectedItemColor: Theme.of(context).colorScheme.onTertiary,
            unselectedItemColor: Theme.of(context).colorScheme.tertiary,
            backgroundColor: Theme.of(context).colorScheme.primary,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
              BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Contribute'),
              BottomNavigationBarItem(icon: Icon(Icons.forum), label: 'Community'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            ]
          ),
          Container(
            height: _bottomBarGradientWidth,
            decoration: const BoxDecoration(
              gradient: highlightGradient
            )
          )
        ]
      )
    );
  }

  // Tap event handler for bottom navigation bar
  void _onItemTapped(int index) {

    if (index >= NavigationRoutes.bottomNavBarLen) {
      throw RangeError('Recieved invalid index for bottom nav bar: Recieved [$index]');
    }
    
    // Scroll to top if selected again while already on page
    if (index == _selectedIndex) {
      if (index == NavigationRoutes.indexInBottomNavBar[NavigationRoutes.home]) {
        HomePage.scrollToTop();
      } 
      else if (index == NavigationRoutes.indexInBottomNavBar[NavigationRoutes.explore]) {
      } 
      else if (index == NavigationRoutes.indexInBottomNavBar[NavigationRoutes.contribute]) {
      } 
      else if (index == NavigationRoutes.indexInBottomNavBar[NavigationRoutes.community]) {
      } 
      else if (index == NavigationRoutes.indexInBottomNavBar[NavigationRoutes.profile]) {
      } 
      else { 
        throw RangeError("DEV ERROR: Did't find a match for index [$index] in bottom nav bar tap handler");
      }
    }

    _selectedIndex = index;
    
    context.go(NavigationRoutes.bottomNavBarPaths[index]);
  }

}

