// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class runnerAvailableTasks extends StatefulWidget {
  const runnerAvailableTasks({super.key});

  @override
  State<runnerAvailableTasks> createState() => _runnerAvailableTasksState();
}

class _runnerAvailableTasksState extends State<runnerAvailableTasks> {
  // Example list of errands (replace with dynamic user input in the future)
  final List<Map<String, String>> errands = [
    {
      'time': '2.30pm',
      'date': '17/02/2025',
      'title': 'Item Pickup',
      'description': 'Please bring me followers',
    },
    {
      'time': '4.00pm',
      'date': '18/02/2025',
      'title': 'Food Delivery',
      'description': 'Deliver food to Block B.',
    },
    {
      'time': '6.15pm',
      'date': '19/02/2025',
      'title': 'Document Submission',
      'description': 'Submit documents to the office.',
    },
  ];

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Available Tasks',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: errands.length,
              itemBuilder: (context, index) {
                final errand = errands[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                errand['time']!,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                errand['date']!,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Text(
                            errand['title']!,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                              decorationThickness: 2,
                              decorationColor: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            errand['description']!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () {
                                // Add your action for accepting the task
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 8, 196, 236),
                              ),
                              child: Text(
                                'Accept Task',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
