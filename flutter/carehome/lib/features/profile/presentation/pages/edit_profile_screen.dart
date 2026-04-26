import 'package:flutter/material.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/utils/validator.dart';
import '../../../auth/presentation/widgets/custome_form_field.dart';

class EditProfileScreen extends StatefulWidget {
  final String role;
  final dynamic profile;
  final Function(Map<String, dynamic>) onSave;

  const EditProfileScreen({
    super.key,
    required this.role,
    required this.profile,
    required this.onSave,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  late final TextEditingController _firstNameCtrl;
  late final TextEditingController _lastNameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _dobCtrl;
  late final TextEditingController _streetCtrl;
  late final TextEditingController _apartmentCtrl;
  late final TextEditingController _cityCtrl;
  late final TextEditingController _stateCtrl;
  late final TextEditingController _postalCodeCtrl;
  late final TextEditingController _countryCtrl;

  String _selectedGender = 'Male';
  final List<String> _genders = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say',
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _firstNameCtrl = TextEditingController(text: p.firstName);
    _lastNameCtrl = TextEditingController(text: p.lastName);
    _phoneCtrl = TextEditingController(text: p.phoneNumber);
    _dobCtrl = TextEditingController(text: _formatDateForInput(p.dateOfBirth));
    _streetCtrl = TextEditingController(text: p.address.street);
    _apartmentCtrl = TextEditingController(
      text: p.address.apartmentNumber > 0
          ? p.address.apartmentNumber.toString()
          : '',
    );
    _cityCtrl = TextEditingController(text: p.address.city);
    _stateCtrl = TextEditingController(text: p.address.state);
    _postalCodeCtrl = TextEditingController(text: p.address.postalCode);
    _countryCtrl = TextEditingController(text: p.address.country);
    _selectedGender = p.gender.isNotEmpty ? p.gender : 'Male';
  }

  String _formatDateForInput(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final dt = DateTime.parse(dateStr);
      return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return dateStr;
    }
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _phoneCtrl.dispose();
    _dobCtrl.dispose();
    _streetCtrl.dispose();
    _apartmentCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _postalCodeCtrl.dispose();
    _countryCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    DateTime? initial;
    try {
      initial = DateTime.parse(_dobCtrl.text);
    } catch (_) {
      initial = DateTime(1990);
    }
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1930),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      _dobCtrl.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final data = {
      'FirstName': _firstNameCtrl.text.trim(),
      'LastName': _lastNameCtrl.text.trim(),
      'PhoneNumber': _phoneCtrl.text.trim(),
      'DateOfBirth': _dobCtrl.text.trim(),
      'Gender': _selectedGender,
      'Address.ApartmentNumber': int.tryParse(_apartmentCtrl.text.trim()) ?? 0,
      'Address.Street': _streetCtrl.text.trim(),
      'Address.City': _cityCtrl.text.trim(),
      'Address.State': _stateCtrl.text.trim(),
      'Address.PostalCode': _postalCodeCtrl.text.trim(),
      'Address.Country': _countryCtrl.text.trim(),
    };

    widget.onSave(data);
    Navigator.pop(context);
    setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: TColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _save,
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _sectionHeader('Personal Information', Icons.person_outline),
            const SizedBox(height: 8),
            _card([
              TCustomeFormField(
                controller: _firstNameCtrl,
                hint: 'First Name',
                validation: Validator.validateFullName,
                prefixIcon: const Icon(
                  Icons.person_outline,
                  color: Colors.grey,
                ),
              ),
              TCustomeFormField(
                controller: _lastNameCtrl,
                hint: 'Last Name',
                validation: Validator.validateFullName,
                prefixIcon: const Icon(
                  Icons.badge_outlined,
                  color: Colors.grey,
                ),
              ),
              TCustomeFormField(
                controller: _phoneCtrl,
                hint: 'Phone Number',
                textInputType: TextInputType.phone,
                prefixIcon: const Icon(
                  Icons.phone_outlined,
                  color: Colors.grey,
                ),
              ),
              TCustomeFormField(
                controller: _dobCtrl,
                hint: 'Date of Birth (YYYY-MM-DD)',
                readOnly: true,
                onTap: _pickDate,
                prefixIcon: const Icon(Icons.cake_outlined, color: Colors.grey),
                suffixIcon: const Icon(
                  Icons.calendar_today,
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: DropdownButtonFormField<String>(
                  value: _selectedGender,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.person_pin_outlined,
                      color: Colors.grey,
                    ),
                    hintText: 'Gender',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        width: 1.0,
                        color: Colors.grey,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        width: 1.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  items: _genders
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedGender = value);
                    }
                  },
                ),
              ),
            ]),
            const SizedBox(height: 16),
            _sectionHeader('Address', Icons.location_on_outlined),
            const SizedBox(height: 8),
            _card([
              TCustomeFormField(
                controller: _streetCtrl,
                hint: 'Street',
                prefixIcon: const Icon(Icons.home_outlined, color: Colors.grey),
              ),
              TCustomeFormField(
                controller: _apartmentCtrl,
                hint: 'Apartment Number',
                textInputType: TextInputType.number,
                prefixIcon: const Icon(Icons.apartment, color: Colors.grey),
              ),
              TCustomeFormField(
                controller: _cityCtrl,
                hint: 'City',
                prefixIcon: const Icon(
                  Icons.location_city_outlined,
                  color: Colors.grey,
                ),
              ),
              TCustomeFormField(
                controller: _stateCtrl,
                hint: 'State / Province',
                prefixIcon: const Icon(Icons.map_outlined, color: Colors.grey),
              ),
              TCustomeFormField(
                controller: _postalCodeCtrl,
                hint: 'Postal Code',
                prefixIcon: const Icon(
                  Icons.markunread_mailbox_outlined,
                  color: Colors.grey,
                ),
              ),
              TCustomeFormField(
                controller: _countryCtrl,
                hint: 'Country',
                prefixIcon: const Icon(Icons.flag_outlined, color: Colors.grey),
              ),
            ]),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: _isSaving ? null : _save,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: TColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
      ],
    );
  }

  Widget _card(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}
