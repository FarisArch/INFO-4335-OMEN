import 'package:flutter/material.dart';

class studentAssignErand extends StatefulWidget {
  const studentAssignErand({super.key});

  @override
  State<studentAssignErand> createState() => _studentAssignErandState();
}

class _studentAssignErandState extends State<studentAssignErand> {
  String dropdownValueTaskType = 'Item Delivery'; // Default selected value for Task Type
  String selectedDate = 'Select Date'; // Default selected value for Date
  String selectedTime = 'Select Time'; // Default selected value for Time
  String taskDescription = ''; // To store the user input for Task Description

  // Method to open the Date Picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        selectedDate = '${pickedDate.toLocal()}'.split(' ')[0]; // Format the selected date
      });
    }
  }

  // Method to open the Time Picker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime.format(context); // Format the selected time
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "IIUM ERRAND RUNNER",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 8, 164, 92),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Assign Errand",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Task Type',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Container(
                            width: 140,
                            decoration: BoxDecoration(
                              color: Color(0xFFD9D9D9),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: DropdownButton<String>(
                              value: dropdownValueTaskType,
                              isExpanded: true,
                              dropdownColor: Colors.white,
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValueTaskType = newValue!;
                                });
                              },
                              items: <String>[
                                'Item Delivery',
                                'Food Delivery',
                                'Pickup'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Center(child: Text(value)),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Date',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          GestureDetector(
                            onTap: () => _selectDate(context), // Open Date Picker
                            child: Container(
                              width: 140,
                              padding: EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: Color(0xFFD9D9D9),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Center(
                                child: Text(
                                  selectedDate,
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Time',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          GestureDetector(
                            onTap: () => _selectTime(context), // Open Time Picker
                            child: Container(
                              width: 140,
                              padding: EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: Color(0xFFD9D9D9),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Center(
                                child: Text(
                                  selectedTime,
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Task Description',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Container(
                            width: 140,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: Color(0xFFD9D9D9),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: TextField(
                              onChanged: (String newValue) {
                                setState(() {
                                  taskDescription = newValue;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter task description',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Upload Image',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Functionality to upload image will be implemented later
                            },
                            child: Text('Choose File'),
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
