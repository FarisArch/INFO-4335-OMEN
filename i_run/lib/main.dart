import 'package:flutter/material.dart';
import 'package:i_run/pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: firebase_api_key,
      appId: firebase_app_id,
      messagingSenderId: "760719249909 ",
      projectId: "omen-irunner",
    ),
  );

  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);

  runApp(
    MaterialApp(initialRoute: '/studentAssignErrand', routes: {
      '/': (context) => Splashscreen(),
      '/studentDashboard': (context) => studentDashboard(),
      '/studentAssignErrand': (context) => studentAssignErrand(),
      '/runnerAvailableTasks': (context) => runnerAvailableTasks(),
      '/runnerDashboard': (context) => runnerDashboard(),
    }),
  );
}
