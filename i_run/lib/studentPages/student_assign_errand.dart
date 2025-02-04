import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:i_run/services/mapscreen.dart'; // Import the MapScreen
import 'dart:math';

class studentAssignErrand extends StatefulWidget {
  const studentAssignErrand({super.key});

  @override
  State<studentAssignErrand> createState() => _studentAssignErrandState();
}

class _studentAssignErrandState extends State<studentAssignErrand> {
  String dropdownValueTaskType = 'Item Delivery';
  String selectedDate = 'Select Date';
  String selectedTime = 'Select Time';
  String taskDescription = '';
  LatLng? pickupLocation;
  LatLng? deliveryLocation;
  File? selectedImage;
  double price = 50.0; // Default price
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = '${pickedDate.toLocal()}'.split(' ')[0];
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime.format(context);
      });
    }
  }

  Future<void> _navigateToMapScreen(bool isPickup) async {
    final LatLng? location = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(isPickup: isPickup),
      ),
    );
    if (location != null) {
      setState(() {
        if (isPickup) {
          pickupLocation = location;
        } else {
          deliveryLocation = location;
        }
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  Future<void> _takePicture() async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  Future<void> _submitErrand() async {
    if (selectedDate == 'Select Date' || selectedTime == 'Select Time' || taskDescription.isEmpty || pickupLocation == null || deliveryLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // Generate a unique Task ID (e.g., T123456)
    String taskId = 'T${Random().nextInt(900000) + 100000}';

    try {
      await _firestore.collection('errands').add({
        'taskId': taskId,
        'taskType': dropdownValueTaskType,
        'date': selectedDate,
        'time': selectedTime,
        'description': taskDescription,
        'price': price, // Include price
        'pickupLocation': {
          'latitude': pickupLocation!.latitude,
          'longitude': pickupLocation!.longitude,
        },
        'deliveryLocation': {
          'latitude': deliveryLocation!.latitude,
          'longitude': deliveryLocation!.longitude,
        },
        'image': selectedImage != null ? selectedImage!.path : null,
        'assigned': null,
        'status': 'Available',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Errand successfully assigned')),
      );

      setState(() {
        dropdownValueTaskType = 'Item Delivery';
        selectedDate = 'Select Date';
        selectedTime = 'Select Time';
        taskDescription = '';
        pickupLocation = null;
        deliveryLocation = null;
        selectedImage = null;
        price = 50.0; // Reset price
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error assigning errand: $e')),
      );
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
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Assign Errand",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 8, 164, 92),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        value: dropdownValueTaskType,
                        isExpanded: true,
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValueTaskType = newValue!;
                          });
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 8.0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: [
                          'Item Delivery',
                          'Food Delivery',
                          'Pickup'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD9D9D9),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(child: Text(selectedDate)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => _selectTime(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD9D9D9),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(child: Text(selectedTime)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _navigateToMapScreen(true),
                        child: Text(
                          pickupLocation == null ? 'Select Pickup Location' : 'Pickup Location Selected',
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _navigateToMapScreen(false),
                        child: Text(
                          deliveryLocation == null ? 'Select Delivery Location' : 'Delivery Location Selected',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            taskDescription = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter task description',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 12.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Text(
                            'Price:',
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Slider(
                              value: price,
                              min: 0,
                              max: 100,
                              divisions: 100,
                              label: 'RM ${price.toStringAsFixed(0)}',
                              onChanged: (value) {
                                setState(() {
                                  price = value;
                                });
                              },
                            ),
                          ),
                          Text(
                            'RM ${price.toStringAsFixed(0)}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: _pickImageFromGallery,
                            child: const Text('Upload Image'),
                          ),
                          ElevatedButton(
                            onPressed: _takePicture,
                            child: const Text('Take Picture'),
                          ),
                        ],
                      ),
                      if (selectedImage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Image.file(
                            selectedImage!,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _submitErrand,
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
