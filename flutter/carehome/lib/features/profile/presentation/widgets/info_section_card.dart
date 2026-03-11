import 'package:flutter/material.dart';

import '../../../../../core/constants/colors.dart';

class InfoSectionCard extends StatelessWidget {
  final String title;
  final IconData titleIcon;
  final List<InfoRowItem> rows;
  final Widget? trailing;

  const InfoSectionCard({
    super.key,
    required this.title,
    required this.titleIcon,
    required this.rows,
    this.trailing,
  });

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
                  child: Icon(titleIcon, color: TColors.primary, size: 18),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                if (trailing != null) ...[const Spacer(), trailing!],
              ],
            ),
          ),
          const Divider(height: 1),
          ...rows.map((row) => _buildRow(row)),
        ],
      ),
    );
  }

  Widget _buildRow(InfoRowItem row) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(row.icon, size: 16, color: Colors.grey.shade500),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row.label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  row.value.isNotEmpty ? row.value : '—',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: row.value.isNotEmpty ? Colors.black87 : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InfoRowItem {
  final IconData icon;
  final String label;
  final String value;

  const InfoRowItem({
    required this.icon,
    required this.label,
    required this.value,
  });
}
