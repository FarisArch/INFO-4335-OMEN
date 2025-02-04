import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class RunnerApplicationPage extends StatefulWidget {
  @override
  _RunnerApplicationPageState createState() => _RunnerApplicationPageState();
}

class _RunnerApplicationPageState extends State<RunnerApplicationPage> {
  // Default selected vehicle type is 'Car'
  String dropdownVehicleType = 'Car';

  // TextEditingController to manage the vehicle registration input
  final TextEditingController _vehicleRegController = TextEditingController();

  // Variables to store images for the vehicle (front, back, side) and license file
  File? vehicleFrontImage;
  File? vehicleBackImage;
  File? vehicleSideImage;
  File? licenseFile;

  // Global key for form validation
  final _formKey = GlobalKey<FormState>();

  // Regular expression to validate the vehicle registration plate format (Malaysian plate format)
  final plateRegex = RegExp(r'^[A-Z]{1,3}\s?\d{1,4}[A-Z]?$');

  // Firebase services (Firestore)
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Flag to handle loading state (used to disable the submit button while submitting)
  bool _isLoading = false;

  // Function to pick an image from the gallery
  Future<void> _pickImage(String fileType) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    // Check if the user picked a file, and update the relevant image based on the fileType
    if (pickedFile != null) {
      setState(() {
        File selectedFile = File(pickedFile.path);
        switch (fileType) {
          case 'front':
            vehicleFrontImage = selectedFile; // Front image
            break;
          case 'back':
            vehicleBackImage = selectedFile; // Back image
            break;
          case 'side':
            vehicleSideImage = selectedFile; // Side image
            break;
        }
      });
    }
  }

  // Function to pick a PDF file for the license upload
  Future<void> _pickPDF() async {
    // Allow only PDF files to be selected
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf'
      ],
    );

    // Check if the user picked a file and update the license file
    if (result != null) {
      setState(() {
        licenseFile = File(result.files.single.path!); // Set the license file
      });
    }
  }

  // Function to validate vehicle registration plate format
  String? _validatePlate(String? value) {
    if (value == null || value.isEmpty) return 'Please enter vehicle registration';
    if (!plateRegex.hasMatch(value)) return 'Invalid Malaysian plate format';
    return null; // Valid plate
  }

  // Function to submit the application
  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) return; // If the form is invalid, do not submit

    setState(() => _isLoading = true); // Show loading state while submitting

    try {
      // Save application data to Firestore under 'runners' collection
      await _firestore.collection('runners').doc(_vehicleRegController.text).set({
        'VehicleType': dropdownVehicleType, // Store selected vehicle type
        'VehicleRegistration': _vehicleRegController.text, // Store the vehicle registration
      });

      // Show success message after submission
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Application submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear form and reset state after successful submission
      setState(() {
        _vehicleRegController.clear(); // Clear vehicle registration input
        vehicleFrontImage = null; // Clear vehicle front image
        vehicleBackImage = null; // Clear vehicle back image
        vehicleSideImage = null; // Clear vehicle side image
        licenseFile = null; // Clear license file
        _isLoading = false; // Reset loading state
      });
    } catch (e) {
      // Show error message if something goes wrong during submission
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting application: $e'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() => _isLoading = false); // Reset loading state on error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevent resizing the screen when keyboard is visible
      appBar: AppBar(
        title: const Text("IIUM ERRAND RUNNER"), // App bar title
        backgroundColor: const Color.fromARGB(255, 8, 164, 92), // Green background color for the app bar
      ),
      body: SingleChildScrollView(
        // Scrollable body to handle overflow
        child: Padding(
          padding: const EdgeInsets.all(12.0), // Padding for the content
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Apply as Runner', // Heading for the application page
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              const SizedBox(height: 15),

              // Container for the form inputs
              Container(
                width: 350,
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 8, 164, 92), // Green background for the form container
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3), // Shadow effect for the container
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey, // Form key for validation
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Dropdown to select the vehicle type
                      DropdownButtonFormField<String>(
                        value: dropdownVehicleType, // Default value for dropdown
                        decoration: const InputDecoration(filled: true, fillColor: Colors.white),
                        items: [
                          'Car',
                          'Motorcycle'
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value), // Display the value in the dropdown
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownVehicleType = newValue!; // Update selected vehicle type
                          });
                        },
                      ),
                      const SizedBox(height: 10),

                      // TextFormField to input vehicle registration number
                      TextFormField(
                        controller: _vehicleRegController,
                        decoration: const InputDecoration(
                          hintText: 'E.g., AMP 8099', // Hint for the vehicle registration field
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: _validatePlate, // Call the plate validation function
                      ),
                      const SizedBox(height: 15),

                      // Section for uploading vehicle images
                      const Text(
                        'Upload Vehicle Images:', // Label for vehicle images section
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Center(
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: () => _pickImage('front'), // Pick front image
                              child: const Text("Upload Front"),
                            ),
                            if (vehicleFrontImage != null) Image.file(vehicleFrontImage!, height: 100),
                            ElevatedButton(
                              onPressed: () => _pickImage('side'), // Pick side image
                              child: const Text("Upload Side"),
                            ),
                            if (vehicleSideImage != null) Image.file(vehicleSideImage!, height: 100),
                            ElevatedButton(
                              onPressed: () => _pickImage('back'), // Pick back image
                              child: const Text("Upload Back"),
                            ),
                            if (vehicleBackImage != null) Image.file(vehicleBackImage!, height: 100),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Section for uploading the license file (PDF)
                      const Text(
                        'Upload License (PDF) File:', // Label for the license file section
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Center(
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: _pickPDF, // Pick the license file
                              child: const Text("Choose File"),
                            ),
                            if (licenseFile != null)
                              Text(
                                'File: ${licenseFile!.path.split('/').last}', // Display file name
                                style: const TextStyle(color: Colors.black),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Submit button for the application
                      Center(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submitApplication, // Disable button while loading
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 8, 164, 92),
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white) // Show loading spinner
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
