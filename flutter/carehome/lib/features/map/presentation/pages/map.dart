import 'dart:async';
import 'package:carehome/core/models/care_home.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/constants/colors.dart';
import '../widgets/offer_card_map.dart';

class MapScreen extends StatefulWidget {
  final List<CareHomeData> carehomeList;

  const MapScreen({super.key, required this.carehomeList});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final PageController _pageController;
  int _currentIndex = 0;

  GoogleMapController? mapController;
  LatLng? currentPosition;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                /// 🗺️ MAP
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

                /// 🔙 Back button
                Positioned(
                  top: 50,
                  left: 10,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: CircleAvatar(
                      backgroundColor: TColors.primary,
                      child: const Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                /// 🪪 CARE HOME CURSOR SCROLL (CAROUSEL)
                Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: 200,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: widget.carehomeList.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return AnimatedPadding(
                          duration: const Duration(milliseconds: 300),
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: index == _currentIndex ? 0 : 12,
                          ),
                          child: OfferCardMap(
                            careHomeData: widget.carehomeList[index],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
