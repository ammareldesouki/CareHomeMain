import 'package:carehome/core/constants/colors.dart';
import 'package:carehome/core/models/care_home.dart';
import 'package:flutter/material.dart';

import 'appointmentday_card.dart';

class CareHomeCard extends StatelessWidget {
  final CareHomeData careHomeData;

  const CareHomeCard({super.key, required this.careHomeData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Navigator.pushNamed(context, routeName)
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
            padding: const EdgeInsets.all(16),
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
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),

                    /// Distance Badge
                    Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 14, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            "${careHomeData.distanceFromMe} km",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 10),

                /// Branch
                Row(
                  children: [
                    const Icon(Icons.business, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      careHomeData.branch,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(),

                // /// Appointments
                // SizedBox(
                //   height: 90,
                //   child: ListView.separated(
                //     itemCount: careHomeData.appointments.length,
                //     scrollDirection: Axis.horizontal,
                //     separatorBuilder: (_, __) => const SizedBox(width: 10),
                //     itemBuilder: (context, index) {
                //       final appointment = careHomeData.appointments[index];
                //       return AppointmentCard(appointment: appointment);
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
