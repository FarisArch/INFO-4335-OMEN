import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Controllers for text fields
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _matricNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false; // State for loading indicator

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 8, 164, 92),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // App Logo Section
                const SizedBox(height: 80, width: 80, child: Placeholder()),
                const SizedBox(height: 10),
                const Text(
                  "IIUM ERRAND RUNNER (IER)",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Form Fields with Validation
                _buildTextField(_fullNameController, "Full Name", validator: (value) {
                  return value!.isEmpty ? "Full Name is required" : null;
                }),
                _buildTextField(_emailController, "Email", validator: (value) {
                  return value!.isEmpty || !value.contains("@") ? "Enter a valid email" : null;
                }),
                _buildTextField(_phoneNumberController, "Phone Number", validator: (value) {
                  return value!.isEmpty || value.length < 10 ? "Enter a valid phone number" : null;
                }),
                _buildTextField(_matricNumberController, "Matric No.", validator: (value) {
                  return value!.isEmpty ? "Matric No. is required" : null;
                }),
                _buildTextField(_passwordController, "Password", isPassword: true, validator: (value) {
                  return value!.length < 6 ? "Password must be at least 6 characters" : null;
                }),
                _buildTextField(_confirmPasswordController, "Confirm Password", isPassword: true, validator: (value) {
                  return value != _passwordController.text ? "Passwords do not match" : null;
                }),

                const SizedBox(height: 20),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 8, 164, 92),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    ),
                    onPressed: _isLoading ? null : _signUpUser, // Disable button while loading
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Submit",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Function to handle user sign-up
  Future<void> _signUpUser() async {
    if (!_formKey.currentState!.validate()) return; // Validate form

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    String fullName = _fullNameController.text.trim();
    String email = _emailController.text.trim();
    String phoneNumber = _phoneNumberController.text.trim();
    String matricNumber = _matricNumberController.text.trim();
    String password = _passwordController.text.trim();

    try {
      // 🔥 Create user in Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get UID
      String uid = userCredential.user!.uid;

      // 🔥 Store additional user info in Firestore
      await _firestore.collection('users').doc(uid).set({
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
        'matricNumber': matricNumber,
        'uid': uid, // Store UID
        'createdAt': FieldValue.serverTimestamp(),
      });

      Fluttertoast.showToast(msg: "User signed up successfully!");
      Navigator.pop(context); // Navigate back

    } on FirebaseAuthException catch (e) {
      String errorMsg;
      if (e.code == 'email-already-in-use') {
        errorMsg = "Email is already registered!";
      } else if (e.code == 'weak-password') {
        errorMsg = "Password is too weak!";
      } else {
        errorMsg = "Error: ${e.message}";
      }
      Fluttertoast.showToast(msg: errorMsg);
    } catch (e) {
      Fluttertoast.showToast(msg: "Unexpected Error: $e");
    }

    setState(() {
      _isLoading = false; // Hide loading indicator
    });
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
