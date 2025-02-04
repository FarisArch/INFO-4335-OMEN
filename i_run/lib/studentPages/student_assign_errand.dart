import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart'; // For converting lat/long to place names

class ErrandProgress extends StatefulWidget {
  final String errandId; // Receiving errand ID to fetch its details
  const ErrandProgress({super.key, required this.errandId});

  @override
  State<ErrandProgress> createState() => _ErrandProgressState();
}

class _ErrandProgressState extends State<ErrandProgress> {
  String errandStatus = "Errand in progress"; // Default status
  Map<String, dynamic>? errandDetails; // Stores errand details from Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance

  @override
  void initState() {
    super.initState();
    fetchErrandDetails(); // Fetch errand details when screen loads
  }

  Future<void> fetchErrandDetails() async {
    try {
      // Fetch errand document from Firestore using the given errandId
      DocumentSnapshot errandSnapshot = await _firestore.collection('errands').doc(widget.errandId).get();
      
      if (errandSnapshot.exists) {
        Map<String, dynamic> data = errandSnapshot.data() as Map<String, dynamic>;

        // Convert delivery location lat/long to place name
        String deliveryPlaceName = await _convertLatLongToPlaceName(
          data["deliveryLocation"]["latitude"],
          data["deliveryLocation"]["longitude"],
        );

        // Convert pickup location lat/long to place name
        String pickupPlaceName = await _convertLatLongToPlaceName(
          data["pickupLocation"]["latitude"],
          data["pickupLocation"]["longitude"],
        );

        setState(() {
          errandDetails = data;
          // Store converted place names into the errandDetails map
          errandDetails?["deliveryLocation"]["placeName"] = deliveryPlaceName;
          errandDetails?["pickupLocation"]["placeName"] = pickupPlaceName;
          // Update status from Firestore data
          errandStatus = errandDetails?["status"] ?? "Errand in progress";
        });
      }
    } catch (e) {
      print("Error fetching errand details: $e");
    }
  }

  // Convert latitude and longitude to a readable place name
  Future<String> _convertLatLongToPlaceName(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return "${place.name}, ${place.locality}, ${place.country}"; // Format the place name
      }
    } catch (e) {
      print("Error converting lat/long to place name: $e");
    }
    return "Unknown Location"; // Return default value if conversion fails
  }

  // Update errand status in Firestore
  Future<void> updateErrandStatus(String status) async {
    try {
      setState(() => errandStatus = status); // Update UI immediately
      await _firestore.collection('errands').doc(widget.errandId).update({'status': status});
    } catch (e) {
      print("Error updating errand status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("IIUM ERRAND RUNNER", style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 8, 164, 92),
      ),
      body: errandDetails == null
          ? Center(child: CircularProgressIndicator()) // Show loading indicator while fetching data
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Errand Progress', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  
                  // Display errand details inside a styled container
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Task Type: ${errandDetails?["taskType"]}", style: TextStyle(fontSize: 16)),
                        Text("Date: ${errandDetails?["date"]}", style: TextStyle(fontSize: 16)),
                        Text("Time: ${errandDetails?["time"]}", style: TextStyle(fontSize: 16)),
                        Text("Rate: RM ${errandDetails?["price"]}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
                        SizedBox(height: 8),
                        Text("Pickup Location: ${errandDetails?["pickupLocation"]["placeName"]}", style: TextStyle(fontSize: 16)),
                        Text("Delivery Location: ${errandDetails?["deliveryLocation"]["placeName"]}", style: TextStyle(fontSize: 16)),
                        Text("Description: ${errandDetails?["description"]}", style: TextStyle(fontSize: 16)),
                        SizedBox(height: 12),

                        // Display errand image if available
                        errandDetails?["image"] != null
                            ? Image.network(errandDetails?["image"], width: 100, height: 100, fit: BoxFit.cover)
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),

                  // Status selection section
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

                  // Back button to return to runner dashboard
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

  // Button to update errand status
  Widget buildStatusButton(String status) {
    return ElevatedButton(
      onPressed: () => updateErrandStatus(status), // Update status when pressed
      style: ElevatedButton.styleFrom(
        backgroundColor: errandStatus == status ? Colors.green : Colors.grey[600], // Highlight selected status
      ),
      child: Text(status, style: TextStyle(color: Colors.white)),
    );
  }
}
