import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'signup.dart';


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

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true; // For password visibility toggle

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo Section
                const SizedBox(height: 100, width: 100, child: Placeholder()), // Replace with Image.asset
                const SizedBox(height: 10),
                const Text(
                  "IIUM ERRAND RUNNER (IER)",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),

                // Matric Number Field
                _buildTextField(_matricNumberController, "Matric No.", validator: (value) {
                  return value!.isEmpty ? "Matric No. is required" : null;
                }),

                // Password Field with visibility toggle
                _buildTextField(_passwordController, "Password",
                    isPassword: true,
                    validator: (value) {
                      return value!.isEmpty ? "Password is required" : null;
                    }),

                const SizedBox(height: 20),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 8, 164, 92),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    ),
                    onPressed: _isLoading ? null : _loginUser,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Login", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),

                const SizedBox(height: 20),

               // Sign Up Link
              // Sign Up Link
// Sign Up Link
// Sign Up Link
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    const Text("Not a user yet? "),
    GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignUpPage()),
        );
      },
      child: const Text(
        "Sign up now!",
        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Function to handle user login
  Future<void> _loginUser() async {
    if (!_formKey.currentState!.validate()) return; // Validate form

    setState(() {
      _isLoading = true; // Show loading
    });

    String matricNumber = _matricNumberController.text.trim();
    String password = _passwordController.text.trim();

    try {
      // 🔥 Query Firestore to get email linked to Matric Number
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('matricNumber', isEqualTo: matricNumber)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        Fluttertoast.showToast(msg: "Matric Number not found!");
        setState(() => _isLoading = false);
        return;
      }

      // Retrieve email from Firestore
      String email = querySnapshot.docs.first.get('email');

      // 🔥 Authenticate user with email & password
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      Fluttertoast.showToast(msg: "Login successful!");

      // Navigate to home screen (replace with actual navigation)
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));

    } on FirebaseAuthException catch (e) {
      String errorMsg;
      if (e.code == 'user-not-found') {
        errorMsg = "User not found!";
      } else if (e.code == 'wrong-password') {
        errorMsg = "Incorrect password!";
      } else {
        errorMsg = "Error: ${e.message}";
      }
      Fluttertoast.showToast(msg: errorMsg);
    } catch (e) {
      Fluttertoast.showToast(msg: "Unexpected Error: $e");
    }

    setState(() {
      _isLoading = false; // Hide loading
    });
  }

  // 🔹 Function to build text fields with validation and password visibility toggle
  Widget _buildTextField(TextEditingController controller, String labelText,
      {bool isPassword = false, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? _obscurePassword : false,
        validator: validator,
        decoration: InputDecoration(
          labelText: labelText,
          filled: true,
          fillColor: const Color(0xFFD9D9D9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
