import 'package:flutter/material.dart';

import '../../../../core/Helper/time_date_method.dart';
import '../../../../core/models/care_home.dart';

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
    super.key,
    required this.appointment,
  });

  final AppointmentDay appointment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      constraints: const BoxConstraints(minWidth: 90),
      decoration: BoxDecoration(
        color: (appointment.timeSlots.where((slot) => slot.isAvailable ==true).length==0)?    Colors.grey.withOpacity(0.4):Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // 🔑 MIN HEIGHT
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Day
          Text(
            appointment.day,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          // Date
          Text(
            TimeMethod.convertTimeToString(appointment.date),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 6),

          // Slots badge

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${appointment.timeSlots.where((slot) => slot.isAvailable ==true).length} slots',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              ),
            ),

          ),
        ],
      ),
    );
  }
}
