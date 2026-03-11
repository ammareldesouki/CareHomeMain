import 'package:flutter/material.dart';

import '../../../../../core/constants/colors.dart';
import '../../domain/entities/carehome_profile_entity.dart';
import 'status_badge_widget.dart';

class CareHomeBusinessSection extends StatelessWidget {
  final CareHomeProfileEntity profile;

  const CareHomeBusinessSection({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: TColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.business, color: TColors.primary, size: 18),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Business Information',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          _buildBusinessItem(
            icon: Icons.badge_outlined,
            title: 'Business License',
            status: profile.businessLicense,
          ),
          _buildBusinessItem(
            icon: Icons.account_balance_outlined,
            title: 'Legal Entity Name',
            status: profile.legalName,
          ),
          _buildBusinessItem(
            icon: Icons.health_and_safety_outlined,
            title: 'Vaccination Policy',
            status: profile.vaccinationPolicy,
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessItem({
    required IconData icon,
    required String title,
    required String status,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade500),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          StatusBadgeWidget(status: status),
        ],
      ),
    );
  }
}
