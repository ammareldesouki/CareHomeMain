


import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSMethode{

  GoogleMapController? mapController;
  LatLng? currentPosition;
  Set<Marker> markers = {};


  // 🔑 1. Request permission + get location
  Future<void> _getLocationOnStart() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    currentPosition = LatLng(position.latitude, position.longitude);

    markers.add(
      Marker(
        markerId: const MarkerId('current_location'),
        position: currentPosition!,
        infoWindow: const InfoWindow(title: 'Your Location'),
      ),
    );

    // setState(() {});

    // Move camera if map already created
    if (mapController != null) {
      _moveCamera();
    }
  }



  // 🎥 Move camera
  void _moveCamera() {
    mapController!.animateCamera(
      CameraUpdate.newLatLngZoom(currentPosition!, 16),
    );
  }






}