import 'package:carehome/features/home/presentation/widgets/care_home_card.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/data/fakedata.dart' as AppFakeData;
import '../../../../core/models/care_home.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LatLng? currentPosition;

  @override
  void initState() {
    super.initState();
    _getLocationOnStart();
  }

  Future<void> _getLocationOnStart() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition();

    /// real or fixed
    currentPosition = LatLng(
      24.130668405966667,
      47.26767978071245,
    );

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

  @override
  Widget build(BuildContext context) {
    if (currentPosition == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: AppFakeData.CareHomeDatasFakeData.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final home = AppFakeData.CareHomeDatasFakeData[index];
          final distance = getDistance(home);

          return FutureBuilder(
            future: getAddress(home.latitude, home.longitude),
            builder: (context, snapshot) {
              return CareHomeCard(
                careHomeData: home,
                distance: distance,
                address: snapshot.data ?? "Loading...",
              );
            },
          );
        },
      ),
    );
  }
}
