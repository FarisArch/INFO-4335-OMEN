// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class TaskHistory extends StatelessWidget {
  const TaskHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> taskHistory = [
      {
        'date': '17/01/2024',
        'time': '2:30pm',
        'title': 'Item Delivery',
        'description': 'Deliver item to Mr. Reshat at KICT. Contact 0119299229',
        'status': 'Completed',
      },
      {
        'date': '21/01/2024',
        'time': '10:00am',
        'title': 'Buy Items',
        'description': 'Buy groceries from Speedmart',
        'status': 'Canceled',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "IIUM ERRAND RUNNER",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 8, 164, 92),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Task History',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: taskHistory.length,
                itemBuilder: (context, index) {
                  final task = taskHistory[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(task['date']!, style: TextStyle(fontSize: 16, color: Colors.black54)),
                                Text(task['time']!, style: TextStyle(fontSize: 16, color: Colors.black54)),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              task['title']!,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            SizedBox(height: 4),
                            Text(
                              task['description']!,
                              style: TextStyle(fontSize: 16, color: Colors.black87),
                            ),
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromARGB(255, 8, 196, 236),
                                  ),
                                  child: Text("Check Details", style: TextStyle(color: Colors.white)),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: task['status'] == 'Completed' ? Colors.green[100] : Colors.red[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    task['status']!,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: task['status'] == 'Completed' ? Colors.green : Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/runner_dashboard');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                ),
                child: Text("Back", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
