import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final bool isPickup;

  const MapScreen({required this.isPickup, Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  LatLng? selectedLocation;

  void _onMapTapped(LatLng latLng) {
    setState(() {
      selectedLocation = latLng;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isPickup ? 'Select Pickup Location' : 'Select Delivery Location'),
        backgroundColor: Color.fromARGB(255, 8, 164, 92),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(37.4219983, -122.084), // Default position
          zoom: 14,
        ),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        onTap: _onMapTapped,
        markers: selectedLocation == null
            ? {}
            : {
                Marker(
                  markerId: MarkerId('selectedLocation'),
                  position: selectedLocation!,
                  infoWindow: InfoWindow(title: 'Selected Location'),
                ),
              },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedLocation != null) {
            Navigator.pop(context, selectedLocation);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Please select a location on the map')),
            );
          }
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
