import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:i_run/services/mapscreen.dart';

class runnerAvailableTasks extends StatefulWidget {
  const runnerAvailableTasks({super.key});

  @override
  State<runnerAvailableTasks> createState() => _runnerAvailableTasksState();
}

class _runnerAvailableTasksState extends State<runnerAvailableTasks> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _navigateToMapScreen(Map<String, dynamic> pickup, Map<String, dynamic> delivery) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(
          pickupLocation: LatLng(pickup['latitude'], pickup['longitude']),
          deliveryLocation: LatLng(delivery['latitude'], delivery['longitude']),
        ),
      ),
    );
  }

  Future<void> _acceptTask(String taskId) async {
    try {
      await _firestore.collection('errands').doc(taskId).update({
        'status': 'Accepted', // Update the status field
        'assigned': true, // Mark the task as assigned
      });
    } catch (e) {
      // Handle error (optional)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error accepting task')),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('errands')
            .where('status', isEqualTo: 'Available') // Filter tasks with status "Available"
            .where('assigned', isEqualTo: null) // Ensure 'assigned' is null
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No available tasks"));
          }

          final errands = snapshot.data!.docs;
          return ListView.builder(
            itemCount: errands.length,
            itemBuilder: (context, index) {
              var errand = errands[index];
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
                              errand['time'],
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              errand['date'],
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Task ID: ${errand['taskId']}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          errand['taskType'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                            decorationThickness: 2,
                            decorationColor: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          errand['description'],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _navigateToMapScreen(errand['pickupLocation'], errand['deliveryLocation']);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                              ),
                              child: const Text(
                                'View Location',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _acceptTask(errand.id); // Accept the task when button is clicked
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 8, 196, 236),
                              ),
                              child: const Text(
                                'Accept Task',
                                style: TextStyle(color: Colors.white),
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
          );
        },
      ),
    );
  }
}
