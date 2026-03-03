// lib/features/careHome/offers/presentation/widgets/offer_card.dart

import 'package:carehome/features/careHome/offers/presentation/pages/offer_detailes.dart';
import 'package:flutter/material.dart';
import '../../data/models/offer_model.dart';
class OfferCard extends StatelessWidget {
  final OfferModel offer;
  final VoidCallback onChanged;

  const OfferCard({super.key, required this.offer, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isActive = offer.isActive;
    final statusColor = isActive ? Colors.green : Colors.red;
    final statusBg = isActive
        ? Colors.green.withOpacity(0.1)
        : Colors.red.withOpacity(0.1);
    final statusLabel = isActive ? 'Active' : 'Inactive';

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () async {
        await showDialog(
          context: context,
          builder: (_) =>
              OfferDetailsDialog(offer: offer, onChanged: onChanged),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: Text(
                    offer.title,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ── Branch ───────────────────────────────────────────────────────
            _InfoRow(icon: Icons.apartment_rounded, text: offer.branch),
            const SizedBox(height: 10),

            // ── First shift ──────────────────────────────────────────────────
            if (offer.shifts.isNotEmpty) ...[
              _InfoRow(
                  icon: Icons.calendar_today_rounded,
                  text: offer.shifts.first.date),
              const SizedBox(height: 10),
              _InfoRow(
                  icon: Icons.access_time_filled_rounded,
                  text:
                  '${offer.shifts.first.from} – ${offer.shifts.first.to}'),
            ],

            if (offer.shifts.length > 1) ...[
              const SizedBox(height: 6),
              Text(
                '+${offer.shifts.length - 1} more shift${offer.shifts.length -
                    1 > 1 ? 's' : ''}',
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.blue.shade600,
                    fontWeight: FontWeight.w500),
              ),
            ],

            const SizedBox(height: 14),
            Divider(color: Colors.grey.shade100),
            const SizedBox(height: 10),

            // ── Footer ───────────────────────────────────────────────────────
            Row(
              children: [
                _ChipButton(
                  icon: Icons.group_outlined,
                  label: '${offer.applicationsCount} Applications',
                  color: Colors.blue,
                ),
                const Spacer(),
                _ChipButton(
                  icon: isActive ? Icons.toggle_on_rounded : Icons
                      .toggle_off_rounded,
                  label: isActive ? 'Deactivate' : 'Activate',
                  color: isActive ? Colors.orange : Colors.green,
                  onTap: () {
                    offer.isActive = !offer.isActive;
                    onChanged();
                  },
                ),
                const SizedBox(width: 8),
                _ChipButton(
                  icon: Icons.delete_outline_rounded,
                  label: 'Delete',
                  color: Colors.red,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) =>
                          AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            title: const Text('Delete Offer'),
                            content: Text(
                                'Are you sure you want to delete "${offer
                                    .title}"?'),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel')),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red),
                                onPressed: () {
                                  Navigator.pop(context);
                                  // trigger removal from parent
                                  onChanged();
                                },
                                child: const Text('Delete',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── helpers ─────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade500),
        const SizedBox(width: 8),
        Expanded(
            child: Text(text,
                style:
                TextStyle(fontSize: 14, color: Colors.grey.shade700))),
      ],
    );
  }
}

class _ChipButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _ChipButton({required this.icon,
    required this.label,
    required this.color,
    this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 5),
            Text(label,
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
