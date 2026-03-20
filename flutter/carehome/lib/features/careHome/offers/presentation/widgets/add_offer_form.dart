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
  DateTime? date;

  // Store as "HH:MM" string (24-hour)
  String startTime = '';
  String endTime = '';
}

// ── Dialog ────────────────────────────────────────────────────────────────────

class AddOfferDialog extends StatefulWidget {
  const AddOfferDialog({super.key});

  @override
  State<AddOfferDialog> createState() => _AddOfferDialogState();
}

class _AddOfferDialogState extends State<AddOfferDialog> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _rateCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<_ShiftDraft> _shifts = [_ShiftDraft()];

  double? _lat, _lng;
  String _address = '';

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _rateCtrl.dispose();
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

  /// Shows a 24-hour time input dialog using a simple HH:MM TextField.
  Future<void> _pickTime24(int i, bool isStart) async {
    final current = isStart ? _shifts[i].startTime : _shifts[i].endTime;
    final result = await _showTimePicker24(initial: current);
    if (result != null) {
      setState(() {
        if (isStart) {
          _shifts[i].startTime = result;
        } else {
          _shifts[i].endTime = result;
        }
      });
    }
  }

  TimeOfDay? _parseHHmm(String v) {
    final parts = v.split(':');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    if (h < 0 || h > 23 || m < 0 || m > 59) return null;
    return TimeOfDay(hour: h, minute: m);
  }

  String _formatHHmm(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(
          2, '0')}';

  Future<String?> _showTimePicker24({required String initial}) async {
    final parsed = _parseHHmm(initial);
    final initialTime = parsed ?? TimeOfDay.now();

    final platform = Theme
        .of(context)
        .platform;
    final isIOS = platform == TargetPlatform.iOS ||
        platform == TargetPlatform.macOS;

    if (isIOS) {
      final now = DateTime.now();
      final initialDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        initialTime.hour,
        initialTime.minute,
      );

      final picked = await showCupertinoModalPopup<String>(
        context: context,
        builder: (ctx) {
          DateTime current = initialDateTime;
          return SafeArea(
            child: SizedBox(
              height: 260,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            final t = TimeOfDay(
                              hour: current.hour,
                              minute: current.minute,
                            );
                            Navigator.pop(ctx, _formatHHmm(t));
                          },
                          child: const Text('Done'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      use24hFormat: true,
                      initialDateTime: initialDateTime,
                      minuteInterval: 1,
                      onDateTimeChanged: (dt) {
                        current = dt;
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
      return picked;
    }

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (ctx, child) {
        return MediaQuery(
          data: MediaQuery.of(ctx).copyWith(alwaysUse24HourFormat: true),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (picked == null) return null;
    return _formatHHmm(picked);
  }

  /// Converts "HH:MM" → "HH:MM:00" for the API
  String _toApiTime(String hhmm) =>
      hhmm.length == 5 ? '$hhmm:00' : hhmm;

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_lat == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please select a location'),
          backgroundColor: Colors.orange));
      return;
    }

    final validShifts = _shifts
        .where((s) =>
    s.date != null &&
        s.startTime.length == 5 &&
        s.endTime.length == 5)
        .map((s) =>
        ShiftRequest(
          date:
          '${s.date!.year}-${s.date!.month.toString().padLeft(2, '0')}-${s.date!
              .day.toString().padLeft(2, '0')}',
          startTime: _toApiTime(s.startTime),
          endTime: _toApiTime(s.endTime),
        ))
        .toList();

    if (validShifts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please complete at least one shift'),
          backgroundColor: Colors.orange));
      return;
    }

    context.read<CareHomeOffersBloc>().add(CreateOfferEvent(
      CreateOfferRequest(
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        address: _address,
        latitude: _lat!,
        longitude: _lng!,
        hourlyRate: double.tryParse(_rateCtrl.text.trim()) ?? 0.0,
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
      child: Padding(
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
                    Text('Add New Offer',
                        style: Theme
                            .of(context)
                            .textTheme
                            .titleLarge),
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close)),
                  ],
                ),

                const SizedBox(height: 16),

                _label('Job Title *'),
                _textField(_titleCtrl, 'e.g. Evening Care Assistant',
                    validator: (v) =>
                    v == null || v
                        .trim()
                        .isEmpty ? 'Required' : null),

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
                    if (v == null || v
                        .trim()
                        .isEmpty) return 'Required';
                    if (double.tryParse(v.trim()) == null) return 'Invalid';
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                _label('Location *'),
                InkWell(
                  onTap: _pickLocation,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
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
                        const Icon(Icons.chevron_right,
                            color: Colors.grey, size: 18),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                _label('Shifts *'),
                const SizedBox(height: 8),

                ..._shifts
                    .asMap()
                    .entries
                    .map((e) {
                  final i = e.key;
                  final s = e.value;
                  return _ShiftRow(
                    index: i,
                    draft: s,
                    onPickDate: () => _pickDate(i),
                    onPickStart: () => _pickTime24(i, true),
                    onPickEnd: () => _pickTime24(i, false),
                    onRemove: _shifts.length > 1
                        ? () => setState(() => _shifts.removeAt(i))
                        : null,
                  );
                }),

                TextButton.icon(
                  onPressed: () =>
                      setState(() => _shifts.add(_ShiftDraft())),
                  icon: Icon(Icons.add,
                      color: TColors.primarIconColor, size: 16),
                  label: Text('Add another shift',
                      style: Theme
                          .of(context)
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
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      child: const Text('Add Offer'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text,
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 13)),
      );

  Widget _textField(TextEditingController ctrl,
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
          hintStyle: Theme
              .of(context)
              .textTheme
              .bodySmall,
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
}

// ── Shift row widget ──────────────────────────────────────────────────────────

class _ShiftRow extends StatelessWidget {
  final int index;
  final _ShiftDraft draft;
  final VoidCallback onPickDate;
  final VoidCallback onPickStart;
  final VoidCallback onPickEnd;
  final VoidCallback? onRemove;

  const _ShiftRow({
    required this.index,
    required this.draft,
    required this.onPickDate,
    required this.onPickStart,
    required this.onPickEnd,
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
                    : '${draft.date!.day.toString().padLeft(2, '0')}/${draft
                    .date!.month.toString().padLeft(2, '0')}/${draft.date!
                    .year}',
                icon: Icons.calendar_today,
                filled: draft.date != null,
                onTap: onPickDate,
              ),
              _chip(
                context,
                text: draft.startTime.isEmpty ? 'Start' : draft.startTime,
                icon: Icons.access_time,
                filled: draft.startTime.isNotEmpty,
                onTap: onPickStart,
              ),
              _chip(
                context,
                text: draft.endTime.isEmpty ? 'End' : draft.endTime,
                icon: Icons.access_time_filled,
                filled: draft.endTime.isNotEmpty,
                onTap: onPickEnd,
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
        required VoidCallback onTap}) {
    final w = (MediaQuery
        .of(ctx)
        .size
        .width - 100) / 3;
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
                  size: 14,
                  color: filled ? Colors.blue.shade600 : Colors.grey),
              const SizedBox(width: 6),
              Expanded(
                child: Text(text,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: filled ? FontWeight.w600 : FontWeight
                            .normal,
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

// ── 24-Hour time input dialog ─────────────────────────────────────────────────

class _TimeInputDialog extends StatefulWidget {
  final String initial;

  const _TimeInputDialog({required this.initial});

  @override
  State<_TimeInputDialog> createState() => _TimeInputDialogState();
}

class _TimeInputDialogState extends State<_TimeInputDialog> {
  late final TextEditingController _ctrl;
  String? _error;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initial);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  bool _isValid(String v) {
    final parts = v.split(':');
    if (parts.length != 2) return false;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    return h != null && m != null && h >= 0 && h <= 23 && m >= 0 && m <= 59;
  }

  void _confirm() {
    final v = _ctrl.text.trim();
    if (!_isValid(v)) {
      setState(() => _error = 'Enter time as HH:MM (e.g. 14:30)');
      return;
    }
    Navigator.pop(context, v);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Row(
        children: [
          Icon(Icons.access_time, size: 20, color: Color(0xFF1A73E8)),
          SizedBox(width: 8),
          Text('Select Time (24h)', style: TextStyle(fontSize: 16)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Enter time in HH:MM format',
              style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 10),
          TextField(
            controller: _ctrl,
            autofocus: true,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9:]')),
              _TimeFormatter(),
            ],
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 4),
            decoration: InputDecoration(
              hintText: '00:00',
              hintStyle: TextStyle(color: Colors.grey.shade300),
              errorText: _error,
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                const BorderSide(color: Color(0xFF1A73E8), width: 2),
              ),
            ),
            onSubmitted: (_) => _confirm(),
          ),
          const SizedBox(height: 8),
          // Quick preset buttons
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              '06:00', '07:00', '08:00', '09:00', '12:00',
              '14:00', '16:00', '18:00', '20:00', '22:00',
            ]
                .map((t) =>
                InkWell(
                  onTap: () {
                    _ctrl.text = t;
                    setState(() => _error = null);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: Colors.blue.withOpacity(0.2)),
                    ),
                    child: Text(t,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w600)),
                  ),
                ))
                .toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        ElevatedButton(
          onPressed: _confirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A73E8),
            foregroundColor: Colors.white,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}

