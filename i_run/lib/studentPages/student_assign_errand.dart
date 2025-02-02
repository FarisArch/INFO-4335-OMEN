import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:i_run/services/mapscreen.dart'; // Import the MapScreen

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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
          print('Pickup Location Set: ${pickupLocation!.latitude}, ${pickupLocation!.longitude}'); // Print the pickup location coordinates
        } else {
          deliveryLocation = location;
          print('Delivery Location Set: ${deliveryLocation!.latitude}, ${deliveryLocation!.longitude}'); // Print the delivery location coordinates
        }
      });
    }
  }

  Future<void> _submitErrand() async {
    if (selectedDate == 'Select Date' || selectedTime == 'Select Time' || taskDescription.isEmpty || pickupLocation == null || deliveryLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      await _firestore.collection('errands').add({
        'taskType': dropdownValueTaskType,
        'date': selectedDate,
        'time': selectedTime,
        'description': taskDescription,
        'pickupLocation': {
          'latitude': pickupLocation!.latitude,
          'longitude': pickupLocation!.longitude,
        },
        'deliveryLocation': {
          'latitude': deliveryLocation!.latitude,
          'longitude': deliveryLocation!.longitude,
        },
        'assigned': null,
        'status': null,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errand successfully assigned')),
      );
      setState(() {
        dropdownValueTaskType = 'Item Delivery';
        selectedDate = 'Select Date';
        selectedTime = 'Select Time';
        taskDescription = '';
        pickupLocation = null;
        deliveryLocation = null;
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
        title: Text("IIUM ERRAND RUNNER", style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 8, 164, 92),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text("Assign Errand", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
              ),
              SizedBox(height: 14),
              Container(
                width: 350,
                height: 500,
                padding: EdgeInsets.all(14.0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 8, 164, 92),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(child: Text(selectedDate)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _selectTime(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(child: Text(selectedTime)),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _navigateToMapScreen(true), // Navigate to map for pickup
                      child: Text(pickupLocation == null ? 'Select Pickup Location' : 'Pickup Location Selected'),
                    ),
                    ElevatedButton(
                      onPressed: () => _navigateToMapScreen(false), // Navigate to map for delivery
                      child: Text(deliveryLocation == null ? 'Select Delivery Location' : 'Delivery Location Selected'),
                    ),
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
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _submitErrand,
                      child: Text('Submit'),
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
