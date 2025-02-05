import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 8, 164, 92),
        title: const Text(
          "Login",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false, // Removes the back button
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo (Updated)
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.asset(
                    'assets/images/logo app.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.error, size: 40, color: Colors.red), // Error handler
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "IIUM ERRAND RUNNER (IER)",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                // Email Field
                _buildTextField(_emailController, "Email", validator: (value) {
                  return value!.isEmpty || !value.contains("@")
                      ? "Enter a valid email"
                      : null;
                }),
                // Password Field
                _buildTextField(_passwordController, "Password",
                    isPassword: true, validator: (value) {
                  return value!.length < 6
                      ? "Password must be at least 6 characters"
                      : null;
                }),
                const SizedBox(height: 20),
                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 8, 164, 92),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                    ),
                    onPressed: _isLoading ? null : _loginUser,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Login",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
                const SizedBox(height: 10),
                // Signup Navigation
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: const Text(
                    "Don't have an account? Sign up now!",
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Function to handle login
  Future<void> _loginUser() async {
    if (!_formKey.currentState!.validate()) return; // Validate form

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Get the user's UID (session ID)
      String userId = userCredential.user!.uid;

      // Print the session ID in the terminal (console)
      print("User logged in with UID: $userId");

      Fluttertoast.showToast(msg: "Login successful!");

      // ✅ Redirect to Student Dashboard
      Navigator.pushReplacementNamed(context, '/studentDashboard');

    } on FirebaseAuthException catch (e) {
      String errorMsg;
      if (e.code == 'user-not-found') {
        errorMsg = "No user found with this email.";
      } else if (e.code == 'wrong-password') {
        errorMsg = "Incorrect password. Please try again.";
      } else {
        errorMsg = "Login failed: ${e.message}";
      }
      Fluttertoast.showToast(msg: errorMsg);
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  // 🔹 Function to build text fields with validation
  Widget _buildTextField(TextEditingController controller, String labelText,
      {bool isPassword = false, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
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
        ),
      ),
    );
  }
}