// ── Auto-insert colon formatter ───────────────────────────────────────────────

class _TimeFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue old,
      TextEditingValue next) {
    var text = next.text.replaceAll(':', '');
    if (text.length > 4) text = text.substring(0, 4);
    if (text.length >= 3) text = '${text.substring(0, 2)}:${text.substring(2)}';
    return next.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

// ── Location picker ───────────────────────────────────────────────────────────

class _LocationPickerScreen extends StatefulWidget {
  const _LocationPickerScreen();

  @override
  State<_LocationPickerScreen> createState() =>
      _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<_LocationPickerScreen> {
  LatLng? _selected;
  Marker? _marker;
  bool _loading = false;

  Future<String> _getAddress(LatLng pos) async {
    try {
      final places =
      await placemarkFromCoordinates(pos.latitude, pos.longitude);
      final p = places.first;
      return '${p.street}, ${p.locality}, ${p.country}';
    } catch (_) {
      return '${pos.latitude.toStringAsFixed(5)}, ${pos.longitude
          .toStringAsFixed(5)}';
    }
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
              _marker =
                  Marker(markerId: const MarkerId('sel'), position: latlng);
            }),
        markers: _marker != null ? {_marker!} : {},
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _selected == null || _loading
            ? null
            : () async {
          setState(() => _loading = true);
          final addr = await _getAddress(_selected!);
          if (context.mounted) {
            Navigator.pop(context, {
              'lat': _selected!.latitude,
              'lng': _selected!.longitude,
              'address': addr,
            });
          }
        },
        label: _loading
            ? const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
                color: Colors.white, strokeWidth: 2))
            : const Text('Confirm'),
        icon: const Icon(Icons.check),
      ),
    );
  }
}