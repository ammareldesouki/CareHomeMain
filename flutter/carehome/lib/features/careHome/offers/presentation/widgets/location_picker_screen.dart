import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  LatLng? selectedLatLng;
  Marker? marker;

  Future<String> _getAddress(LatLng pos) async {
    final placemarks = await placemarkFromCoordinates(
      pos.latitude,
      pos.longitude,
    );
    final place = placemarks.first;
    return "${place.street}, ${place.locality}, ${place.country}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Location")),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(24.7136, 46.6753), // Riyadh
          zoom: 14,
        ),
        onTap: (latLng) {
          setState(() {
            selectedLatLng = latLng;
            marker = Marker(
              markerId: const MarkerId("selected"),
              position: latLng,
            );
          });
        },
        markers: marker != null ? {marker!} : {},
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: selectedLatLng == null
            ? null
            : () async {
                final address = await _getAddress(selectedLatLng!);

                Navigator.pop(context, {
                  "lat": selectedLatLng!.latitude,
                  "lng": selectedLatLng!.longitude,
                  "address": address,
                });
              },
      ),
    );
  }
}
