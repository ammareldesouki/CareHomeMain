// lib/features/careHome/application/presentation/widgets/application_card.dart

import 'package:flutter/material.dart';
import 'application_detailes.dart';

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

  Color get _statusColor {
    switch (status) {
      case 'accepted':
        return Colors.green;
      case 'expired':
        return Colors.grey;
      default:
        return Colors.orange;
    }
  }

  IconData get _statusIcon {
    switch (status) {
      case 'accepted':
        return Icons.check_circle_outline;
      case 'expired':
        return Icons.timer_off_outlined;
      default:
        return Icons.hourglass_empty_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _showDetails(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Name + Status ───────────────────────────────────────────
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blue.shade50,
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      Text(email,
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey.shade500)),
                    ],
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_statusIcon, size: 13, color: _statusColor),
                      const SizedBox(width: 4),
                      Text(
                        status[0].toUpperCase() + status.substring(1),
                        style: TextStyle(
                            color: _statusColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),
            Divider(color: Colors.grey.shade100),
            const SizedBox(height: 10),

            // ── Position ─────────────────────────────────────────────────
            Row(
              children: [
                Icon(Icons.work_outline_rounded,
                    size: 16, color: Colors.grey.shade500),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(position,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.calendar_today_outlined,
                    size: 16, color: Colors.grey.shade500),
                const SizedBox(width: 8),
                Text('Applied $appliedDate',
                    style: TextStyle(
                        fontSize: 13, color: Colors.grey.shade500)),
              ],
            ),

            // ── Quick Actions (only for pending) ─────────────────────────
            if (status == 'pending') ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showDetails(context),
                      icon: const Icon(Icons.visibility_outlined, size: 15,
                        color: Colors.black,),
                      label: Text('View Details', style: Theme
                          .of(context)
                          .textTheme!
                          .bodySmall,),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        textStyle: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$name accepted ✓'),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        );
                      },
                      icon: const Icon(Icons.check, size: 15),
                      label: const Text('Accept'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        textStyle: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) =>
          ApplicationDetailsDialog(
            name: name,
            email: email,
            experience: '5 years in elderly care',
            qualifications: 'NVQ Level 3 in Health and Social Care',
            appliedDate: appliedDate,
            status: status,
          ),
    );
  }
}