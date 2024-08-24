import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:skillup/router.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:skillup/app.dart';
import 'package:skillup/functions/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    runApp(const App(startLocation: NavigationRoutes.home));
  } else {
    runApp(const App(startLocation: NavigationRoutes.login));
  }


  //runApp(const App());
}
