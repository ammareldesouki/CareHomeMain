import 'package:carehome/features/careHome/registration/wedgits/common_field.dart';
import 'package:carehome/features/auth/presentation/widgets/custome_form_field.dart';
import 'package:carehome/features/careHome/registration/presentation/manager/carehome_registration_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/utils/validator.dart';

class MultipleCareHomeForm extends StatefulWidget {
  const MultipleCareHomeForm({super.key});

  @override
  State<MultipleCareHomeForm> createState() => _MultipleCareHomeFormState();
}

class _MultipleCareHomeFormState extends State<MultipleCareHomeForm> {
  final ImagePicker _picker = ImagePicker();

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
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      _uploadDoc(documentKey, image.path);
    }
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
            const SizedBox(height: 15),
            sectionTitle("BUSINESS LICENSE"),
            TCustomeFormField(
              hint: "Business License Number",
              // validation: Validator.validateFullName,
              onChanged: (val) => _dispatch('Business License Number', val),
            ),
            const SizedBox(height: 12),

            sectionTitle("LEGAL ENTITY INFORMATION"),
            const SizedBox(height: 15),
            TCustomeFormField(
              hint: "Legal Entity Name",
              validation: Validator.validateFullName,
              onChanged: (val) => _dispatch('legalEntityName', val),
            ),
            TCustomeFormField(
              hint: "Legal Entity Address",
              validation: Validator.validateFullName,
              onChanged: (val) => _dispatch('legalEntityAddress', val),
            ),

            const SizedBox(height: 20),

            sectionTitle("ENTER REGISTERED OFFICE ADDRESS"),
            const SizedBox(height: 15),
            TCustomeFormField(
              hint: "House Number or Name",
              validation: Validator.validateFullName,
              onChanged: (val) => _dispatch('houseNumber', val),
            ),
            TCustomeFormField(
              hint: "Postcode",
              validation: Validator.validateCanadianPostalCode,
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

            sectionTitle("VACCINATION POLICY"),
            const SizedBox(height: 15),
            SwitchListTile(
              title: const Text('Covid Vaccination Required'),
              value: state.vaccinationPolicy['covid'] ?? false,
              activeColor: TColors.primary,
              onChanged: (value) {
                context.read<CareHomeRegistrationBloc>().add(
                  ToggleVaccinationPolicyEvent(
                    policyType: 'covid',
                    value: value,
                  ),
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
              hint: "Email Address",
              validation: Validator.validateEmail,
              onChanged: (val) => _dispatch('contactEmail', val),
            ),
            TCustomeFormField(
              hint: "Phone Number",
              validation: Validator.validatePhoneNumber,
              onChanged: (val) => _dispatch('contactPhone', val),
            ),

            const SizedBox(height: 25),

            sectionTitle("INSURANCE"),
            const SizedBox(height: 12),
            _uploadButton('Upload Insurance Document', 'insurance'),

            const SizedBox(height: 25),

            sectionTitle("ACCOUNT ACCESS"),
            const SizedBox(height: 15),
            TCustomeFormField(
              hint: "Email",
              validation: Validator.validateEmail,
              onChanged: (val) => _dispatch('accountEmail', val),
            ),

            TCustomeFormField(
              hint: "Password",
              isObscured: true,
              validation: Validator.validatePassword,
              onChanged: (val) => _dispatch('password', val),
            ),
            TCustomeFormField(
              hint: "Confirm Password",
              isObscured: true,
              validation: Validator.validatePassword,
            ),
          ],
        );
      },
    );
  }
}
