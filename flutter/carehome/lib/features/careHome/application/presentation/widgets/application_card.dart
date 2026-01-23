import 'package:carehome/features/careHome/application/presentation/widgets/application_detailes.dart';
import 'package:flutter/material.dart';

class ApplicationCard extends StatelessWidget {
  final String name;
  final String email;
  final String position;
  final String appliedDate;
  final String status;

  const ApplicationCard({
    super.key,
    required this.name,
    required this.email,
    required this.position,
    required this.appliedDate,
    this.status = 'pending',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Name + Status
          Row(
            spacing: 10,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => ApplicationDetailsDialog(
                      name: name,
                      email: email,
                      experience: '5 years in elderly care',
                      qualifications: 'NVQ Level 3 in Health and Social Care',
                      appliedDate: appliedDate,
                    ),
                  );
                },
                child: Container(
                  child: Text(
                    "View Detailes",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          /// Email
          Text(
            email,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),

          const SizedBox(height: 16),

          /// Job title
          Row(
            children: [
              Icon(Icons.work_outline, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  position,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          /// Applied date
          Text(
            'Applied $appliedDate',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
