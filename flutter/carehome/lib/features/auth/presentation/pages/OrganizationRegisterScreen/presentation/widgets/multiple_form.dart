import 'package:carehome/features/auth/presentation/pages/OrganizationRegisterScreen/presentation/widgets/common_field.dart';
import 'package:carehome/features/auth/presentation/widgets/custome_form_field.dart';

import 'package:flutter/material.dart';

class MultipleCareHomeForm extends StatelessWidget {
  const MultipleCareHomeForm({super.key});

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
        TCustomeFormField(hint: "Password", isObscured: true),
        TCustomeFormField(hint: "Confirm Password", isObscured: true),
      ],
    );
  }
}
