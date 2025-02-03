import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class RunnerApplicationPage extends StatefulWidget {
  const RunnerApplicationPage({super.key});

  @override
  State<RunnerApplicationPage> createState() => _RunnerApplicationPageState();
}

class _RunnerApplicationPageState extends State<RunnerApplicationPage> {
  String dropdownVehicleType = 'Car';
  final TextEditingController _vehicleRegController = TextEditingController();
  File? vehicleFrontImage;
  File? vehicleBackImage;
  File? vehicleSideImage;
  File? licenseFile;
  final _formKey = GlobalKey<FormState>();
  final plateRegex = RegExp(r'^[A-Z]{1,3}\s?\d{1,4}[A-Z]?$');

  // Firebase services
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  bool _isLoading = false;

  // Function to pick an image from the gallery
  Future<void> _pickImage(String fileType) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        File selectedFile = File(pickedFile.path);
        switch (fileType) {
          case 'front':
            vehicleFrontImage = selectedFile;
            break;
          case 'back':
            vehicleBackImage = selectedFile;
            break;
          case 'side':
            vehicleSideImage = selectedFile;
            break;
        }
      });
    }
  }

  // Function to pick a PDF file for license upload
  Future<void> _pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        licenseFile = File(result.files.single.path!);
      });
    }
  }

  // Function to validate vehicle registration plate format
  String? _validatePlate(String? value) {
    if (value == null || value.isEmpty) return 'Please enter vehicle registration';
    if (!plateRegex.hasMatch(value)) return 'Invalid Malaysian plate format';
    return null;
  }

  // Function to submit the application
  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final User? user = _auth.currentUser;
      if (user == null) return;

      // Upload images and get their URLs
      final frontImageUrl = await _uploadImage(vehicleFrontImage, 'front');
      final backImageUrl = await _uploadImage(vehicleBackImage, 'back');
      final sideImageUrl = await _uploadImage(vehicleSideImage, 'side');
      final licenseFileUrl = await _uploadFile(licenseFile, 'license');

      // Save application data to Firestore
      await _firestore.collection('runner_applications').doc(user.uid).set({
        'vehicleType': dropdownVehicleType,
        'vehicleRegistrationPlate': _vehicleRegController.text,
        'frontImageUrl': frontImageUrl,
        'backImageUrl': backImageUrl,
        'sideImageUrl': sideImageUrl,
        'licenseFileUrl': licenseFileUrl,
        'status': 'pending', // Application status
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Application submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear form after submission
      setState(() {
        _vehicleRegController.clear();
        vehicleFrontImage = null;
        vehicleBackImage = null;
        vehicleSideImage = null;
        licenseFile = null;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting application: $e'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() => _isLoading = false);
    }
  }

  // Helper function to upload images to Firebase Storage
  Future<String?> _uploadImage(File? image, String type) async {
    if (image == null) return null;

    final User? user = _auth.currentUser;
    if (user == null) return null;

    final storageRef = _storage.ref()
        .child('runner_applications/${user.uid}/$type.jpg');
    await storageRef.putFile(image);
    return await storageRef.getDownloadURL();
  }

  // Helper function to upload files to Firebase Storage
  Future<String?> _uploadFile(File? file, String type) async {
    if (file == null) return null;

    final User? user = _auth.currentUser;
    if (user == null) return null;

    final storageRef = _storage.ref()
        .child('runner_applications/${user.uid}/$type.pdf');
    await storageRef.putFile(file);
    return await storageRef.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("IIUM ERRAND RUNNER"),
        backgroundColor: const Color.fromARGB(255, 8, 164, 92),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Apply as Runner',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              const SizedBox(height: 15),

              // Container for form inputs
              Container(
                width: 350,
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Dropdown for selecting vehicle type
                      DropdownButtonFormField<String>(
                        value: dropdownVehicleType,
                        decoration: const InputDecoration(filled: true, fillColor: Colors.white),
                        items: ['Car', 'Motorcycle'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownVehicleType = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 10),

                      // Input field for vehicle registration number
                      TextFormField(
                        controller: _vehicleRegController,
                        decoration: const InputDecoration(
                          hintText: 'E.g., AMP 8099',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: _validatePlate,
                      ),
                      const SizedBox(height: 15),

                      // Section for uploading vehicle images
                      const Text(
                        'Upload Vehicle Images:',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Center(
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: () => _pickImage('front'),
                              child: const Text("Upload Front"),
                            ),
                            if (vehicleFrontImage != null) Image.file(vehicleFrontImage!, height: 100),
                            ElevatedButton(
                              onPressed: () => _pickImage('side'),
                              child: const Text("Upload Side"),
                            ),
                            if (vehicleSideImage != null) Image.file(vehicleSideImage!, height: 100),
                            ElevatedButton(
                              onPressed: () => _pickImage('back'),
                              child: const Text("Upload Back"),
                            ),
                            if (vehicleBackImage != null) Image.file(vehicleBackImage!, height: 100),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Section for uploading license PDF file
                      const Text(
                        'Upload License (PDF) File:',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Center(
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: _pickPDF,
                              child: const Text("Choose File"),
                            ),
                            if (licenseFile != null)
                              Text(
                                'File: ${licenseFile!.path.split('/').last}',
                                style: const TextStyle(color: Colors.black),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Submit button
                      Center(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submitApplication,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 8, 164, 92),
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  'Submit Application',
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
