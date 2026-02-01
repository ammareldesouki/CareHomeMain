import 'package:carehome/core/constants/colors.dart';
import 'package:carehome/core/models/care_home.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../../psw/offer/presentation/pages/offer_details.dart';
import 'appointmentday_card.dart';

class CareHomeCard extends StatelessWidget {
  final CareHomeData careHomeData;
  final double distance;
  final String address;


  const CareHomeCard(
      {super.key, required this.careHomeData, required this.distance, required this.address});

  // double getDistance(CareHomeData home) {
  //   return Geolocator.distanceBetween(
  //     currentPosition!.latitude,
  //     currentPosition!.longitude,
  //     home.latitude,
  //     home.longitude,
  //   ) / 1000;
  // }
  //
  // Future<String> getAddress(double lat, double lng) async {
  //   final places = await placemarkFromCoordinates(lat, lng);
  //   final p = places.first;
  //   return "${p.locality}, ${p.street}";
  // }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => OfferDetails(careHomeData: careHomeData,)));
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),

            /// Blue line on the left (like the image)
            border: const Border(
              left: BorderSide(color: Colors.blue, width: 5),
            ),

            /// Soft shadow
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// Title + Distance
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        careHomeData.name,
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),

                    /// Distance Badge
                    Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 14, color: Colors.blue.withOpacity(0.8)),
                          const SizedBox(width: 4),
                          Text(
                            "${distance.toStringAsFixed(2)} km",
                            style: TextStyle(
                              color: Colors.blue.withOpacity(0.8),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),



                /// Branch
                Row(
                  children: [
                    const Icon(Icons.business, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        address,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),


                const Divider(),

                /// Appointments
                SizedBox(
                  height: 60,
                  child: ListView.separated(
                    itemCount: careHomeData.appointments.length,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final appointment = careHomeData.appointments[index];
                      return AppointmentCard(appointment: appointment);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
