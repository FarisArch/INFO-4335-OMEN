// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:i_run/pages.dart';
import 'package:geolocator/geolocator.dart';
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
  await Geolocator.requestPermission();

  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);

 runApp(
    MaterialApp(initialRoute:  '/login', routes: {
      '/': (context) => Splashscreen(),
      '/studentDashboard': (context) => studentDashboard(),
      '/studentAssignErrand': (context) => studentAssignErrand(),
      '/runnerAvailableTasks': (context) => runnerAvailableTasks(),
      '/runnerDashboard': (context) => runnerDashboard(),
      '/studentInfo': (context) => StudentInformationPage(uid: 'hR3v4p0ncbfo34ryPz9PlrXKKdE3'),
      '/runnerInfo': (context) => RunnerInfoPage(
       uid: 'DKvpYsQBdGXr3oQ230fa',
      ),
      '/studentErrandProgress':(context) => ErrandProgress(errandId: 'WRnUlMxl9gfVjO4643Ae'),
      '/runnerApplication': (context) => RunnerApplicationPage(),
      '/signup': (context) => SignUpPage(),
      '/login': (context) => LoginPage(),
      '/taskHistory': (context) => TaskHistory(),
      '/taskProgress': (context) => TaskProgress(),

    }),
  );
}
