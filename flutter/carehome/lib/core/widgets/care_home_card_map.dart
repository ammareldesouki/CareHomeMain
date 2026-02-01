

import 'package:carehome/core/constants/colors.dart';
import 'package:carehome/core/models/care_home.dart';
import 'package:flutter/material.dart';


class CareHomeCardMap extends StatelessWidget {
  final CareHomeData careHomeData;

  const CareHomeCardMap({super.key, required this.careHomeData});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.25,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: TColors.primary,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [


                  Text(
                    careHomeData.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(careHomeData.name),


                      Container(
                          height: 50,
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,


                            children: [
                              Icon(Icons.location_city),
                              Text(careHomeData.name.toString()),
                            ],
                          )
                      ),
                    ],
                  ),
                  // SizedBox(
                  //   height: 100,
                  //   child: ListView.separated(
                  //     itemCount: careHomeData.appointments.length,
                  //     scrollDirection: Axis.horizontal,
                  //     separatorBuilder: (_, __) => const SizedBox(width: 8),
                  //     itemBuilder: (context, index) {
                  //       final appointment = careHomeData.appointments[index];
                  //
                  //       return AppointmentCard(appointment: appointment);
                  //     },
                  //   ),
                  // ),

                ]),

          ),
        ));
  }
}

