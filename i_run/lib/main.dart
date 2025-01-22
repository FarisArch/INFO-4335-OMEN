import 'package:flutter/material.dart';
import 'package:i_run/pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Faris : Ni simpan later for Firebase intializations
  // await Firebase.initializeApp(
  //   options: FirebaseOptions(
  //     apiKey: firebase_api_key,
  //     appId: firebase_app_id,
  //     messagingSenderId: "138817668884",
  //     projectId: "know-your-business-fyp",
  //   ),
  // );

  // FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);

  runApp(
    MaterialApp(initialRoute: '/runnerAvailableTasks', routes: {
      '/': (context) => Splashscreen(),
      '/studentDashboard': (context) => studentDashboard(),
      '/studentAssignErand': (context) => studentAssignErand(),
      '/runnerAvailableTasks': (context) => runnerAvailableTasks(),
      '/runnerDashboard': (context) => runnerDashboard(),
    }),
  );
}
