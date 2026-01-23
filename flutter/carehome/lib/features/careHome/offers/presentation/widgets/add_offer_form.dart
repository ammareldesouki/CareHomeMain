import 'package:flutter/material.dart';

class AddOfferForm extends StatelessWidget {
  const AddOfferForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Add New Job Offer',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Create a new part-time position',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// Job Title
              const Text(
                'Job Title',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              _inputField(hint: 'e.g., Evening Care Assistant'),

              const SizedBox(height: 16),

              /// Branch
              const Text(
                'Branch',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              _dropdownField(hint: 'Select branch'),

              const SizedBox(height: 16),

              /// Date - Day - Time
              Row(
                children: [
                  Expanded(
                    child: _inputField(
                      hint: 'dd/mm/yyyy',
                      icon: Icons.calendar_today,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Expanded(child: _dropdownField(hint: 'Select day')),
                  const SizedBox(width: 8),
                  Expanded(child: _inputField(hint: 'e.g., 18:00 - 22:00')),
                ],
              ),

              const SizedBox(height: 16),

              /// Requirements
              const Text(
                'Requirements',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              _inputField(
                hint: 'List requirements and qualifications...',
                maxLines: 3,
              ),

              const SizedBox(height: 24),

              /// Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
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

  /// TextField
  Widget _inputField({required String hint, int maxLines = 1, IconData? icon}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade600),
        prefixIcon: icon != null ? Icon(icon, size: 18) : null,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  /// Dropdown placeholder
  Widget _dropdownField({required String hint}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(hint, style: TextStyle(color: Colors.grey.shade600)),
          const Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }
}
