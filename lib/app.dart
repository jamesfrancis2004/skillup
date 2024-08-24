import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'config.dart';
import 'router.dart';

// MAIN WIDGET
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context)  {

    // Lock orientation to vertical
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    // Return the current screen widget using the router
    return MaterialApp.router(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: buildRouter(),
    );
  }
}
