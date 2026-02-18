import 'dart:async';
import 'package:carehome/core/models/care_home.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../widgets/offer_card_map.dart';

class MapScreen extends StatefulWidget {
  final List<CareHomeData> carehomeList;

  const MapScreen({super.key, required this.carehomeList});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late PageController _pageController;
  GoogleMapController? mapController;

  LatLng? currentPosition;
  Set<Marker> markers = {};
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    _getLocationOnStart();
  }

  Future<void> _getLocationOnStart() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition();
    print("My location  $position");
    currentPosition = LatLng(position.latitude, position.longitude);
    // currentPosition = LatLng(24.130668405966667, 47.26767978071245);


    /// current location marker
    markers.add(
      Marker(
        markerId: const MarkerId('me'),
        position: currentPosition!,
        infoWindow: const InfoWindow(title: 'You'),
      ),
    );


    print("My location  $currentPosition");

    /// care homes markers
    for (var home in widget.carehomeList) {
      markers.add(
        Marker(
          markerId: MarkerId(home.name),
          position: LatLng(home.latitude, home.longitude),
          infoWindow: InfoWindow(title: home.name),
        ),
      );
    }

    setState(() {});
  }

  double getDistance(CareHomeData home) {
    return Geolocator.distanceBetween(
      currentPosition!.latitude,
      currentPosition!.longitude,
      home.latitude,
      home.longitude,
    ) / 1000;
  }

  Future<String> getAddress(double lat, double lng) async {
    final places = await placemarkFromCoordinates(lat, lng);
    final p = places.first;
    return "${p.locality}, ${p.street}";
  }

  void moveCamera(CareHomeData home) {
    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(home.latitude, home.longitude),
        16,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (currentPosition == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: currentPosition!,
              zoom: 15,
            ),
            markers: markers,
            myLocationEnabled: true,
            onMapCreated: (c) => mapController = c,
          ),

          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 180,
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.carehomeList.length,
                onPageChanged: (index) {
                  _currentIndex = index;
                  moveCamera(widget.carehomeList[index]);
                },
                itemBuilder: (context, index) {
                  final home = widget.carehomeList[index];
                  final distance = getDistance(home);

                  return FutureBuilder(
                    future: getAddress(home.latitude, home.longitude),
                    builder: (context, snapshot) {
                      return OfferCardMap(
                        careHomeData: home,
                        distance: distance,
                        address: snapshot.data ?? "Loading...",
                      );
                    },
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
