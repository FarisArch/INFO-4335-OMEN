import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RunnerInfoPage extends StatefulWidget {
  final String uid;

  const RunnerInfoPage({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  _RunnerInfoPageState createState() => _RunnerInfoPageState();
}

class _RunnerInfoPageState extends State<RunnerInfoPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController matricController = TextEditingController();
  final TextEditingController vehicleRegController = TextEditingController();
  final TextEditingController vehicleTypeController = TextEditingController();

  bool _isLoading = true;
  bool _runnerDataFound = false;
  bool _isEditing = false;
  bool _showSaveButton = false;

  @override
  void initState() {
    super.initState();
    _loadRunnerData();
  }

    Future<void> _loadRunnerData() async {
    try {
      // 1. Validate UID format
      if (widget.uid.isEmpty || widget.uid.length < 8) {
        throw 'Invalid user ID format';
      }

      // 2. Fetch User Data with timeout
      final userDoc = await _firestore.collection('users')
          .doc(widget.uid)
          .get()
          .timeout(const Duration(seconds: 10));

      if (!userDoc.exists) {
        throw 'User document not found';
      }

      // 3. Validate user document fields
      final userData = userDoc.data()!;
      _validateUserDocument(userData);

      // 4. Fetch Runner Data with field validation
      final runnerQuery = await _firestore.collection('runners')
          .where('userid', isEqualTo: widget.uid)
          .limit(1)
          .get()
          .timeout(const Duration(seconds: 10));

      if (runnerQuery.docs.isNotEmpty) {
        final runnerDoc = runnerQuery.docs.first;
        final runnerData = runnerDoc.data();
        
        _validateRunnerDocument(runnerData);
        
        vehicleRegController.text = runnerData['VehicleRegistration']?.toString() ?? 'N/A';
        vehicleTypeController.text = runnerData['VehicleType']?.toString() ?? 'N/A';
        _runnerDataFound = true;
      }

      if (mounted) {
        setState(() {
          fullNameController.text = userData['name']?.toString() ?? 'N/A';
          emailController.text = userData['email']?.toString() ?? 'N/A';
          phoneController.text = userData['phoneNumber']?.toString() ?? 'N/A';
          matricController.text = userData['matricNo']?.toString() ?? 'N/A';
          _isLoading = false;
        });
      }

    } catch (e) {
      _handleError(e.toString());
    }
  }

  void _validateUserDocument(Map<String, dynamic> data) {
    if (data['name'] == null || data['email'] == null || data['matricNo'] == null) {
      throw 'User document missing required fields';
    }
  }

  void _validateRunnerDocument(Map<String, dynamic> data) {
    if (data['VehicleRegistration'] == null || data['VehicleType'] == null) {
      throw 'Runner document missing required fields';
    }
  }

  void _handleError(String message) {
    Fluttertoast.showToast(msg: message);
    if (mounted) {
      setState(() {
        _isLoading = false;
        vehicleRegController.text = 'Error';
        vehicleTypeController.text = 'Error';
      });
    }
  }


  Future<void> _updateRunnerData() async {
    try {
      // Update user data
      await _firestore.collection('users').doc(widget.uid).update({
        'name': fullNameController.text,
        'email': emailController.text,
        'phoneNumber': phoneController.text,
      });

      // Update runner data
      final runnerQuery = await _firestore.collection('runners')
          .where('userid', isEqualTo: widget.uid)
          .limit(1)
          .get();

      if (runnerQuery.docs.isNotEmpty) {
        await runnerQuery.docs.first.reference.update({
          'VehicleRegistration': vehicleRegController.text,
          'VehicleType': vehicleTypeController.text,
        });
      }

      Fluttertoast.showToast(msg: "Profile updated successfully!");
      setState(() {
        _isEditing = false;
        _showSaveButton = false;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Error updating profile: $e");
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
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Personal Information Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
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
                  
                  // Runner Details Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
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
                        _buildEditableField('Vehicle Registration', vehicleRegController),
                        const SizedBox(height: 15),
                        _buildEditableField('Vehicle Type', vehicleTypeController),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 25),
                  
                  // Save Button
                  if (_showSaveButton)
                    Center(
                      child: ElevatedButton(
                        onPressed: _updateRunnerData,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 14),
          ),
          onChanged: (value) {
            if (!_isEditing) {
              setState(() {
                _isEditing = true;
                _showSaveButton = true;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildReadOnlyField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 14),
          ),
        ),
      ],
    );
  }
}
