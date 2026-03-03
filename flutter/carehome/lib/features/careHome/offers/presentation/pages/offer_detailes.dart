// lib/features/careHome/offers/presentation/widgets/offer_details_dialog.dart

import 'package:flutter/material.dart';
import '../../../../psw/application/presentation/widgets/application_card.dart';
import '../../data/models/offer_model.dart';
import '../../../../../../core/data/fakedata.dart';

class OfferDetailsDialog extends StatefulWidget {
  final OfferModel offer;
  final VoidCallback onChanged;

  const OfferDetailsDialog({
    super.key,
    required this.offer,
    required this.onChanged,
  });

  @override
  State<OfferDetailsDialog> createState() => _OfferDetailsDialogState();
}

class _OfferDetailsDialogState extends State<OfferDetailsDialog> {
  bool _editing = false;
  late TextEditingController _titleCtrl;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.offer.title);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offer = widget.offer;
    final isActive = offer.isActive;
    final statusColor = isActive ? Colors.green : Colors.red;

    // Applications that roughly match this offer (by position containing title)
    final offerApps = applications
        .where(
          (a) => a.position.toLowerCase().contains(offer.title.toLowerCase()),
        )
        .toList();

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ────────────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _editing
                      ? TextField(
                          controller: _titleCtrl,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.all(10),
                          ),
                        )
                      : Text(
                          offer.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isActive ? 'Active' : 'Inactive',
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            const SizedBox(height: 6),
            Text(
              'Full offer details & applicants',
              style: TextStyle(color: Colors.grey.shade600),
            ),

            const Divider(height: 28),

            // ── Details Section ───────────────────────────────────────────
            _SectionTitle('Offer Details'),
            const SizedBox(height: 12),

            _DetailRow(Icons.apartment_rounded, 'Branch', offer.branch),
            const SizedBox(height: 10),
            _DetailRow(
              Icons.location_on_outlined,
              'Location',
              '${offer.lat.toStringAsFixed(4)}, ${offer.lng.toStringAsFixed(4)}',
            ),

            const SizedBox(height: 16),

            // ── Shifts ────────────────────────────────────────────────────
            _SectionTitle('Shifts (${offer.shifts.length})'),
            const SizedBox(height: 10),

            ...offer.shifts.asMap().entries.map((e) {
              final i = e.key;
              final s = e.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withOpacity(0.15)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade600,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '${i + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.date,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${s.from} – ${s.to}',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),

            const Divider(height: 28),

            // ── Applications ─────────────────────────────────────────────
            _SectionTitle('Applications (${offerApps.length})'),
            const SizedBox(height: 12),

            if (offerApps.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 48,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No applications yet',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...offerApps.map(
                (app) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ApplicationCard(
                    name: app.name,
                    email: app.email,
                    position: app.position,
                    appliedDate: app.appliedDate,
                    status: app.status,
                  ),
                ),
              ),

            const SizedBox(height: 8),

            // ── Actions ───────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  icon: Icon(
                    _editing ? Icons.save_outlined : Icons.edit_outlined,
                  ),
                  label: Text(_editing ? 'Save' : 'Edit Offer'),
                  onPressed: () {
                    // if (_editing) {
                    //   offer. = _titleCtrl.text;
                    //   widget.onChanged();
                    // }
                    setState(() => _editing = !_editing);
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  icon: Icon(
                    offer.isActive ? Icons.toggle_off : Icons.toggle_on,
                  ),
                  label: Text(offer.isActive ? 'Deactivate' : 'Activate'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: offer.isActive ? Colors.red : Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    offer.isActive = !offer.isActive;
                    widget.onChanged();
                    Navigator.pop(context);
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

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade500),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }
}
