import 'package:flutter/material.dart';

class studentDashboard extends StatefulWidget {
  const studentDashboard({super.key});

  @override
  State<studentDashboard> createState() => _studentDashboardState();
}

class _studentDashboardState extends State<studentDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student Dashboard"),
      ),
    );
  }
}
