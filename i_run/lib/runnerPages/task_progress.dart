// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class TaskProgress extends StatefulWidget {
  const TaskProgress({super.key});

  @override
  State<TaskProgress> createState() => _TaskProgressState();
}

class _TaskProgressState extends State<TaskProgress> {
  String taskStatus = "Errand in progress"; // Default selected status

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Task Progress',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Task Code: E101", style: TextStyle(fontSize: 16)),
                  Text("Task Type: Item Delivery", style: TextStyle(fontSize: 16)),
                  Text("Date: 17/01/2024", style: TextStyle(fontSize: 16)),
                  Text("Time: 2:30pm", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text(
                    "Task Description: Deliver item to Mr. Reshat at KICT. Contact 0119299229",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.image, size: 40),
                      ),
                    )),
                  )
                ],
              ),
            ),
            SizedBox(height: 16),
            Text('Select Status:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() => taskStatus = "On my way!");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: taskStatus == "On my way!" ? Colors.green : Colors.grey,
                  ),
                  child: Text("On my way!", style: TextStyle(color: Colors.white)),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() => taskStatus = "Errand in progress");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: taskStatus == "Errand in progress" ? Colors.green : Colors.grey,
                  ),
                  child: Text("Errand in progress", style: TextStyle(color: Colors.white)),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() => taskStatus = "Task Completed");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: taskStatus == "Task Completed" ? Colors.green : Colors.grey,
                  ),
                  child: Text("Task Completed", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/runner_dashboard');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
              ),
              child: Text("Back", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
