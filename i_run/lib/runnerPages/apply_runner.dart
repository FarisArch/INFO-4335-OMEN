import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class RunnerApplicationPage extends StatefulWidget {
  const RunnerApplicationPage({super.key});

  @override
  State<RunnerApplicationPage> createState() => _RunnerApplicationPageState();
}

class _RunnerApplicationPageState extends State<RunnerApplicationPage> {
  // Variables to store user inputs
  String dropdownVehicleType = 'Car';
  String vehicleRegistration = '';
  File? vehicleFrontImage;
  File? vehicleBackImage;
  File? licenseImage;
  File? selfieImage;
  final _formKey = GlobalKey<FormState>();
  final plateRegex = RegExp(r'^[A-Z]{1,3}\s?\d{1,4}[A-Z]?$');

  // Function to handle image selection from gallery or camera
  Future<void> _pickImage(ImageSource source, String imageType) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        switch (imageType) {
          case 'front':
            vehicleFrontImage = File(pickedFile.path);
            break;
          case 'back':
            vehicleBackImage = File(pickedFile.path);
            break;
          case 'license':
            licenseImage = File(pickedFile.path);
            break;
          case 'selfie':
            selfieImage = File(pickedFile.path);
            break;
        }
      });
    }
  }

  // Function to validate vehicle registration format
  String? _validatePlate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter vehicle registration';
    }
    if (!plateRegex.hasMatch(value)) {
      return 'Invalid Malaysian plate format';
    }
    return null;
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
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page title
              const Center(
                child: Text(
                  'Apply as Runner',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Form container with green background
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Vehicle type dropdown
                      Row(
                        children: [
                          const Expanded(
                              child: Text('Vehicle Type',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold))),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: dropdownVehicleType,
                               decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                              ),
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
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Vehicle registration input field
                      Row(
                        children: [
                          const Expanded(
                              child: Text('Vehicle Registration',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold))),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'E.g., AMP 8099',
                                 filled: true,
                                fillColor: Colors.white,
                              ),
                              validator: _validatePlate,
                              onChanged: (value) => vehicleRegistration = value,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      // Upload vehicle images (front and back)
                      Row(
                        children: [
                          const Expanded(
                              child: Text("Upload Vehicle Images",
                                  style: TextStyle(fontWeight: FontWeight.bold))),
                          Column(
                            children: [
                              ElevatedButton(
                                onPressed: () => _pickImage(ImageSource.gallery, 'front'),
                                child: const Text("Upload Front"),
                              ),
                              const SizedBox(height: 10), // Gap between buttons
                              ElevatedButton(
                                onPressed: () => _pickImage(ImageSource.gallery, 'back'),
                                child: const Text("Upload Back"),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      // Upload license
                      Row(
                        children: [
                          const Expanded(
                              child: Text("Upload License",
                                  style: TextStyle(fontWeight: FontWeight.bold))),
                          ElevatedButton(
                            onPressed: () => _pickImage(ImageSource.gallery, 'license'),
                            child: const Text("Choose File"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      // Upload selfie
                      Row(
                        children: [
                          const Expanded(
                              child: Text("Upload Selfie",
                                  style: TextStyle(fontWeight: FontWeight.bold))),
                          ElevatedButton(
                            onPressed: () => _pickImage(ImageSource.camera, 'selfie'),
                            child: const Text("Take a Selfie"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Submit button outside the form
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 8, 164, 92),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 60),
                  ),
                  onPressed: () {},
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}