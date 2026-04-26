import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../core/constants/colors.dart';
import '../../data/models/offer_model.dart';
import '../manager/care_home_offers_bloc.dart';

// ── Shift draft ───────────────────────────────────────────────────────────────

class _ShiftDraft {
  final String? shiftId;
  DateTime? date;
  String startTime = '';
  String endTime = '';

  _ShiftDraft({this.shiftId, this.date, this.startTime = '', this.endTime = ''});

  factory _ShiftDraft.fromShift(CareHomeShift s) {
    DateTime? d;
    try {
      d = DateTime.parse(s.date);
    } catch (_) {}
    String _trim(String t) => t.length >= 5 ? t.substring(0, 5) : t;
    return _ShiftDraft(
      shiftId: s.shiftId,
      date: d,
      startTime: _trim(s.startTime),
      endTime: _trim(s.endTime),
    );
  }
}

// ── Dialog ────────────────────────────────────────────────────────────────────

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
  final _formKey = GlobalKey<FormState>();

  List<_ShiftDraft> _shifts = [_ShiftDraft()];

  final _addressCtrl = TextEditingController();
  final _address2Ctrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _postalCodeCtrl = TextEditingController();
  final _provinceCtrl = TextEditingController();

  double? _lat, _lng;

  String selectedPosition = 'PSW';

  String _selectedGender = 'Any';
  final List<String> _selectedLanguages = [];
  final List<String> _availableLanguages = [
    'English',
    'Arabic',
    'French',
    'Spanish',
    'Hindi',
    'Other'
  ];
  final List<String> _genderOptions = ['Male', 'Female', 'Any'];

  bool _initialized = false;

  void _init(CareHomeOfferDetail detail) {
    if (_initialized) return;
    _titleCtrl.text = detail.title;
    selectedPosition = detail.position.isEmpty ? 'PSW' : detail.position;
    _descCtrl.text = detail.description;
    _rateCtrl.text = detail.hourlyRate.toStringAsFixed(0);
    _lat = detail.latitude;
    _lng = detail.longitude;
    _addressCtrl.text = detail.address;
    _address2Ctrl.text = detail.address2 ?? '';
    _cityCtrl.text = detail.city;
    _postalCodeCtrl.text = detail.postalCode;
    _provinceCtrl.text = detail.province;
    
    _shifts = detail.shifts.map((s) => _ShiftDraft.fromShift(s)).toList();
    if (_shifts.isEmpty) _shifts.add(_ShiftDraft());

    _selectedLanguages.clear();
    for (var pref in detail.preferences) {
      if (_genderOptions.contains(pref)) {
        _selectedGender = pref;
      } else {
        _selectedLanguages.add(pref);
      }
    }

    _initialized = true;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _rateCtrl.dispose();
    _addressCtrl.dispose();
    _address2Ctrl.dispose();
    _cityCtrl.dispose();
    _postalCodeCtrl.dispose();
    _provinceCtrl.dispose();
    super.dispose();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Future<void> _pickLocation() async {
    final result = await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(builder: (_) => const _LocationPickerScreen()),
    );
    if (result != null) {
      setState(() {
        _lat = result['lat'];
        _lng = result['lng'];
        _addressCtrl.text = result['address'] ?? '';
        _cityCtrl.text = result['city'] ?? '';
        _provinceCtrl.text = result['province'] ?? '';
        _postalCodeCtrl.text = result['postalCode'] ?? '';
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

  /// Shows a unified Time Range Picker dialog.
  Future<void> _pickTimeRange(int i) async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => _TimeRangePickerDialog(
        initialStart: _shifts[i].startTime,
        initialEnd: _shifts[i].endTime,
      ),
    );

    if (result != null) {
      setState(() {
        _shifts[i].startTime = result['start']!;
        _shifts[i].endTime = result['end']!;
      });
    }
  }

  /// Converts "HH:MM" → "HH:MM:00" for the API
  String _toApiTime(String hhmm) =>
      hhmm.length == 5 ? '$hhmm:00' : hhmm;

  Future<void> _submit(CareHomeOfferDetail detail) async {
    // If address is typed manually but coordinates are missing, geocode it FIRST
    if (_lat == null && _addressCtrl.text.trim().isNotEmpty) {
      try {
        final locations = await locationFromAddress(_addressCtrl.text.trim());
        if (locations.isNotEmpty) {
          _lat = locations.first.latitude;
          _lng = locations.first.longitude;
          
          final places = await placemarkFromCoordinates(_lat!, _lng!);
          if (places.isNotEmpty) {
            final p = places.first;
            
            // Update address to full formatted address from geocoder
            final parts = [p.street, p.locality, p.country].where((e) => e != null && e.isNotEmpty).toList();
            if (parts.isNotEmpty) {
              _addressCtrl.text = parts.join(', ');
            }

            if (_cityCtrl.text.isEmpty) _cityCtrl.text = p.locality ?? '';
            if (_provinceCtrl.text.isEmpty) _provinceCtrl.text = p.administrativeArea ?? '';
            if (_postalCodeCtrl.text.isEmpty) _postalCodeCtrl.text = p.postalCode ?? '';
          }
        }
      } catch (_) {
        // Silently fail or handle error below
      }
    }

    if (!_formKey.currentState!.validate()) return;

    if (_lat == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please select or type a valid address'),
          backgroundColor: Colors.orange));
      return;
    }

    final validShifts = _shifts
        .where((s) =>
            s.date != null &&
            s.startTime.length >= 4 &&
            s.endTime.length >= 4)
        .map((s) {
      final dateStr =
          '${s.date!.year}-${s.date!.month.toString().padLeft(2, '0')}-${s.date!.day.toString().padLeft(2, '0')}';
      final start = s.startTime.length == 5 ? '${s.startTime}:00' : s.startTime;
      final end = s.endTime.length == 5 ? '${s.endTime}:00' : s.endTime;
      return ShiftRequest(
        shiftId: s.shiftId,
        date: dateStr,
        startTime: start,
        endTime: end,
      );
    }).toList();

    if (validShifts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please complete at least one shift'),
          backgroundColor: Colors.orange));
      return;
    }

    final preferences = [..._selectedLanguages];
    if (_selectedGender != 'Any') {
      preferences.add(_selectedGender);
    }

    context.read<CareHomeOffersBloc>().add(UpdateOfferEvent(
          offerId: widget.offerId,
          request: UpdateOfferRequest(
            title: _titleCtrl.text.trim(),
            position: selectedPosition,
            description: _descCtrl.text.trim(),
            address: _addressCtrl.text.trim(),
            address2: _address2Ctrl.text.trim().isEmpty ? null : _address2Ctrl.text.trim(),
            city: _cityCtrl.text.trim(),
            postalCode: _postalCodeCtrl.text.trim(),
            province: _provinceCtrl.text.trim(),
            latitude: _lat!,
            longitude: _lng!,
            hourlyRate: double.tryParse(_rateCtrl.text.trim()) ?? detail.hourlyRate,
            preferences: preferences,
            shifts: validShifts,
          ),
        ));
    Navigator.pop(context);
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: TColors.light,
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
                child: Center(child: CircularProgressIndicator()));
          }
          if (state is CareHomeOfferDetailError) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Text(state.message,
                  style: const TextStyle(color: Colors.red)),
            );
          }
          if (state is CareHomeOfferDetailLoaded) {
            _init(state.offer);

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Edit Offer',
                              style: Theme.of(context).textTheme.titleLarge),
                          IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.close)),
                        ],
                      ),

                const SizedBox(height: 16),

                _label('Title *'),
                _textField(_titleCtrl, 'Title',
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null),

                const SizedBox(height: 12),

                _label('Position *'),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: _positionCard(
                          title: 'PSW',
                          icon: Icons.person_search,
                          isSelected: selectedPosition == 'PSW',
                          onTap: () => setState(() => selectedPosition = 'PSW'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _positionCard(
                          title: 'DSW',
                          icon: Icons.health_and_safety,
                          isSelected: selectedPosition == 'DSW',
                          onTap: () => setState(() => selectedPosition = 'DSW'),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                _label('Description'),
                _textField(_descCtrl, 'Describe the role…', maxLines: 3),

                const SizedBox(height: 12),

                _label('Hourly Rate (\$) *'),
                _textField(
                  _rateCtrl,
                  '0.00',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (double.tryParse(v.trim()) == null) return 'Invalid';
                    return null;
                  },
                ),

                _label('Location *'),
                TextFormField(
                  controller: _addressCtrl,
                  decoration: InputDecoration(
                    hintText: 'Type address or pick from map...',
                    hintStyle: Theme.of(context).textTheme.bodySmall,
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none),
                    prefixIcon:
                        Icon(Icons.location_on_outlined, color: TColors.primary),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.map_outlined),
                      onPressed: _pickLocation,
                      color: TColors.primary,
                    ),
                  ),
                  onChanged: (v) {
                    // Reset coordinates if address is changed manually
                    // to trigger re-geocoding on submit
                    _lat = null;
                    _lng = null;
                  },
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),

                const SizedBox(height: 12),
                _label('Address Line 2 (Optional)'),
                _textField(_address2Ctrl, 'Apartment, suite, etc.'),

                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label('City *'),
                          _textField(_cityCtrl, 'City', validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label('Province *'),
                          _textField(_provinceCtrl, 'Province', validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                _label('Postal Code *'),
                _textField(_postalCodeCtrl, 'Postal Code', validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null),

                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),

                _label('Preferences'),
                const SizedBox(height: 8),
                _label('Gender Preference'),
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  items: _genderOptions.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _selectedGender = v);
                  },
                ),
                
                const SizedBox(height: 12),
                _label('Languages (Select multiple)'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableLanguages.map((lang) {
                    final isSelected = _selectedLanguages.contains(lang);
                    return ChoiceChip(
                      label: Text(lang),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedLanguages.add(lang);
                          } else {
                            _selectedLanguages.remove(lang);
                          }
                        });
                      },
                      selectedColor: TColors.primary.withOpacity(0.2),
                      labelStyle: TextStyle(color: isSelected ? TColors.primary : Colors.black87),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),

                _label('Shifts *'),
                const SizedBox(height: 8),

                ..._shifts.asMap().entries.map((e) {
                  final i = e.key;
                  final s = e.value;
                  return _ShiftRow(
                    index: i,
                    draft: s,
                    onPickDate: () => _pickDate(i),
                    onPickTimeRange: () => _pickTimeRange(i),
                    onRemove: _shifts.length > 1
                        ? () => setState(() => _shifts.removeAt(i))
                        : null,
                  );
                }),

                TextButton.icon(
                  onPressed: () => setState(() => _shifts.add(_ShiftDraft())),
                  icon:
                      Icon(Icons.add, color: TColors.primarIconColor, size: 16),
                  label: Text('Add another shift',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: TColors.primarIconColor)),
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel')),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () => _submit(state.offer),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      child: const Text('Save Changes'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
      }
      return const SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator()));
    },
    ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      );

  Widget _textField(
    TextEditingController ctrl,
    String hint, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) =>
      TextFormField(
        controller: ctrl,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: Theme.of(context).textTheme.bodySmall,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red)),
        ),
      );

  Widget _positionCard({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? TColors.darkBlue : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? TColors.darkBlue : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: TColors.darkBlue.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? Colors.white : Colors.grey.shade600,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shift row widget ──────────────────────────────────────────────────────────

class _ShiftRow extends StatelessWidget {
  final int index;
  final _ShiftDraft draft;
  final VoidCallback onPickDate;
  final VoidCallback onPickTimeRange;
  final VoidCallback? onRemove;

  const _ShiftRow({
    required this.index,
    required this.draft,
    required this.onPickDate,
    required this.onPickTimeRange,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Shift ${index + 1}',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              const Spacer(),
              if (onRemove != null)
                GestureDetector(
                  onTap: onRemove,
                  child: Icon(Icons.remove_circle_outline,
                      size: 18, color: Colors.red.shade400),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _chip(
                context,
                text: draft.date == null
                    ? 'Select date'
                    : '${draft.date!.day.toString().padLeft(2, '0')}/${draft.date!.month.toString().padLeft(2, '0')}/${draft.date!.year}',
                icon: Icons.calendar_today,
                filled: draft.date != null,
                onTap: onPickDate,
              ),
              _chip(
                context,
                text: draft.startTime.isEmpty && draft.endTime.isEmpty
                    ? 'Select Time Range'
                    : '${draft.startTime.isEmpty ? 'From' : draft.startTime} - ${draft.endTime.isEmpty ? 'To' : draft.endTime}',
                icon: Icons.access_time,
                filled: draft.startTime.isNotEmpty || draft.endTime.isNotEmpty,
                onTap: onPickTimeRange,
                isFullWidth: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(BuildContext ctx,
      {required String text,
      required IconData icon,
      required bool filled,
      required VoidCallback onTap,
      bool isFullWidth = false}) {
    final w = isFullWidth
        ? MediaQuery.of(ctx).size.width - 64
        : (MediaQuery.of(ctx).size.width - 100) / 3;
    return SizedBox(
      width: w,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: filled ? Colors.blue.shade50 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: filled ? Colors.blue.shade200 : Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Icon(icon,
                  size: 14, color: filled ? Colors.blue.shade600 : Colors.grey),
              const SizedBox(width: 6),
              Expanded(
                child: Text(text,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            filled ? FontWeight.w600 : FontWeight.normal,
                        color: filled
                            ? Colors.blue.shade700
                            : Colors.grey.shade600)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Time Range Picker Dialog ────────────────────────────────────────────────

class _TimeRangePickerDialog extends StatefulWidget {
  final String initialStart;
  final String initialEnd;

  const _TimeRangePickerDialog({
    required this.initialStart,
    required this.initialEnd,
  });

  @override
  State<_TimeRangePickerDialog> createState() => _TimeRangePickerDialogState();
}

class _TimeRangePickerDialogState extends State<_TimeRangePickerDialog> {
  late String _start;
  late String _end;

  @override
  void initState() {
    super.initState();
    _start = widget.initialStart.isEmpty ? '09:00' : widget.initialStart;
    _end = widget.initialEnd.isEmpty ? '17:00' : widget.initialEnd;
  }

  TimeOfDay _parse(String hhmm) {
    final p = hhmm.split(':');
    return TimeOfDay(hour: int.parse(p[0]), minute: int.parse(p[1]));
  }

  String _format(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Shift Time',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: TColors.darkBlue,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap a clock to set the time',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _timeDisplay(
                  label: 'FROM',
                  time: _start,
                  onTap: () => _showPicker(isStart: true),
                ),
                const SizedBox(width: 24),
                _timeDisplay(
                  label: 'TO',
                  time: _end,
                  onTap: () => _showPicker(isStart: false),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.grey)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.pop(context, {'start': _start, 'end': _end}),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.darkBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text('Save',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showPicker({required bool isStart}) async {
    final initial = _parse(isStart ? _start : _end);
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (ctx, child) {
        return MediaQuery(
          data: MediaQuery.of(ctx).copyWith(alwaysUse24HourFormat: true),
          child: Theme(
            data: Theme.of(ctx).copyWith(
              colorScheme: ColorScheme.light(
                primary: TColors.darkBlue,
                onPrimary: Colors.white,
                onSurface: TColors.darkBlue,
              ),
            ),
            child: child!,
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _start = _format(picked);
        } else {
          _end = _format(picked);
        }
      });
    }
  }

  Widget _timeDisplay({
    required String label,
    required String time,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: TColors.darkBlue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: TColors.darkBlue.withOpacity(0.1)),
            ),
            child: Text(
              time,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: TColors.darkBlue,
                fontFamily: 'monospace',
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Location picker ───────────────────────────────────────────────────────────

class _LocationPickerScreen extends StatefulWidget {
  const _LocationPickerScreen();

  @override
  State<_LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<_LocationPickerScreen> {
  LatLng? _selected;
  Marker? _marker;
  bool _loading = false;
  GoogleMapController? _mapController;
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<Map<String, String>> _getLocationDetails(LatLng pos) async {
    try {
      final places =
          await placemarkFromCoordinates(pos.latitude, pos.longitude);
      final p = places.first;
      return {
        'address': '${p.street}, ${p.locality}, ${p.country}',
        'city': p.locality ?? '',
        'province': p.administrativeArea ?? '',
        'postalCode': p.postalCode ?? '',
      };
    } catch (_) {
      return {
        'address': '${pos.latitude.toStringAsFixed(5)}, ${pos.longitude.toStringAsFixed(5)}',
        'city': '',
        'province': '',
        'postalCode': '',
      };
    }
  }

  Future<void> _searchAddress() async {
    final query = _searchCtrl.text.trim();
    if (query.isEmpty) return;

    try {
      final locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        final target = LatLng(loc.latitude, loc.longitude);
        setState(() {
          _selected = target;
          _marker = Marker(markerId: const MarkerId('sel'), position: target);
        });
        _mapController?.animateCamera(CameraUpdate.newLatLngZoom(target, 15));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not find address: $query')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        elevation: 0,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(30.0444, 31.2357), // Cairo
              zoom: 12,
            ),
            onMapCreated: (ctrl) => _mapController = ctrl,
            onTap: (latlng) => setState(() {
              _selected = latlng;
              _marker =
                  Marker(markerId: const MarkerId('sel'), position: latlng);
            }),
            markers: _marker != null ? {_marker!} : {},
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
          ),

          // Search Bar Overlay
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  hintText: 'Search address...',
                  hintStyle: const TextStyle(fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () => _searchCtrl.clear(),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onSubmitted: (_) => _searchAddress(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _selected == null || _loading
            ? null
            : () async {
                setState(() => _loading = true);
                final details = await _getLocationDetails(_selected!);
                if (mounted) {
                  Navigator.pop(context, {
                    'lat': _selected!.latitude,
                    'lng': _selected!.longitude,
                    ...details,
                  });
                }
              },
        label: _loading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2))
            : const Text('Confirm Location'),
        icon: const Icon(Icons.check),
        backgroundColor:  TColors.primary,
      ),
    );
  }
}