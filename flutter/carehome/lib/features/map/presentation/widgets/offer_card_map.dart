import 'package:carehome/core/data/fakedata.dart';
import 'package:carehome/core/models/care_home.dart';
import 'package:flutter/material.dart';

import '../../../psw/offer/presentation/pages/offer_details.dart';

class OfferCardMap extends StatelessWidget {
  final CareHomeData careHomeData;
  final double distance;
  final String address;

  const OfferCardMap({
    super.key,
    required this.careHomeData,
    required this.distance,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) {
            return PswOfferDetailsScreen(
              offer: fakeOffers.first,
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                blurRadius: 8,
                color: Colors.black12,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  careHomeData.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text("📍 $address"),
                const SizedBox(height: 6),
                Text("📏 ${distance.toStringAsFixed(2)} KM away"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
