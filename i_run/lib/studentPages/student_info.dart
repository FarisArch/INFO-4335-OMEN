import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// This page displays and allows editing of student information
class StudentInformationPage extends StatefulWidget {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String matricNumber;
  final String password;

  const StudentInformationPage({
    super.key,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.matricNumber,
    required this.password,
  });

  @override
  State<StudentInformationPage> createState() => _StudentInformationPageState();
}

class _StudentInformationPageState extends State<StudentInformationPage> {
  File? _profileImage; // Stores selected profile image
  final ImagePicker _picker = ImagePicker(); // Handles image selection
  
  // Controllers for form fields
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController matricController;
  late TextEditingController passwordController;
  
  bool isEdited = false; // Tracks if any field is edited
  bool showSaveButton = false; // Initially hide the save button

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController(text: widget.fullName);
    emailController = TextEditingController(text: widget.email);
    phoneController = TextEditingController(text: widget.phoneNumber);
    matricController = TextEditingController(text: widget.matricNumber);
    passwordController = TextEditingController(text: widget.password); 
  }

  // Function to open the image picker options
  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () => _pickImage(ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () => _pickImage(ImageSource.camera),
            ),
            if (_profileImage != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove Photo', style: TextStyle(color: Colors.red)),
                onTap: () => _removeImage(),
              ),
          ],
        ),
      ),
    );
  }

  // Function to pick an image and update the profile picture
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      Navigator.pop(context); // Close the bottom sheet
    }
  }

  // Function to remove the selected profile image
  void _removeImage() {
    setState(() {
      _profileImage = null;
    });
    Navigator.pop(context);
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
      body: Center(
        child: Padding(
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
                    color: Colors.black,
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
                    backgroundImage:
                        _profileImage != null ? FileImage(_profileImage!) : null,
                    child: _profileImage == null
                        ? const Icon(Icons.person, size: 50, color: Colors.white)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 320,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField('Full Name', fullNameController),
                    _buildTextField('Email', emailController),
                    _buildTextField('Phone Number', phoneController),
                    _buildTextField('Matric Number', matricController, isReadOnly: true),
                    _buildTextField('Password', passwordController, isPassword: true),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              if (showSaveButton)
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isEdited = false;
                        showSaveButton = false; // Hide button after saving
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Save'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to create labeled text fields
  Widget _buildTextField(String label, TextEditingController controller, {bool isReadOnly = false, bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              readOnly: isReadOnly,
              obscureText: isPassword,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (!isReadOnly) {
                  setState(() {
                    isEdited = true;
                    showSaveButton = true; // Show save button when edited
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
