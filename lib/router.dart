import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import 'package:skillup/overlays/root.dart';
import 'package:skillup/screens/home.dart';
import 'package:skillup/screens/friends.dart';
import 'package:skillup/screens/contribute.dart';
import 'package:skillup/screens/community.dart';
import 'package:skillup/screens/profile.dart';
import 'package:skillup/Widgets/authentication/login.dart';
import 'package:skillup/Widgets/authentication/signup.dart';

import 'Widgets/Authentication/forgot_password.dart';

// ROUTER ...

// Class to keep routing paths in a centralised location
class NavigationRoutes {
  // Raw routes
  static const String home = '/home';
  static const String explore = '/explore';
  static const String contribute = '/contribute';
  static const String community = '/community';
  static const String profile = '/profile';
  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String forgotPassword = '/forgot-password';

  // BOTTOM NAV BAR STUFF ...

  // The length of the bottom nav bar routes - It's stupid but can't get it at compile time
  // Just make sure it matches the length of 'bottomNavBarPaths' above
  static const int bottomNavBarLen = 5;

  // The index of the tab that the bottom bar start on
  static const int startingBottomNavBarIndex = 0;

  // Wrap bottom nav bar routes
  // Routes must be specified in the order they appear on the bottom nav bar [left -> right]
  static const List<String> bottomNavBarPaths = [
    NavigationRoutes.home,
    NavigationRoutes.explore,
    NavigationRoutes.contribute,
    NavigationRoutes.community,
    NavigationRoutes.profile,
  ];

  // Mapping routes to their index in the bottom nav bar
  // Routes must be specified with their associated index in the bottom nav bar
  static const Map<String, int> indexInBottomNavBar = {
    NavigationRoutes.home: 0,
    NavigationRoutes.explore: 1,
    NavigationRoutes.contribute: 2,
    NavigationRoutes.community: 3,
    NavigationRoutes.profile: 4,
  };
}

/* Useful links

  Preserving page state with go_router
  https://medium.com/@wartelski/how-to-flutter-save-the-page-state-using-gorouter-in-sidemenu-c69b9313b7f2

*/

// Main key used for top level navigation
final _rootNavigatorKey = GlobalKey<NavigatorState>();

// The router to use for switching between pages
GoRouter buildRouter(String startLocation) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: startLocation,
    routes: [
      // StatefulShellRoute to preserve page states between navigation
      StatefulShellRoute.indexedStack(
          builder: (BuildContext context, GoRouterState state,
              StatefulNavigationShell navigationShell) {
            return AppScaffold(child: navigationShell);
          },
          branches: [
            StatefulShellBranch(routes: [
              GoRoute(
                  path: NavigationRoutes.home,
                  pageBuilder:
                      _CustomTransitions.getInstantTransitionPageBuilder(
                          child: const HomePage())),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                  path: NavigationRoutes.explore,
                  pageBuilder:
                      _CustomTransitions.getInstantTransitionPageBuilder(
                          child: const FriendsPage())),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                  path: NavigationRoutes.contribute,
                  pageBuilder:
                      _CustomTransitions.getInstantTransitionPageBuilder(
                          child: const ContributePage())),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                  path: NavigationRoutes.community,
                  pageBuilder:
                      _CustomTransitions.getInstantTransitionPageBuilder(
                          child: const ExplorePage())),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                  path: NavigationRoutes.profile,
                  pageBuilder:
                      _CustomTransitions.getInstantTransitionPageBuilder(
                          child: const ProfilePage())),
            ]),
          ]),
      GoRoute(
          path: NavigationRoutes.login,
          builder: (context, state) => const LoginPage()),
      GoRoute(
          path: NavigationRoutes.signUp,
          builder: (context, state) => const SignUpPage()),
      GoRoute(
          path: NavigationRoutes.forgotPassword,
          builder: (context, state) => const ForgotPassword())
    ],
  );
}

// CUSTOM TRANSITIONS ...

/* 

  DESCRIPTION
  This class holds a set of custom transitions that can be applied as page builder methods.

  TRANSITIONS
  -> getInstantTransitionPageBuilder()
     Used to give the effect of skipping all transitions.
     Used in place where a transition object is required but no animation is wanted.

*/
class _CustomTransitions {
  // Instant page transition
  static CustomTransitionPage getInstantTransitionPage(
      {required BuildContext context,
      required GoRouterState state,
      required Widget child}) {
    return CustomTransitionPage(
        key: state.pageKey,
        child: child,
        transitionDuration: const Duration(milliseconds: 0),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            SlideTransition(
                position: animation.drive(Tween<Offset>(
                    begin: const Offset(0, 0), end: const Offset(0, 0))),
                child: child));
  }

  static Page<dynamic> Function(BuildContext context, GoRouterState state)
      getInstantTransitionPageBuilder({required Widget child}) {
    return (context, state) => _CustomTransitions.getInstantTransitionPage(
        context: context, state: state, child: child);
  }
}
