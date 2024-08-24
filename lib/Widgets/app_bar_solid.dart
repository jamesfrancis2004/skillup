import 'package:flutter/material.dart';
import 'package:skillup/config.dart';


// CONFIG ... 

const double _expandedheight = kToolbarHeight * 0.75;
const double _gradientWidth = 1.0;
const double _edgePadding = 20.0;
const double _bottomPadding = 10.0;


// APP BAR ..

class AppBarSolid extends StatefulWidget implements PreferredSizeWidget {
  const AppBarSolid({super.key});

  // Note that a setState() call the the appbar state must be called for changes to take effect
  static Size preferredHeight = const Size.fromHeight(_expandedheight);
  static void setHeight(double newHeight) {
    AppBarSolid.preferredHeight = Size.fromHeight(newHeight);
  }

  @override
  State<AppBarSolid> createState() => _AppBarState();

  @override
  Size get preferredSize => AppBarSolid.preferredHeight; // kToolbarHeight
}


class _AppBarState extends State<AppBarSolid>  {

  // void handleScroll() {
  //   setState(() {
  //     print('appbar scroll handler called');
  //   });
  // }

  @override
  Widget build(BuildContext context) {

    // Using PreferredSize to control height of appbar
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AppBar(
        shadowColor: null,
        surfaceTintColor: null,
        scrolledUnderElevation: 0.0,
        toolbarHeight: _expandedheight,
        backgroundColor: Theme.of(context).colorScheme.background,
        automaticallyImplyLeading: false,
        leadingWidth: 150,

        // The name on the left of the AppBar
        leading: Padding(
          padding: const EdgeInsets.only(left: _edgePadding, bottom: _bottomPadding),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              'SkillUp',
              softWrap: false,
              style: Theme.of(context).textTheme.displayMedium
            )
          )
        ),

        // The icon on the right of the app bar
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: _edgePadding, bottom: _bottomPadding),
            child: GestureDetector(
              onTap: () => {print('pressed appbar action')},
              child: Icon(
                Icons.notifications,
                size: 32,
                color: Theme.of(context).colorScheme.onBackground
              )
            )
          ),
        ],

        // Background of main appbar space
        // flexibleSpace: Stack(fit: StackFit.expand, children: []),

        // Bottom border gradient
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(_gradientWidth),
            child: Container(
              height: _gradientWidth,
              decoration: const BoxDecoration(
                  gradient: highlightGradient
              ),
            )
        ),

      )
    );
  }

}
