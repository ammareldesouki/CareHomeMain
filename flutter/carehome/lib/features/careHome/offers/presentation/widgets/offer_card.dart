// lib/features/careHome/offers/presentation/widgets/offer_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:carehome/features/careHome/application/presentation/pages/application_screen.dart';

import '../../data/models/offer_model.dart';
import '../manager/care_home_offers_bloc.dart';
import '../pages/offer_detailes.dart';
import 'edite_offer_dilong.dart';

class OfferCard extends StatelessWidget {
  final CareHomeOfferListItem offer;

  const OfferCard({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () async {
        // Fetch full detail then open dialog
        context
            .read<CareHomeOffersBloc>()
            .add(FetchCareHomeOfferDetailEvent(offer.id));
        await showDialog(
          context: context,
          builder: (_) =>
              BlocProvider.value(
                value: context.read<CareHomeOffersBloc>(),
                child: const OfferDetailsDialog(),
              ),
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
            // ── Header: title + rate ───────────────────────────────────
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    '\$${offer.hourlyRate.toStringAsFixed(0)}/H',
                    style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ── Address ────────────────────────────────────────────────
            _InfoRow(
                icon: Icons.location_on_outlined, text: offer.address),

            const SizedBox(height: 14),
            Divider(color: Colors.grey.shade100),
            const SizedBox(height: 10),

            // ── Footer actions ─────────────────────────────────────────
            Row(
              children: [
                _ChipButton(
                  icon: Icons.edit_outlined,
                  label: 'Edit',
                  color: Colors.blue,
                  onTap: () {
                    context
                        .read<CareHomeOffersBloc>()
                        .add(FetchCareHomeOfferDetailEvent(offer.id));
                    showDialog(
                      context: context,
                      builder: (_) =>
                          BlocProvider.value(
                            value: context.read<CareHomeOffersBloc>(),
                            child: EditOfferDialog(offerId: offer.id),
                          ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                _ChipButton(
                  icon: Icons.people_outline_rounded,
                  label: 'Applications',
                  color: Colors.teal,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ApplictionScreen(offerId: offer.id),
                      ),
                    );
                  },
                ),
                const Spacer(),
                _ChipButton(
                  icon: Icons.delete_outline_rounded,
                  label: 'Delete',
                  color: Colors.red,
                  onTap: () => _confirmDelete(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) =>
          AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('Delete Offer'),
            content:
            Text('Are you sure you want to delete "${offer.title}"?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel')),
              ElevatedButton(
                style:
                ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.pop(context);
                  context
                      .read<CareHomeOffersBloc>()
                      .add(DeleteOfferEvent(offer.id));
                },
                child: const Text('Delete',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
      ),
    );
  }
}

// ── helpers ───────────────────────────────────────────────────────────────────

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
                style: TextStyle(
                    fontSize: 14, color: Colors.grey.shade700),
                overflow: TextOverflow.ellipsis)),
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
        padding:
        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
