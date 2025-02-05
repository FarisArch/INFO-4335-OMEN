import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';

class ErrandProgress extends StatefulWidget {
  final String errandId;
  const ErrandProgress({super.key, required this.errandId});

  @override
  State<ErrandProgress> createState() => _ErrandProgressState();
}

class _ErrandProgressState extends State<ErrandProgress> {
  String errandStatus = "Errand in progress"; // Default errand status
  Map<String, dynamic>? errandDetails;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance

  @override
  void initState() {
    super.initState();
    fetchErrandDetails(); // Fetch errand details when widget initializes
  }

  Future<void> fetchErrandDetails() async {
    try {
      DocumentSnapshot errandSnapshot =
          await _firestore.collection('errands').doc(widget.errandId).get();

      if (errandSnapshot.exists) {
        Map<String, dynamic> data =
            errandSnapshot.data() as Map<String, dynamic>;

        setState(() {
          errandDetails = data;
          errandStatus = errandDetails?["status"] ?? "Errand in progress"; // Update errand status
        });
      }
    } catch (e) {
      print("Error fetching errand details: $e"); // Error handling
    }
  }

  Future<void> updateStatus(String newStatus) async {
    bool confirmAction = await _showConfirmationDialog(newStatus);
    if (!confirmAction) return;

    try {
      await _firestore.collection('errands').doc(widget.errandId).update({"status": newStatus});
      setState(() {
        errandStatus = newStatus; // Update UI with new status
      });
    } catch (e) {
      print("Error updating status: $e"); // Error handling
    }
  }

  Future<bool> _showConfirmationDialog(String action) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm $action"),
        content: Text("Are you sure you want to mark this errand as $action?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // Cancel action
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), // Confirm action
            child: const Text("Confirm"),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("IIUM ERRAND RUNNER", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 8, 164, 92),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacementNamed(context, '/studentDashboard'), // Navigate back
        ),
      ),
      body: errandDetails == null
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator while fetching data
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Errand Progress',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow("Task Type", errandDetails?["taskType"] ?? "N/A", bold: true),
                        _buildInfoRow("Date", errandDetails?["date"] ?? "N/A", bold: true),
                        _buildInfoRow("Time", errandDetails?["time"] ?? "N/A", bold: true),
                        _buildInfoRow("Rate", "RM ${errandDetails?["price"] ?? "N/A"}", bold: false, color: Colors.green),
                        _buildInfoRow("Pickup Location", "Location (${errandDetails?["pickupLocation"]["latitude"]}, ${errandDetails?["pickupLocation"]["longitude"]})", bold: true),
                        _buildInfoRow("Delivery Location", "Location (${errandDetails?["deliveryLocation"]["latitude"]}, ${errandDetails?["deliveryLocation"]["longitude"]})", bold: true),
                        _buildInfoRow("Description", errandDetails?["description"] ?? "N/A", bold: false),
                        _buildInfoRow("Status", errandStatus, bold: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () => updateStatus("Completed"), // Mark errand as completed
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          ),
                          child: const Text("Mark as Completed", style: TextStyle(color: Colors.white)),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => updateStatus("Cancelled"), // Cancel errand
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          ),
                          child: const Text("Cancel Errand", style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoRow(String title, String value, {bool bold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 16, color: color ?? Colors.black),
          children: [
            TextSpan(
              text: "$title: ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}
