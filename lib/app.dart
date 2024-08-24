import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'config.dart';
import 'router.dart';

// MAIN WIDGET
class App extends StatelessWidget {
  final String startLocation;
  const App({Key? key, required this.startLocation}) : super(key: key);

  @override
  Widget build(BuildContext context)  {
    // Lock orientation to vertical
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    // Return the current screen widget using the router
    return MaterialApp.router(
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: buildRouter(startLocation),
    );
  }
}
