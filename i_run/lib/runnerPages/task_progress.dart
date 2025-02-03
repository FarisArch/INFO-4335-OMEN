import 'package:flutter/material.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskProgress extends StatefulWidget {
  final String taskId;
  const TaskProgress({super.key, required this.taskId});

  @override
  State<TaskProgress> createState() => _TaskProgressState();
}

class _TaskProgressState extends State<TaskProgress> {
  String taskStatus = "Errand in progress";
  Map<String, dynamic>? taskDetails;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    fetchTaskDetails();
  }

  Future<void> fetchTaskDetails() async {
    try {
      DocumentSnapshot taskSnapshot = await _firestore.collection('errands').doc(widget.taskId).get();
      if (taskSnapshot.exists) {
        setState(() {
          taskDetails = taskSnapshot.data() as Map<String, dynamic>;
          taskStatus = taskDetails?["status"] ?? "Errand in progress";
        });
      }
    } catch (e) {
      print("Error fetching task details: $e");
    }
  }

  Future<void> updateTaskStatus(String status) async {
    try {
      setState(() => taskStatus = status);
      await _firestore.collection('errands').doc(widget.taskId).update({'status': status});
    } catch (e) {
      print("Error updating task status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("IIUM ERRAND RUNNER", style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 8, 164, 92),
      ),
      body: taskDetails == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Task Progress', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
                        Text("Task Type: ${taskDetails?["taskType"]}", style: TextStyle(fontSize: 16)),
                        Text("Date: ${taskDetails?["date"]}", style: TextStyle(fontSize: 16)),
                        Text("Time: ${taskDetails?["time"]}", style: TextStyle(fontSize: 16)),
                        Text("Rate: RM ${taskDetails?["price"]}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
                        SizedBox(height: 8),
                        Text("Task Description: ${taskDetails?["deliveryLocation"]?["description"]}", style: TextStyle(fontSize: 16)),
                        SizedBox(height: 12),
                        taskDetails?["image"] != null
                            ? Image.network(taskDetails?["image"], width: 100, height: 100, fit: BoxFit.cover)
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text('Select Status:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Column(
                    children: [
                      buildStatusButton("On my way!"),
                      SizedBox(height: 8),
                      buildStatusButton("Errand in progress"),
                      SizedBox(height: 8),
                      buildStatusButton("Task Completed"),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/runner_dashboard');
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text("Back", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildStatusButton(String status) {
    return ElevatedButton(
      onPressed: () => updateTaskStatus(status),
      style: ElevatedButton.styleFrom(
        backgroundColor: taskStatus == status ? Colors.green : Colors.grey[600],
      ),
      child: Text(status, style: TextStyle(color: Colors.white)),
    );
  }
}
