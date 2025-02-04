import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentInformationPage extends StatefulWidget {
  const StudentInformationPage({super.key});

  @override
  State<StudentInformationPage> createState() => _StudentInformationPageState();
}

class _StudentInformationPageState extends State<StudentInformationPage> {
  // Firebase Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controllers for text fields
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController matricController;

  // State management variables
  bool isEdited = false;
  bool showSaveButton = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    fullNameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    matricController = TextEditingController();

    // Load user data from Firestore
    _loadUserData();
  }

  // Load user data from Firestore
  Future<void> _loadUserData() async {
    DocumentSnapshot doc = await _firestore.collection('users').doc('user_id').get();
    if (doc.exists) {
      setState(() {
        fullNameController.text = doc['fullName'] ?? '';
        emailController.text = doc['email'] ?? '';
        phoneController.text = doc['phoneNumber'] ?? '';
        matricController.text = doc['matricNumber'] ?? '';
        _isLoading = false;
      });
    }
  }

  // Update user data in Firestore
  Future<void> _updateUserData() async {
    await _firestore.collection('users').doc('user_id').update({
      'fullName': fullNameController.text,
      'email': emailController.text,
      'phoneNumber': phoneController.text,
      'matricNumber': matricController.text,
    });
    setState(() {
      showSaveButton = false;
      isEdited = false;
    });
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Personal Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 8, 164, 92),
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildEditableField('Full Name', fullNameController),
                        const SizedBox(height: 15),
                        _buildEditableField('Email', emailController),
                        const SizedBox(height: 15),
                        _buildEditableField('Phone Number', phoneController),
                        const SizedBox(height: 15),
                        _buildReadOnlyField('Matric Number', matricController),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  if (showSaveButton)
                    Center(
                      child: ElevatedButton(
                        onPressed: _updateUserData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black87),
        filled: true,
        fillColor: Colors.white,
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.edit, size: 20, color: Colors.grey),
      ),
      onChanged: (value) {
        if (!isEdited) {
          setState(() {
            isEdited = true;
            showSaveButton = true;
          });
        }
      },
    );
  }

  Widget _buildReadOnlyField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black87),
        filled: true,
        fillColor: Colors.grey[200],
        border: const OutlineInputBorder(),
      ),
    );
  }
}
