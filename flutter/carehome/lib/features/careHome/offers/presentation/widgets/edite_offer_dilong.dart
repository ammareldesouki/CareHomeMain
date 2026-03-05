import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/offer_model.dart';
import '../manager/care_home_offers_bloc.dart';

class EditOfferDialog extends StatefulWidget {
  final String offerId;

  const EditOfferDialog({super.key, required this.offerId});

  @override
  State<EditOfferDialog> createState() => _EditOfferDialogState();
}

class _EditOfferDialogState extends State<EditOfferDialog> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _rateCtrl = TextEditingController();
  bool _initialized = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _rateCtrl.dispose();
    super.dispose();
  }

  void _submit(CareHomeOfferDetail detail) {
    // Keep existing shifts (just update title/desc/rate)
    final shifts = detail.shifts
        .map(
          (s) => ShiftRequest(
            date: s.date,
            startTime: s.startTime,
            endTime: s.endTime,
          ),
        )
        .toList();

    context.read<CareHomeOffersBloc>().add(
      UpdateOfferEvent(
        offerId: widget.offerId,
        request: UpdateOfferRequest(
          title: _titleCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          address: detail.address,
          latitude: detail.latitude,
          longitude: detail.longitude,
          hourlyRate:
              double.tryParse(_rateCtrl.text.trim()) ?? detail.hourlyRate,
          shifts: shifts,
        ),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: BlocBuilder<CareHomeOffersBloc, CareHomeOffersState>(
        buildWhen: (_, s) =>
            s is CareHomeOfferDetailLoading ||
            s is CareHomeOfferDetailLoaded ||
            s is CareHomeOfferDetailError,
        builder: (context, state) {
          if (state is CareHomeOfferDetailLoading) {
            return const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is CareHomeOfferDetailError) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is CareHomeOfferDetailLoaded) {
            final detail = state.offer;
            // Pre-fill once
            if (!_initialized) {
              _titleCtrl.text = detail.title;
              _descCtrl.text = detail.description;
              _rateCtrl.text = detail.hourlyRate.toStringAsFixed(0);
              _initialized = true;
            }

            return Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Edit Offer',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _label('Job Title'),
                    _field(_titleCtrl, 'Title'),
                    const SizedBox(height: 12),
                    _label('Description'),
                    _field(_descCtrl, 'Description', maxLines: 3),
                    const SizedBox(height: 12),
                    _label('Hourly Rate (\$)'),
                    _field(
                      _rateCtrl,
                      '0.00',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () => _submit(detail),
                          child: const Text('Save Changes'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }

  Widget _label(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(t, style: const TextStyle(fontWeight: FontWeight.w600)),
  );

  Widget _field(
    TextEditingController c,
    String hint, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: c,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
