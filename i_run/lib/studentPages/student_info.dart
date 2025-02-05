import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentInfo extends StatefulWidget {
  const StudentInfo({super.key});

  @override
  State<StudentInfo> createState() => _StudentInfoState();
}

class _StudentInfoState extends State<StudentInfo> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Map<String, dynamic>? studentData; // Holds student data
  bool _isLoading = true; // Loading state
  String _errorMessage = ""; // Error message

  @override
  void initState() {
    super.initState();
    _fetchStudentData(); // Fetch data when widget initializes
  }

  // 🔹 Fetch student data from Firestore
  Future<void> _fetchStudentData() async {
    try {
      User? user = _auth.currentUser; // Get current user
      if (user == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = "User not logged in.";
        });
        return;
      }

      DocumentSnapshot studentSnapshot =
          await _firestore.collection('students').doc(user.uid).get();

      if (!studentSnapshot.exists) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Student data not found.";
        });
        return;
      }

      setState(() {
        studentData = studentSnapshot.data() as Map<String, dynamic>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Error loading student data: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 8, 164, 92),
        title: const Text(
          "Student Info",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator() // Show loading indicator
            : _errorMessage.isNotEmpty
                ? Text(_errorMessage, style: const TextStyle(color: Colors.red))
                : studentData == null
                    ? const Text("No student data available.")
                    : Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Student Name: ${studentData!['name']}",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text("Matric Number: ${studentData!['matric_number']}"),
                            const SizedBox(height: 10),
                            Text("Email: ${studentData!['email']}"),
                            const SizedBox(height: 10),
                            Text("Phone Number: ${studentData!['phone']}"),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async {
                                await FirebaseAuth.instance.signOut();
                                Navigator.pushReplacementNamed(context, '/login');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: const Text("Logout"),
                            ),
                          ],
                        ),
                      ),
      ),
    );
  }
}
