import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../core/constants/colors.dart';
import '../../data/models/offer_model.dart';
import '../manager/care_home_offers_bloc.dart';


// ── Internal shift model for form ─────────────────────────────────────────────
class _ShiftDraft {
  DateTime? date;
  TimeOfDay? from;
  TimeOfDay? to;
}

class AddOfferDialog extends StatefulWidget {
  const AddOfferDialog({super.key});

  @override
  State<AddOfferDialog> createState() => _AddOfferDialogState();
}

class _AddOfferDialogState extends State<AddOfferDialog> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _rateCtrl = TextEditingController();

  List<_ShiftDraft> _shifts = [_ShiftDraft()];

  // Location
  double? _lat, _lng;
  String _address = '';

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _rateCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickLocation() async {
    final result = await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(builder: (_) => const _LocationPickerScreen()),
    );
    if (result != null) {
      setState(() {
        _lat = result['lat'];
        _lng = result['lng'];
        _address = result['address'];
      });
    }
  }

  Future<void> _pickDate(int i) async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (d != null) setState(() => _shifts[i].date = d);
  }

  Future<void> _pickTime(int i, bool isFrom) async {
    final t = await showTimePicker(
        context: context, initialTime: TimeOfDay.now());
    if (t != null) {
      setState(() =>
      isFrom ? _shifts[i].from = t : _shifts[i].to = t);
    }
  }

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(
          2, '0')}:00';

  void _submit() {
    if (_titleCtrl.text
        .trim()
        .isEmpty) return;
    if (_lat == null) return;

    final shifts = _shifts
        .where((s) => s.date != null && s.from != null && s.to != null)
        .map((s) =>
        ShiftRequest(
          date:
          '${s.date!.year}-${s.date!.month.toString().padLeft(2, '0')}-${s.date!
              .day.toString().padLeft(2, '0')}',
          startTime: _formatTime(s.from!),
          endTime: _formatTime(s.to!),
        ))
        .toList();

    if (shifts.isEmpty) return;

    context.read<CareHomeOffersBloc>().add(
      CreateOfferEvent(
        CreateOfferRequest(
          title: _titleCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          address: _address,
          latitude: _lat!,
          longitude: _lng!,
          hourlyRate:
          double.tryParse(_rateCtrl.text.trim()) ?? 0.0,
          shifts: shifts,
        ),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: TColors.light,
      insetPadding: const EdgeInsets.all(16),
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Add New Job Offer',
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleLarge,),

                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close)),
                ],
              ),

              const SizedBox(height: 16),

              _label('Job Title'),
              _field(_titleCtrl, 'e.g. Evening Care Assistant'),

              const SizedBox(height: 12),

              _label('Description'),
              _field(_descCtrl, 'Describe the role…', maxLines: 3),

              const SizedBox(height: 12),

              _label('Hourly Rate (\$)'),
              _field(_rateCtrl, '0.00',
                  keyboardType: TextInputType.number),

              const SizedBox(height: 12),

              _label('Location'),
              InkWell(
                onTap: _pickLocation,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border:
                    Border.all(color: Colors.grey.shade300),
                    color: Colors.grey.shade50,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          color: TColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _address.isEmpty
                              ? 'Tap to select location'
                              : _address,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: _address.isEmpty
                                  ? Colors.grey
                                  : Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              _label('Shifts'),
              const SizedBox(height: 8),

              ..._shifts
                  .asMap()
                  .entries
                  .map((e) {
                final i = e.key;
                final s = e.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Shift ${i + 1}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _shiftChip(
                          text: s.date == null
                              ? 'Select date'
                              : '${s.date!.day}/${s.date!.month}/${s.date!
                              .year}',
                          icon: Icons.calendar_today,
                          onTap: () => _pickDate(i),
                        ),
                        _shiftChip(
                          text: s.from == null
                              ? 'From'
                              : s.from!.format(context),
                          icon: Icons.access_time,
                          onTap: () => _pickTime(i, true),
                        ),
                        _shiftChip(
                          text: s.to == null
                              ? 'To'
                              : s.to!.format(context),
                          icon: Icons.access_time,
                          onTap: () => _pickTime(i, false),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                );
              }),

              TextButton.icon(
                onPressed: () =>
                    setState(() => _shifts.add(_ShiftDraft())),
                icon: const Icon(Icons.add, color: TColors.primarIconColor,),
                label: Text('Add another shift', style: Theme
                    .of(context)
                    .textTheme!
                    .bodySmall!
                    .copyWith(color: TColors.primarIconColor),),
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel', style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium,)),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _submit,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text('Add Offer', style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.white),),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text,
          style: Theme
              .of(context)
              .textTheme
              .bodyMedium,),
      );

  Widget _field(TextEditingController ctrl, String hint,
      {int maxLines = 1,
        TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintStyle: Theme
            .of(context)
            .textTheme!
            .bodySmall,
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
      ),
    );
  }

  Widget _shiftChip({required String text,
    required IconData icon,
    required VoidCallback onTap}) {
    final w = (MediaQuery
        .of(context)
        .size
        .width - 80) / 2;
    return SizedBox(
      width: w,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(text,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13))),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Inline location picker ────────────────────────────────────────────────────
class _LocationPickerScreen extends StatefulWidget {
  const _LocationPickerScreen();

  @override
  State<_LocationPickerScreen> createState() =>
      _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<_LocationPickerScreen> {
  LatLng? _selected;
  Marker? _marker;

  Future<String> _getAddress(LatLng pos) async {
    final places =
    await placemarkFromCoordinates(pos.latitude, pos.longitude);
    final p = places.first;
    return '${p.street}, ${p.locality}, ${p.country}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Location')),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(30.0444, 31.2357), // Cairo
          zoom: 12,
        ),
        onTap: (latlng) =>
            setState(() {
              _selected = latlng;
              _marker = Marker(
                  markerId: const MarkerId('sel'), position: latlng);
            }),
        markers: _marker != null ? {_marker!} : {},
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _selected == null
            ? null
            : () async {
          final addr = await _getAddress(_selected!);
          Navigator.pop(context, {
            'lat': _selected!.latitude,
            'lng': _selected!.longitude,
            'address': addr,
          });
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}