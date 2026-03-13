import 'package:carehome/features/auth/presentation/pages/OrganizationRegisterScreen/presentation/manager/employer_type.dart';
import 'package:carehome/features/auth/presentation/pages/OrganizationRegisterScreen/presentation/widgets/individual_form.dart';
import 'package:carehome/features/auth/presentation/pages/OrganizationRegisterScreen/presentation/widgets/multiple_form.dart';
import 'package:flutter/material.dart';

class OrganizationRegisterScreen extends StatefulWidget {
  const OrganizationRegisterScreen({super.key});

  @override
  State<OrganizationRegisterScreen> createState() =>
      _OrganizationRegisterScreenState();
}

class _OrganizationRegisterScreenState
    extends State<OrganizationRegisterScreen> {
  EmployerType? selectedType;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// Employer Type Dropdown
                  const Text("Employer Type"),
                  const SizedBox(height: 8),

                  DropdownButtonFormField<EmployerType>(
                    value: selectedType,
                    decoration: _inputDecoration("Select Employer Type"),
                    items: const [
                      DropdownMenuItem(
                        value: EmployerType.individual,
                        child: Text("Independent / Individual"),
                      ),
                      DropdownMenuItem(
                        value: EmployerType.multiple,
                        child: Text("Multiple Care Homes"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedType = value;
                      });
                    },
                  ),

                  const SizedBox(height: 25),

                  /// Dynamic Form
                  if (selectedType == EmployerType.individual)
                    const IndividualForm(),

                  if (selectedType == EmployerType.multiple)
                    const MultipleCareHomeForm(),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (selectedType == null) {
                            Text(
                              "Select Employer Type",
                              style: TextStyle(color: Colors.red),
                            );
                            // TODO: call bloc here
                          }

                          // TODO: call bloc here
                        }
                      },
                      child: Text(
                        selectedType == null
                            ? "Select Employer Type"
                            : "Sign Up",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.grey.shade200,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  );
}
