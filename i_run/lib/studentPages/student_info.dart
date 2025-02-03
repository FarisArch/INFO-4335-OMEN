import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class StudentInformationPage extends StatefulWidget {
  const StudentInformationPage({super.key});

  @override
  State<StudentInformationPage> createState() => _StudentInformationPageState();
}

class _StudentInformationPageState extends State<StudentInformationPage> {
 // Image handling variables
  File? _profileImage;
  String? _profileImageUrl;
  final ImagePicker _picker = ImagePicker();

  // Firebase services instances
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

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

   // Load user data from Firebase
    _loadUserData();
  }

   // Load user data from Firestore
  Future<void> _loadUserData() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = 
          await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        setState(() {
          fullNameController.text = doc['fullName'] ?? '';
          emailController.text = doc['email'] ?? '';
          phoneController.text = doc['phoneNumber'] ?? '';
          matricController.text = doc['matricNumber'] ?? '';
          _profileImageUrl = doc['profileImageUrl'];
          _isLoading = false;
        });
      }
    }
  }
     // Update user data in Firestore 
  Future<void> _updateUserData() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'fullName': fullNameController.text,
        'email': emailController.text,
        'phoneNumber': phoneController.text,
        'matricNumber': matricController.text,
        'profileImageUrl': _profileImageUrl,
      });

      setState(() {
        showSaveButton = false;
        isEdited = false;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile == null) return;

      final User? user = _auth.currentUser;
      if (user == null) return;

      setState(() {
        _profileImage = File(pickedFile.path);
        _isLoading = true;
      });

      // Upload to Firebase Storage
      final storageRef = _storage.ref()
          .child('profile_images')
          .child('${user.uid}.jpg');

      await storageRef.putFile(_profileImage!);
      final downloadUrl = await storageRef.getDownloadURL();

      // Update Firestore
      await _firestore.collection('users').doc(user.uid).update({
        'profileImageUrl': downloadUrl,
      });

      setState(() {
        _profileImageUrl = downloadUrl;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
      setState(() => _isLoading = false);
    }
  }

  Future<void> _removeImage() async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) return;

      setState(() => _isLoading = true);

      // Remove from Storage
      final storageRef = _storage.ref()
          .child('profile_images')
          .child('${user.uid}.jpg');
      await storageRef.delete();

      // Update Firestore
      await _firestore.collection('users').doc(user.uid).update({
        'profileImageUrl': FieldValue.delete(),
      });

      setState(() {
        _profileImage = null;
        _profileImageUrl = null;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error removing image: $e')),
      );
      setState(() => _isLoading = false);
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
                  const SizedBox(height: 15),
                  Center(
                    child: GestureDetector(
                      onTap: _showImagePickerOptions,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: _profileImageUrl != null
                            ? NetworkImage(_profileImageUrl!)
                            : _profileImage != null
                                ? FileImage(_profileImage!)
                                : null,
                        child: _profileImageUrl == null && _profileImage == null
                            ? const Icon(Icons.person, size: 50, color: Colors.white)
                            : null,
                      ),
                    ),
                  ),
                  // ... rest of the build method remains same as previous
                ],
              ),
            ),
    );
  }

  // Keep existing _showImagePickerOptions and other helper methods
}
