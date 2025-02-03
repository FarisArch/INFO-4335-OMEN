import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers for text fields
  final TextEditingController _matricNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo Section
              const SizedBox(
                height: 100,
                width: 100,
                child: Placeholder(), // Replace with Image.asset for your logo
              ),
              const SizedBox(height: 10),
              const Text(
                "IIUM ERRAND RUNNER (IER)",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              // Matric Number Field
              _buildTextField(_matricNumberController, "Matric No."),
              // Password Field
              _buildTextField(_passwordController, "Password", isPassword: true),
              const SizedBox(height: 20),
              // Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 8, 164, 92),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: _loginUser, // Call login function
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Sign Up Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Not a user yet? "),
                  GestureDetector(
                    onTap: () {
                      // Navigate to Sign-Up Page
                    },
                    child: const Text(
                      "Sign up now !",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Function to handle user login
  void _loginUser() async {
    String matricNumber = _matricNumberController.text.trim();
    String password = _passwordController.text.trim();

    if (matricNumber.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter Matric Number and Password");
      return;
    }

    try {
      // 🔥 Query Firestore to get email linked to Matric Number
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('matricNumber', isEqualTo: matricNumber)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        Fluttertoast.showToast(msg: "Matric Number not found!");
        return;
      }

      // Retrieve email from Firestore
      String email = querySnapshot.docs.first.get('email');

      // 🔥 Authenticate user with email & password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Fluttertoast.showToast(msg: "Login successful!");

      // Navigate to home screen (replace with actual navigation)
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      
    } catch (e) {
      Fluttertoast.showToast(msg: "Login failed: $e");
    }
  }

  // 🔹 Function to build text fields
  Widget _buildTextField(TextEditingController controller, String labelText, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: labelText,
          filled: true,
          fillColor: const Color(0xFFD9D9D9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
      ),
    );
  }
}
