// lib/features/careHome/offers/presentation/widgets/offer_details_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/colors.dart';
import '../../data/models/offer_model.dart';
import '../manager/care_home_offers_bloc.dart';


/// Opens from OfferCard. Listens to BLoC for real offer detail.
class OfferDetailsDialog extends StatefulWidget {
  const OfferDetailsDialog({super.key});

  @override
  State<OfferDetailsDialog> createState() => _OfferDetailsDialogState();
}

class _OfferDetailsDialogState extends State<OfferDetailsDialog> {
  bool _editing = false;
  late TextEditingController _titleCtrl;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: TColors.light,
      insetPadding: const EdgeInsets.all(16),
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: BlocBuilder<CareHomeOffersBloc, CareHomeOffersState>(
        buildWhen: (_, s) =>
        s is CareHomeOfferDetailLoading ||
            s is CareHomeOfferDetailLoaded ||
            s is CareHomeOfferDetailError,
        builder: (context, state) {
          // ── Loading ───────────────────────────────────────────────
          if (state is CareHomeOfferDetailLoading) {
            return const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()));
          }

          // ── Error ─────────────────────────────────────────────────
          if (state is CareHomeOfferDetailError) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Text(state.message,
                  style: const TextStyle(color: Colors.red)),
            );
          }

          // ── Loaded ────────────────────────────────────────────────
          if (state is CareHomeOfferDetailLoaded) {
            final offer = state.offer;

            // Pre-fill edit controller once
            if (_titleCtrl.text.isEmpty) {
              _titleCtrl.text = offer.title;
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ─────────────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: _editing
                            ? TextField(
                          controller: _titleCtrl,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
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
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '\$${offer.hourlyRate.toStringAsFixed(0)}/hr',
                          style: TextStyle(
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),
                  Text('Full offer details',
                      style:
                      TextStyle(color: Colors.grey.shade600)),

                  const Divider(height: 28),

                  // ── Details ───────────────────────────────────────
                  _SectionTitle('Offer Details'),
                  const SizedBox(height: 12),

                  _DetailRow(Icons.apartment_rounded, 'Address',
                      offer.address),
                  const SizedBox(height: 10),
                  _DetailRow(
                    Icons.location_on_outlined,
                    'Coordinates',
                    '${offer.latitude.toStringAsFixed(4)}, ${offer.longitude
                        .toStringAsFixed(4)}',
                  ),

                  if (offer.description.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    _DetailRow(Icons.info_outline, 'Description',
                        offer.description),
                  ],

                  const SizedBox(height: 16),

                  // ── Shifts ─────────────────────────────────────────
                  _SectionTitle('Shifts (${offer.shifts.length})'),
                  const SizedBox(height: 10),

                  ...offer.shifts
                      .asMap()
                      .entries
                      .map((e) {
                    final i = e.key;
                    final s = e.value;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.blue.withOpacity(0.15)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32, height: 32,
                            decoration: BoxDecoration(
                              color: s.isAvailable
                                  ? Colors.blue.shade600
                                  : Colors.grey,
                              borderRadius:
                              BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text('${i + 1}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight:
                                      FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(s.date,
                                    style: const TextStyle(
                                        fontWeight:
                                        FontWeight.w600)),
                                const SizedBox(height: 3),
                                Text(
                                    '${s.startTime} – ${s.endTime}',
                                    style: TextStyle(
                                        color:
                                        Colors.grey.shade600)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: s.isAvailable
                                  ? Colors.green.shade100
                                  : Colors.red.shade100,
                              borderRadius:
                              BorderRadius.circular(8),
                            ),
                            child: Text(
                              s.isAvailable
                                  ? 'Available'
                                  : 'Taken',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: s.isAvailable
                                      ? Colors.green.shade700
                                      : Colors.red.shade700,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 8),

                  // ── Actions ────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(

                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),

                          backgroundColor: TColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(


                              borderRadius:
                              BorderRadius.circular(16)),
                        ),

                        child: Text(_editing ? 'Save' : 'Edit Offer'),
                        onPressed: () {
                          if (_editing && _titleCtrl.text.isNotEmpty) {
                            // Save updated title via UpdateOfferEvent
                            context
                                .read<CareHomeOffersBloc>()
                                .add(UpdateOfferEvent(
                              offerId: offer.id,
                              request: UpdateOfferRequest(
                                title: _titleCtrl.text.trim(),
                                position: offer.position,
                                description: offer.description,
                                address: offer.address,
                                address2: offer.address2,
                                city: offer.city,
                                postalCode: offer.postalCode,
                                province: offer.province,
                                latitude: offer.latitude,
                                longitude: offer.longitude,
                                hourlyRate: offer.hourlyRate,
                                preferences: offer.preferences,
                                shifts: offer.shifts
                                    .map((s) =>
                                        ShiftRequest(
                                          shiftId: s.shiftId,
                                          date: s.date,
                                          startTime: s.startTime,
                                          endTime: s.endTime,
                                        ))
                                    .toList(),
                              ),
                            ));
                            Navigator.pop(context);
                          }
                          setState(() => _editing = !_editing);
                        },

                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(

                        child: const Text('Delete'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),

                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(16)),
                        ),
                        onPressed: () {
                          context
                              .read<CareHomeOffersBloc>()
                              .add(DeleteOfferEvent(offer.id));
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          }

          return const SizedBox(
              height: 200,
              child:
              Center(child: CircularProgressIndicator()));
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w700));
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
            Text(label,
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500)),
            Text(value,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }
}