import 'package:carehome/core/utils/validator.dart';
import 'package:carehome/features/careHome/registration/presentation/wedgits/common_field.dart';
import 'package:carehome/features/auth/presentation/widgets/custome_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/utils/image_picker_helper.dart';
import '../manager/care_home_registration_bloc.dart';

class MultipleCareHomeForm extends StatefulWidget {
  const MultipleCareHomeForm({super.key});

  @override
  State<MultipleCareHomeForm> createState() => _MultipleCareHomeFormState();
}

class _MultipleCareHomeFormState extends State<MultipleCareHomeForm> {
  final TextEditingController streetController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  void _dispatch(String field, String value) {
    context.read<CareHomeRegistrationBloc>().add(
      UpdateFormFieldEvent(fieldName: field, value: value),
    );
  }

  void _uploadDoc(String key, String path) {
    context.read<CareHomeRegistrationBloc>().add(
      UploadOrgDocumentEvent(documentKey: key, filePath: path),
    );
  }

  Future<void> _pickDocument(String documentKey) async {
    final path = await ImagePickerHelper.showPickerSheet(context);
    if (path != null) _uploadDoc(documentKey, path);
  }

  @override
  void dispose() {
    streetController.dispose();
    cityController.dispose();
    stateController.dispose();
    postalCodeController.dispose();
    countryController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Widget _uploadButton(String label, String documentKey) {
    return BlocBuilder<CareHomeRegistrationBloc, CareHomeRegistrationState>(
      builder: (context, state) {
        final filePath = state.uploadedDocuments[documentKey];
        final hasFile = filePath != null;
        return InkWell(
          onTap: () => _pickDocument(documentKey),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasFile ? Colors.green.shade300 : Colors.grey.shade300,
              ),
              color: hasFile ? Colors.green.shade50 : Colors.grey.shade50,
            ),
            child: Row(
              children: [
                Icon(
                  hasFile ? Icons.check_circle : Icons.upload_file,
                  color: hasFile ? Colors.green : TColors.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    hasFile ? filePath.split('/').last : label,
                    style: TextStyle(
                      color: hasFile
                          ? Colors.green.shade700
                          : Colors.grey.shade700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (hasFile)
                  Icon(Icons.close, size: 18, color: Colors.red.shade300),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CareHomeRegistrationBloc, CareHomeRegistrationState>(
      builder: (context, state) {
        return Column(
          children: [
            // ── Business License ────────────────────────────────────────────
            const SizedBox(height: 15),
            sectionTitle("BUSINESS LICENSE"),
            const SizedBox(height: 12),
            TCustomeFormField(
              hint: "Business License Number",
              onChanged: (val) => _dispatch('businessLicenseNumber', val),
            ),
            const SizedBox(height: 10),
            _uploadButton(
                "Upload Business License Document", "businessLicense"),

            const SizedBox(height: 20),

            // ── Legal Entity Information ────────────────────────────────────
            sectionTitle("LEGAL ENTITY INFORMATION"),
            const SizedBox(height: 15),
            TCustomeFormField(
              hint: "Legal Entity Name",
              validation: Validator.validateFullName,
              onChanged: (val) => _dispatch('legalEntityName', val),
            ),
            // TCustomeFormField(
            //   hint: "Legal Entity Address",
            //   validation: Validator.validateFullName,
            //   onChanged: (val) => _dispatch('legalEntityAddress', val),
            // ),

            // Address controllers — onChanged added so BLoC collects them
            TCustomeFormField(
              controller: streetController,
              hint: 'Street Address',
              validation: (v) =>
              (v?.isEmpty ?? true) ? 'Please enter your street address' : null,
              prefixIcon: const Icon(Icons.add_road, color: Colors.grey),
              onChanged: (val) => _dispatch('street', val),
            ),
            TCustomeFormField(
              controller: cityController,
              hint: 'City',
              validation: (v) =>
              (v?.isEmpty ?? true) ? 'Please enter your city' : null,
              prefixIcon: const Icon(Icons.location_city, color: Colors.grey),
              onChanged: (val) => _dispatch('city', val),
            ),
            TCustomeFormField(
              controller: stateController,
              hint: 'State / Province',
              validation: (v) =>
              (v?.isEmpty ?? true) ? 'Please enter your state' : null,
              prefixIcon: const Icon(Icons.map, color: Colors.grey),
              onChanged: (val) => _dispatch('state', val),
            ),
            TCustomeFormField(
              controller: postalCodeController,
              hint: 'Postal Code',
              validation: (v) =>
              (v?.isEmpty ?? true) ? 'Please enter your postal code' : null,
              prefixIcon: const Icon(
                  Icons.markunread_mailbox_outlined, color: Colors.grey),
              onChanged: (val) => _dispatch('postalCode', val),
            ),
            TCustomeFormField(
              controller: countryController,
              hint: 'Country',
              validation: (v) =>
              (v?.isEmpty ?? true) ? 'Please enter your country' : null,
              prefixIcon: const Icon(Icons.flag_outlined, color: Colors.grey),
              onChanged: (val) => _dispatch('country', val),
            ),

            const SizedBox(height: 20),

            // ── Registered Office Address ───────────────────────────────────
            sectionTitle("ENTER REGISTERED OFFICE ADDRESS"),
            const SizedBox(height: 15),
            TCustomeFormField(
              hint: "House Number or Name",
              validation: Validator.validateFullName,
              onChanged: (val) => _dispatch('houseNumber', val),
            ),
            TCustomeFormField(
              hint: "Postcode",
              onChanged: (val) => _dispatch('postcode', val),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                const Expanded(
                  child: Text(
                    "Enter the full address yourself",
                    style: TextStyle(color: Colors.teal),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Find Address"),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // ── Vaccination Policy ──────────────────────────────────────────
            sectionTitle("VACCINATION POLICY"),
            const SizedBox(height: 15),
            SwitchListTile(
              title: const Text('Covid Vaccination Required'),
              value: state.vaccinationPolicy['covid'] ?? false,
              activeColor: TColors.primary,
              onChanged: (value) {
                context.read<CareHomeRegistrationBloc>().add(
                  ToggleVaccinationPolicyEvent(
                      policyType: 'covid', value: value),
                );
              },
            ),
            SwitchListTile(
              title: const Text('Flu Vaccination Required'),
              value: state.vaccinationPolicy['flu'] ?? false,
              activeColor: TColors.primary,
              onChanged: (value) {
                context.read<CareHomeRegistrationBloc>().add(
                  ToggleVaccinationPolicyEvent(policyType: 'flu', value: value),
                );
              },
            ),

            const SizedBox(height: 25),

            // ── Insurance ───────────────────────────────────────────────────
            sectionTitle("INSURANCE"),
            const SizedBox(height: 15),
            _uploadButton("Upload Insurance Certificate", "insurance"),

            const SizedBox(height: 25),

            // ── Key Contact Person ──────────────────────────────────────────
            sectionTitle("KEY CONTACT PERSON"),
            const SizedBox(height: 15),
            TCustomeFormField(
              hint: "First Name",
              validation: Validator.validateFullName,
              onChanged: (val) => _dispatch('contactFirstName', val),
            ),
            TCustomeFormField(
              hint: "Last Name",
              validation: Validator.validateFullName,
              onChanged: (val) => _dispatch('contactLastName', val),
            ),
            TCustomeFormField(
              hint: "Phone Number",
              validation: Validator.validatePhoneNumber,
              onChanged: (val) => _dispatch('contactPhone', val),
            ),
            TCustomeFormField(
              hint: "Email",
              validation: Validator.validateEmail,
              onChanged: (val) => _dispatch('accountEmail', val),
            ),
            TCustomeFormField(
              controller: passwordController,
              hint: "Password",
              isObscured: true,
              validation: Validator.validatePassword,
              onChanged: (val) => _dispatch('password', val),
            ),
            TCustomeFormField(
              controller: confirmPasswordController,
              hint: "Confirm Password",
              isObscured: true,
              validation: (value) =>
                  Validator.validateConfirmPassword(
                    value,
                    passwordController.text,
                  ),
              // No dispatch — local confirm-only field
            ),
          ],
        );
      },
    );
  }
}