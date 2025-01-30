import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// This page displays and allows editing of runner information
class RunnerInformationPage extends StatefulWidget {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String matricNumber;
  final String password;
  final String vehicleRegistrationPlate;
  final String vehicleType;

  const RunnerInformationPage({
    super.key,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.matricNumber,
    required this.password,
    required this.vehicleRegistrationPlate,
    required this.vehicleType,
  });

  @override
  State<RunnerInformationPage> createState() => _RunnerInformationPageState();
}

class _RunnerInformationPageState extends State<RunnerInformationPage> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  // Controllers for form fields
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController matricController;
  late TextEditingController passwordController;
  late TextEditingController vehiclePlateController;
  late TextEditingController vehicleTypeController;

  bool isEdited = false;

  // Dropdown menu item for vehicle types
  String? _selectedVehicleType;

  // List of available vehicle types
  final List<String> vehicleTypes = ['Car', 'Motorcycle', 'Bicycle'];

  @override
  void initState() {
    super.initState();
    // Initializing controllers with widget values
    fullNameController = TextEditingController(text: widget.fullName);
    emailController = TextEditingController(text: widget.email);
    phoneController = TextEditingController(text: widget.phoneNumber);
    matricController = TextEditingController(text: widget.matricNumber);
    passwordController = TextEditingController(text: widget.password);
    vehiclePlateController = TextEditingController(text: widget.vehicleRegistrationPlate);
    _selectedVehicleType = widget.vehicleType;
  }

  // Function to save the data (for now just a print statement)
  void _saveData() {
    // Here you would typically save the data to a database or backend service
    print('Data saved!');
    setState(() {
      isEdited = false; // Reset edit state
    });
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

  // Function to pick an image from the source (camera/gallery)
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      Navigator.pop(context);
    }
  }

  // Function to remove the selected image
  void _removeImage() {
    setState(() {
      _profileImage = null;
    });
    Navigator.pop(context);
  }

  // Method to build text fields with labels aligned to the left
  Widget _buildTextField(String labelText, TextEditingController controller, {bool isPassword = false, bool isReadOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 120, // Set a fixed width for labels
            child: Text(
              labelText,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: isPassword,
              readOnly: isReadOnly,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  isEdited = true;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "IIUM ERRAND RUNNER",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        backgroundColor: const Color.fromARGB(255, 8, 164, 92),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Save button in the app bar with text style
          if (isEdited)
            TextButton(
              onPressed: _saveData,
              child: const Text(
                'SAVE',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Runner Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Profile image section
              Center(
                child: GestureDetector(
                  onTap: _showImagePickerOptions,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                    backgroundImage:
                        _profileImage != null ? FileImage(_profileImage!) : null,
                    child: _profileImage == null
                        ? const Icon(Icons.person, size: 40, color: Colors.white)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Information fields container
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 8, 164, 92),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    _buildTextField('Full Name', fullNameController),
                    _buildTextField('Email', emailController),
                    _buildTextField('Phone', phoneController),
                    _buildTextField('Matric No', matricController, isReadOnly: true),
                    _buildTextField('Password', passwordController, isPassword: true),
                    _buildTextField('Vehicle Plate', vehiclePlateController),
                    // Vehicle Type dropdown
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 120, // Set a fixed width for labels
                            child: Text(
                              'Vehicle Type',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedVehicleType,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedVehicleType = newValue;
                                  isEdited = true;
                                });
                              },
                              items: vehicleTypes
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
