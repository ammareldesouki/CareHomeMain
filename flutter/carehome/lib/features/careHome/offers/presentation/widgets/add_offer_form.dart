import 'package:flutter/material.dart';
import '../../../../../core/constants/colors.dart';
import '../../data/models/selected_location.dart';
import 'location_picker_screen.dart';

class Shift {
  DateTime? date;
  TimeOfDay? from;
  TimeOfDay? to;

  Shift({this.date, this.from, this.to});
}

class AddOfferForm extends StatefulWidget {
  const AddOfferForm({super.key});

  @override
  State<AddOfferForm> createState() => _AddOfferFormState();
}

class _AddOfferFormState extends State<AddOfferForm> {
  List<Shift> shifts = [Shift()];
  SelectedLocation? selectedLocation;

  Future<void> _pickDate(int index) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (date != null) setState(() => shifts[index].date = date);
  }

  Future<void> _pickTime(int index, bool isFrom) async {
    final time =
    await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time != null) {
      setState(() {
        isFrom ? shifts[index].from = time : shifts[index].to = time;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: TColors.light,
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Add New Job Offer',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('Create a new part-time position',
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close)),
                ],
              ),

              const SizedBox(height: 20),

              const Text('Job Title',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              _inputField(hint: 'e.g., Evening Care Assistant'),

              const SizedBox(height: 16),

              /// Branch
              const Text('Branch',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              InkWell(
                onTap: () async {
                  final result =
                  await Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                        builder: (_) => const LocationPickerScreen()),
                  );

                  if (result != null) {
                    setState(() {
                      selectedLocation = SelectedLocation(
                        lat: result["lat"],
                        lng: result["lng"],
                        address: result["address"],
                      );
                    });
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(width: 2, color: Colors.grey),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.location_searching,
                          color: TColors.primarIconColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          selectedLocation == null
                              ? "Tap To Select Location"
                              : selectedLocation!.address,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// Shifts (زي ما كانت)
              const Text('Shifts',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),

              Column(
                children: List.generate(shifts.length, (i) {
                  final shift = shifts[i];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Shift ${i + 1}",
                          style:
                          const TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _shiftBox(
                            text: shift.date == null
                                ? "Select date"
                                : "${shift.date!.day}/${shift.date!
                                .month}/${shift.date!.year}",
                            icon: Icons.calendar_today,
                            onTap: () => _pickDate(i),
                          ),
                          _shiftBox(
                            text: shift.from == null
                                ? "From"
                                : shift.from!.format(context),
                            icon: Icons.access_time,
                            onTap: () => _pickTime(i, true),
                          ),
                          _shiftBox(
                            text: shift.to == null
                                ? "To"
                                : shift.to!.format(context),
                            icon: Icons.access_time,
                            onTap: () => _pickTime(i, false),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  );
                }),
              ),

              TextButton.icon(
                onPressed: () => setState(() => shifts.add(Shift())),
                icon: const Icon(Icons.add),
                label: const Text("Add another shift"),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel')),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      debugPrint(selectedLocation?.address);
                    },
                    child: const Text('Add Offer'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _shiftBox({required String text,
    required IconData icon,
    required VoidCallback onTap}) {
    final width = MediaQuery
        .of(context)
        .size
        .width;
    final boxWidth = (width - 80) / 2;

    return SizedBox(
      width: boxWidth,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child:
                Text(text, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField({required String hint, int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade600),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
      ),
    );
  }
}
