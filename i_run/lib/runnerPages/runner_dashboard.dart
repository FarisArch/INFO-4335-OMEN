import 'package:flutter/material.dart';
import 'package:i_run/pages.dart';

class runnerDashboard extends StatefulWidget {
  const runnerDashboard({super.key});

  @override
  State<runnerDashboard> createState() => _runnerDashboardState();
}

class _runnerDashboardState extends State<runnerDashboard> {
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
              leading: const Icon(Icons.dashboard),
              title: const Text('Switch to Student Dashboard'),
              onTap: () {
                Navigator.pushNamed(context, '/studentDashboard');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                // Add logout functionality here
                Navigator.pushReplacementNamed(context, '/login');
              },
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
                      _dashboardButton('Available Tasks', () {
                        Navigator.pushNamed(context, '/runnerAvailableTasks');
                      }),
                      _dashboardButton('Task Progress', () {
                        Navigator.pushNamed(context, '/taskProgress');
                      }),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _dashboardButton('Task History', () {
                        Navigator.pushNamed(context, '/taskHistory');
                      }),
                      _dashboardButton('Personal Information', () {
                        Navigator.pushNamed(
                          context,
                          '/runnerInfo',
                          arguments: {
                            'uid': 'DKvpYsQBdGXr3oQ230fa'
                          },
                        );
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
              'Yay! New task found! Check "Available Tasks" to accept.',
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
