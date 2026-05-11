import 'package:carehome/core/utils/validator.dart';
import 'package:carehome/features/auth/presentation/pages/OrganizationRegisterScreen/presentation/widgets/common_field.dart';
import 'package:carehome/features/auth/presentation/widgets/custome_form_field.dart';

import 'package:flutter/material.dart';

class MultipleCareHomeForm extends StatefulWidget {
  const MultipleCareHomeForm({super.key});

  @override
  State<MultipleCareHomeForm> createState() => _MultipleCareHomeFormState();
}

class _MultipleCareHomeFormState extends State<MultipleCareHomeForm> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TCustomeFormField(hint: "Registered Number"),

        const SizedBox(height: 20),

        sectionTitle("ENTER REGISTERED OFFICE ADDRESS"),

        const SizedBox(height: 15),

        TCustomeFormField(hint: "House Number or Name"),
        TCustomeFormField(hint: "Postcode"),

        const SizedBox(height: 10),

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

        sectionTitle("MAIN CONTACT DETAILS"),

        const SizedBox(height: 15),

        TCustomeFormField(hint: "Title"),
        TCustomeFormField(hint: "First Name"),
        TCustomeFormField(hint: "Surname"),
        TCustomeFormField(hint: "Phone Number"),

        const SizedBox(height: 25),

        sectionTitle("ACCOUNT ACCESS"),

        const SizedBox(height: 15),

        TCustomeFormField(hint: "Email"),
        TCustomeFormField(hint: "Confirm Email"),
        TCustomeFormField(
          controller: passwordController,
          hint: "Password",
          isObscured: true,
          validation: Validator.validatePassword,
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
        ),
      ],
    );
  }
}
