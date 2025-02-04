import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RunnerInformationPage extends StatefulWidget {
  const RunnerInformationPage({super.key});

  @override
  State<RunnerInformationPage> createState() => _RunnerInformationPageState();
}

class _RunnerInformationPageState extends State<RunnerInformationPage> {
  // Firebase service
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      DocumentSnapshot userDoc = await _firestore.collection('users').doc('USER_ID').get();
      DocumentSnapshot runnerDoc = await _firestore.collection('runners').doc('USER_ID').get();
      
      if (userDoc.exists && runnerDoc.exists) {
        setState(() {
          fullNameController.text = userDoc['fullName'] ?? '';
          emailController.text = userDoc['email'] ?? '';
          phoneController.text = userDoc['phoneNumber'] ?? '';
          matricController.text = userDoc['matricNumber'] ?? '';
          vehiclePlateController.text = runnerDoc['VehicleRegistration'] ?? '';
          _selectedVehicleType = runnerDoc['VehicleType'];
          _isLoading = false;
        });
      }
    } catch (e) {
      _showErrorSnackbar('Error loading data: $e');
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
                        _buildReadOnlyField('Full Name', fullNameController),
                        const SizedBox(height: 15),
                        _buildReadOnlyField('Email', emailController),
                        const SizedBox(height: 15),
                        _buildReadOnlyField('Phone', phoneController),
                        const SizedBox(height: 15),
                        _buildReadOnlyField('Matric No', matricController),
                        const SizedBox(height: 15),
                        _buildReadOnlyField('Vehicle Plate', vehiclePlateController),
                        const SizedBox(height: 15),
                        _buildReadOnlyField('Vehicle Type', TextEditingController(text: _selectedVehicleType ?? '')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
