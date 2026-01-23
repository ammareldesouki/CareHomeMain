import 'package:flutter/material.dart';

class OfferCard extends StatelessWidget {
  const OfferCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ───── Header ─────
          Row(
            children: [
              Expanded(
                child: Text(
                  "Evening Care Assistant",
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  "active",
                  style: Theme.of(context).textTheme!.bodyMedium,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ───── Details ─────
          _InfoRow(icon: Icons.apartment_rounded, text: "Sunrise Care Home"),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.calendar_today_rounded,
            text: "Saturday, 2026-01-25",
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.access_time_filled_rounded,
            text: "18:00 - 22:00",
          ),

          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade200),

          const SizedBox(height: 12),

          // ───── Applications Button ─────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue.shade200),
              borderRadius: BorderRadius.circular(30),
              color: Colors.blue.withOpacity(0.05),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.group_outlined,
                  size: 18,
                  color: Colors.blue.shade600,
                ),
                const SizedBox(width: 6),
                Text(
                  "3 Applications",
                  style: TextStyle(
                    color: Colors.blue.shade600,
                    fontWeight: FontWeight.w600,
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

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 10),
        Text(text, style: TextStyle(fontSize: 15, color: Colors.grey.shade800)),
      ],
    );
  }
}
