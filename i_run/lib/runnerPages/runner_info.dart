import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class RunnerInformationPage extends StatefulWidget {
  const RunnerInformationPage({super.key});

  @override
  State<RunnerInformationPage> createState() => _RunnerInformationPageState();
}

class _RunnerInformationPageState extends State<RunnerInformationPage> {
  // Image handling variables
  File? _localProfileImage;
  String? _profileImageUrl;
  final ImagePicker _picker = ImagePicker();

  // Firebase services
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Controllers
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController matricController;
  late TextEditingController vehiclePlateController;

  // Vehicle type dropdown
  String? _selectedVehicleType;
  final List<String> _vehicleTypes = ['Car', 'Motorcycle', 'Bicycle'];

  // State management
  bool _isEdited = false;
  bool _showSaveButton = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadUserData();
  }

  void _initializeControllers() {
    fullNameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    matricController = TextEditingController();
    vehiclePlateController = TextEditingController();
  }

  Future<void> _loadUserData() async {
    try {
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
            vehiclePlateController.text = doc['vehicleRegistrationPlate'] ?? '';
            _selectedVehicleType = doc['vehicleType'];
            _profileImageUrl = doc['profileImageUrl'];
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      _showErrorSnackbar('Error loading data: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateUserData() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'fullName': fullNameController.text,
          'email': emailController.text,
          'phoneNumber': phoneController.text,
          'matricNumber': matricController.text,
          'vehicleType': _selectedVehicleType,
          'vehicleRegistrationPlate': vehiclePlateController.text,
          'profileImageUrl': _profileImageUrl,
        });
        
        setState(() {
          _showSaveButton = false;
          _isEdited = false;
        });
        _showSuccessSnackbar('Profile updated successfully');
      }
    } catch (e) {
      _showErrorSnackbar('Error updating profile: $e');
    }
  }

  // Image handling methods
  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            if (_profileImageUrl != null || _localProfileImage != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove Photo', 
                    style: TextStyle(color: Colors.red)),
                onTap: _removeProfileImage,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile == null) return;

      final User? user = _auth.currentUser;
      if (user == null) return;

      setState(() {
        _localProfileImage = File(pickedFile.path);
        _isLoading = true;
      });

      final storageRef = _storage.ref()
          .child('profile_images/${user.uid}.jpg');

      await storageRef.putFile(_localProfileImage!);
      final downloadUrl = await storageRef.getDownloadURL();

      await _firestore.collection('users').doc(user.uid).update({
        'profileImageUrl': downloadUrl,
      });

      setState(() {
        _profileImageUrl = downloadUrl;
        _isLoading = false;
      });
    } catch (e) {
      _showErrorSnackbar('Error uploading image: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _removeProfileImage() async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) return;

      setState(() => _isLoading = true);
      
      final storageRef = _storage.ref()
          .child('profile_images/${user.uid}.jpg');
      await storageRef.delete();

      await _firestore.collection('users').doc(user.uid).update({
        'profileImageUrl': FieldValue.delete(),
      });

      setState(() {
        _localProfileImage = null;
        _profileImageUrl = null;
        _isLoading = false;
      });
      Navigator.pop(context);
    } catch (e) {
      _showErrorSnackbar('Error removing image: $e');
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
        actions: [
          if (_showSaveButton)
            TextButton(
              onPressed: _updateUserData,
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Runner Information',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: _showImagePickerOptions,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: _profileImageUrl != null
                            ? NetworkImage(_profileImageUrl!)
                            : _localProfileImage != null
                                ? FileImage(_localProfileImage!)
                                : null,
                        child: _profileImageUrl == null && _localProfileImage == null
                            ? const Icon(Icons.person_add_alt_1, 
                                size: 40, color: Colors.white)
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 8, 164, 92),
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
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
                        _buildEditableField('Phone', phoneController),
                        const SizedBox(height: 15),
                        _buildReadOnlyField('Matric No', matricController),
                        const SizedBox(height: 15),
                        _buildVehiclePlateField(),
                        const SizedBox(height: 15),
                        _buildVehicleTypeDropdown(),
                      ],
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
      onChanged: (value) => _handleFieldChange(),
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

  Widget _buildVehiclePlateField() {
    return TextField(
      controller: vehiclePlateController,
      decoration: InputDecoration(
        labelText: 'Vehicle Plate',
        labelStyle: const TextStyle(color: Colors.black87),
        filled: true,
        fillColor: Colors.white,
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.edit, size: 20, color: Colors.grey),
      ),
      onChanged: (value) => _handleFieldChange(),
    );
  }

  Widget _buildVehicleTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedVehicleType,
      decoration: InputDecoration(
        labelText: 'Vehicle Type',
        labelStyle: const TextStyle(color: Colors.black87),
        filled: true,
        fillColor: Colors.white,
        border: const OutlineInputBorder(),
      ),
      items: _vehicleTypes.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedVehicleType = newValue;
          _handleFieldChange();
        });
      },
    );
  }

  void _handleFieldChange() {
    if (!_isEdited) {
      setState(() {
        _isEdited = true;
        _showSaveButton = true;
      });
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }
}
