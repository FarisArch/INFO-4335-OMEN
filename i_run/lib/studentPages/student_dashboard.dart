import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add this import
import 'package:fluttertoast/fluttertoast.dart'; // Optional, for feedback

class studentDashboard extends StatefulWidget {
  const studentDashboard({super.key});

  @override
  State<studentDashboard> createState() => _studentDashboardState();
}

class _studentDashboardState extends State<studentDashboard> {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance

  // Logout function
  Future<void> _logout() async {
    try {
      await _auth.signOut(); // Sign out the user
      Fluttertoast.showToast(msg: "Logged out successfully!");
      Navigator.pushReplacementNamed(context, '/login'); // Redirect to login
    } catch (e) {
      Fluttertoast.showToast(msg: "Error logging out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "IIUM ERRAND RUNNER",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 8, 164, 92),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 8, 164, 92),
              ),
              child: const Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.directions_run),
              title: const Text('Switch to Runner Dashboard'),
              onTap: () {
                Navigator.pushNamed(context, '/runnerDashboard');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: _logout, // Call the logout function
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('Dashboard', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Container(
              width: 400,
              height: 400,
              color: const Color.fromARGB(255, 8, 164, 92),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _dashboardButton('Assign Errand', () {
                        Navigator.pushNamed(context, '/studentAssignErrand');
                      }),
                      _dashboardButton('Errand Progress', () {
                        Navigator.pushNamed(context, '/studentErrandProgress');
                      }),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _dashboardButton('Apply as Runner', () {
                        Navigator.pushNamed(context, '/runnerApplication'); // Add route for Apply as Runner
                      }),
                      _dashboardButton('Personal Information', () {
                        Navigator.pushNamed(context, '/studentInfo',arguments:{'UID':'hR3v4p0ncbfo34ryPz9PlrXKKdE3'}); // Add route for Personal Information
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Text('Notifications', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          Container(
            width: 300,
            color: const Color.fromARGB(255, 8, 196, 236),
            child: const Text(
              'Yay! We have found you a runner. Check "Errand Progress" to check status',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dashboardButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        fixedSize: const Size(150, 150),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.black),
        textAlign: TextAlign.center,
      ),
    );
  }
}
