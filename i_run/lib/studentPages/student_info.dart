import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class StudentInformationPage extends StatefulWidget {
  final String uid; // Receive uid as parameter

  const StudentInformationPage({
    super.key,
    required this.uid,
  });

  @override
  State<StudentInformationPage> createState() => _StudentInformationPageState();
}

class _StudentInformationPageState extends State<StudentInformationPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController matricController;

  bool isEdited = false;
  bool showSaveButton = false;
  bool _isLoading = true;
  File? _profileImage;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    matricController = TextEditingController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(widget.uid)
          .get();

      if (doc.exists && mounted) {
        setState(() {
          fullNameController.text = doc['fullName'] ?? '';
          emailController.text = doc['email'] ?? '';
          phoneController.text = doc['phoneNumber'] ?? '';
          matricController.text = doc['matricNumber'] ?? '';
          _isLoading = false;
        });
      } else {
        Fluttertoast.showToast(msg: "User record not found");
        _isLoading = false;
        if (mounted) setState(() {});
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error loading user data: $e");
      _isLoading = false;
      if (mounted) setState(() {});
    }
  }

  Future<void> _updateUserData() async {
    try {
      await _firestore.collection('users').doc(widget.uid).update({
        'fullName': fullNameController.text,
        'email': emailController.text,
        'phoneNumber': phoneController.text,
        'matricNumber': matricController.text,
      });

      // Show success message
      Fluttertoast.showToast(msg: "Profile updated successfully!");
      if (mounted) {
        setState(() {
          showSaveButton = false;
          isEdited = false;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error updating profile: $e");
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Navigate to the studentDashboard route
            Navigator.pushReplacementNamed(context, '/studentDashboard');
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView( // Wrap the entire body in SingleChildScrollView
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
                  // Profile Image Picker
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : null,
                        child: _profileImage == null
                            ? const Icon(Icons.camera_alt, size: 30)
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Information Form
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
                  // Save Button
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: const OutlineInputBorder(),
              suffixIcon: const Icon(Icons.edit, size: 20, color: Colors.grey),
            ),
            onChanged: (value) {
              if (!isEdited && mounted) {
                setState(() {
                  isEdited = true;
                  showSaveButton = true;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextFormField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    matricController.dispose();
    super.dispose();
  }
}
