import 'dart:async';
import 'package:carehome/core/models/care_home.dart';
import 'package:carehome/features/home/presentation/widgets/care_home_card.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../constants/colors.dart';

class MapScreen extends StatefulWidget {
  final List<CareHomeData> carehomeList;
  const MapScreen({super.key, required this.carehomeList});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  LatLng? currentPosition;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _getLocationOnStart();
  }

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

    setState(() {});

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

  @override
  Widget build(BuildContext context,) {
    return Scaffold(
      body: currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
            GoogleMap(
                    initialCameraPosition: CameraPosition(
            target: currentPosition!,
            zoom: 16,
                    ),
                    markers: markers,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    onMapCreated: (controller) {
            mapController = controller;
            _moveCamera();
                    },
                  ),


    Positioned(
    bottom: 0,
    left: 0,
    right: 0,
    child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
    height: 100,
   child:  ListView.separated(
    shrinkWrap: true,
    itemCount: widget.carehomeList.length,
    scrollDirection: Axis.horizontal,
    itemBuilder: (_, index) {
    return CareHomeCard(
    careHomeData: widget.carehomeList[index],
    );

    },
    separatorBuilder: (_, index) => SizedBox(width: 10),
    ),

    ),
    ),
    ),
          // Positioned(child: InkWell(onTap: (){Navigator.pop(context);},child: CircleAvatar( backgroundColor: TColors.primary,child: Center(child: Icon(Icons.arrow_back_ios,size: 30,)))),top: 50,left: 10,),

        ],
          ),
    );
  }

}
