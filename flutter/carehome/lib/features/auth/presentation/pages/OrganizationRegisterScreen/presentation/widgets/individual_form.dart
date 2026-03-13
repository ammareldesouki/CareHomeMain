import 'package:carehome/core/utils/validator.dart';
import 'package:carehome/features/auth/presentation/pages/OrganizationRegisterScreen/presentation/widgets/common_field.dart';
import 'package:carehome/features/auth/presentation/widgets/custome_form_field.dart';
import 'package:flutter/material.dart';

class IndividualForm extends StatelessWidget {
  const IndividualForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TCustomeFormField(hint: "ODS Code or Postcode"),
        const SizedBox(height: 12),

        Row(
          children: [
            const Expanded(
              child: Text(
                "Enter the full address yourself",
                style: TextStyle(color: Colors.teal),
              ),
            ),
            ElevatedButton(onPressed: () {}, child: const Text("Find Address")),
          ],
        ),

        const SizedBox(height: 25),

        sectionTitle("CONTACT DETAILS"),

        const SizedBox(height: 15),

        TCustomeFormField(
          hint: "Title",
          validation: Validator.validateFullName,
        ),
        TCustomeFormField(
          hint: "First Name",
          validation: Validator.validateFullName,
        ),
        TCustomeFormField(
          hint: "Surname",
          validation: Validator.validateFullName,
        ),
        TCustomeFormField(
          hint: "Phone Number",
          validation: Validator.validatePhoneNumber,
        ),

        const SizedBox(height: 25),

        sectionTitle("ACCOUNT ACCESS"),

        const SizedBox(height: 15),

        TCustomeFormField(hint: "Email", validation: Validator.validateEmail),
        TCustomeFormField(
          hint: "Confirm Email",
          validation: Validator.validateEmail,
        ),
        TCustomeFormField(
          hint: "Password",
          isObscured: true,
          validation: Validator.validatePassword,
        ),
        TCustomeFormField(
          hint: "Confirm Password",
          isObscured: true,
          validation: Validator.validatePassword,
        ),
      ],
    );
  }
}
