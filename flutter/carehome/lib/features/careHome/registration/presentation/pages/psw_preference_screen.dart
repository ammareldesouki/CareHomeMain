import 'package:flutter/material.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/widgets/elvated_button.dart';
import '../../../../layout/bottom_navegation_bar.dart';

class PswPreferenceScreen extends StatefulWidget {
  const PswPreferenceScreen({super.key});

  @override
  State<PswPreferenceScreen> createState() => _PswPreferenceScreenState();
}

class _PswPreferenceScreenState extends State<PswPreferenceScreen> {
  String? _preferredGender;
  RangeValues _ageRange = const RangeValues(20, 60);
  final Set<String> _selectedSkills = {};
  final TextEditingController _notesController = TextEditingController();

  static const List<String> _skills = [
    'Dementia Care',
    'Palliative Care',
    'Wound Care',
    'Mobility Assistance',
    'Medication Administration',
    'Catheter Care',
    'Feeding Assistance',
    'Behavioural Support',
    'Post-Surgical Care',
    'Mental Health Support',
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _continue() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const CBottomNavigationBar(role: 'CareHome'),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('PSW Preferences'),
        leading: const BackButton(),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _continue,
            child: Text(
              'Skip',
              style: TextStyle(color: TColors.darkBlue),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ───────────────────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [TColors.darkBlue, TColors.blue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PSW Preferences',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Tell us what kind of PSW you prefer. These are optional preferences to help us find the best match.',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Gender Preference ─────────────────────────────────────
                  _sectionTitle('Preferred Gender'),
                  const SizedBox(height: 12),
                  Row(
                    children: ['No Preference', 'Female', 'Male'].map((g) {
                      final selected = _preferredGender == g;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _preferredGender = g),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: selected
                                    ? TColors.primary
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: selected
                                      ? TColors.primary
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Text(
                                g,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: selected
                                      ? Colors.white
                                      : Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // ── Age Range ─────────────────────────────────────────────
                  _sectionTitle(
                      'Preferred Age Range: ${_ageRange.start.round()} – ${_ageRange.end.round()} years'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: RangeSlider(
                      values: _ageRange,
                      min: 18,
                      max: 70,
                      divisions: 52,
                      activeColor: TColors.primary,
                      inactiveColor: TColors.primary.withOpacity(0.2),
                      labels: RangeLabels(
                        _ageRange.start.round().toString(),
                        _ageRange.end.round().toString(),
                      ),
                      onChanged: (values) =>
                          setState(() => _ageRange = values),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Required Skills ───────────────────────────────────────
                  _sectionTitle('Required Skills / Certifications'),
                  const SizedBox(height: 4),
                  Text(
                    'Select all that apply (optional)',
                    style:
                        TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _skills.map((skill) {
                      final selected = _selectedSkills.contains(skill);
                      return FilterChip(
                        label: Text(
                          skill,
                          style: TextStyle(
                            fontSize: 12,
                            color: selected
                                ? Colors.white
                                : Colors.grey.shade700,
                          ),
                        ),
                        selected: selected,
                        onSelected: (val) {
                          setState(() {
                            if (val) {
                              _selectedSkills.add(skill);
                            } else {
                              _selectedSkills.remove(skill);
                            }
                          });
                        },
                        selectedColor: TColors.primary,
                        checkmarkColor: Colors.white,
                        backgroundColor: Colors.white,
                        side: BorderSide(
                          color: selected
                              ? TColors.primary
                              : Colors.grey.shade300,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // ── Additional Notes ──────────────────────────────────────
                  _sectionTitle('Additional Notes (optional)'),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText:
                          'Any specific requirements or preferences for your PSW...',
                      hintStyle: TextStyle(
                          color: Colors.grey.shade400, fontSize: 13),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: TColors.primary),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          // ── Bottom Button ─────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: TElevatedButton(
                text: 'Complete Registration',
                onPressed: _continue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1D4B7C),
      ),
    );
  }
}
