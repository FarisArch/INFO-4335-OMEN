import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final LatLng? pickupLocation;
  final LatLng? deliveryLocation;
  final bool isSelecting;
  final bool isPickup;

  const MapScreen({
    this.pickupLocation,
    this.deliveryLocation,
    this.isSelecting = false,
    this.isPickup = true,
    Key? key,
  }) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  LatLng? selectedLocation;

  @override
  void initState() {
    super.initState();
  }

  void _onMapTapped(LatLng latLng) {
    if (widget.isSelecting) {
      setState(() {
        selectedLocation = latLng;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = {};

    if (widget.pickupLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('pickup'),
          position: widget.pickupLocation!,
          infoWindow: const InfoWindow(title: 'Pickup Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
    }

    if (widget.deliveryLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('delivery'),
          position: widget.deliveryLocation!,
          infoWindow: const InfoWindow(title: 'Delivery Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }

    if (widget.isSelecting && selectedLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('selectedLocation'),
          position: selectedLocation!,
          infoWindow: InfoWindow(
            title: widget.isPickup ? 'Selected Pickup Location' : 'Selected Delivery Location',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            widget.isPickup ? BitmapDescriptor.hueBlue : BitmapDescriptor.hueOrange,
          ),
        ),
      );
    }

    CameraPosition initialPosition = CameraPosition(
      target: widget.pickupLocation ?? widget.deliveryLocation ?? const LatLng(37.4219983, -122.084),
      zoom: 12,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSelecting ? (widget.isPickup ? 'Select Pickup Location' : 'Select Delivery Location') : 'Task Route'),
        backgroundColor: const Color.fromARGB(255, 8, 164, 92),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initialPosition,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            onTap: _onMapTapped,
            markers: markers,
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLegendItem(Colors.green, 'Pickup Location'),
                  _buildLegendItem(Colors.red, 'Delivery Location'),
                  _buildLegendItem(Colors.blue, 'Selected Pickup Location'),
                  _buildLegendItem(Colors.orange, 'Selected Delivery Location'),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: widget.isSelecting
          ? FloatingActionButton(
              onPressed: () {
                if (selectedLocation != null) {
                  Navigator.pop(context, selectedLocation);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select a location on the map')),
                  );
                }
              },
              child: const Icon(Icons.check),
            )
          : null,
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}