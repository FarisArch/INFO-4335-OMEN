import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:i_run/services/database_service_errands.dart';

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

  Future<void> _submitErrand() async {
    if (selectedDate == 'Select Date' || selectedTime == 'Select Time' || taskDescription.isEmpty) {
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
                padding: EdgeInsets.all(14.0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 8, 164, 92),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButton<String>(
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
                        return DropdownMenuItem<String>(value: value, child: Text(value));
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
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          taskDescription = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter task description',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
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
