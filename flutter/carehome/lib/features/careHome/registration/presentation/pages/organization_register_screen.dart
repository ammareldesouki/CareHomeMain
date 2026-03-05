import 'package:carehome/features/careHome/registration/presentation/manager/employer_type.dart';

import 'package:carehome/features/careHome/registration/presentation/pages/registration_contract_screen.dart';
import 'package:carehome/features/careHome/registration/presentation/pages/terms_and_conditions_screen.dart';
import 'package:carehome/features/layout/bottom_navegation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/elvated_button.dart';
import '../manager/care_home_registration_bloc.dart';
import '../wedgits/individual_form.dart';
import '../wedgits/multiple_form.dart';

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

  // Single shared BLoC instance passed through all registration screens
  final CareHomeRegistrationBloc _registrationBloc = CareHomeRegistrationBloc();

  @override
  void dispose() {
    _registrationBloc.close();
    super.dispose();
  }

  void _navigateToTerms() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TermsAndConditionsScreen(
          bloc: _registrationBloc,
          onAccepted: _navigateToContract,
        ),
      ),
    );
  }

  void _navigateToContract() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegistrationContractScreen(
          bloc: _registrationBloc,
          onSigned: () {
            // Trigger the real API call with the chosen employer type
            _registrationBloc.add(SubmitRegistrationEvent(selectedType!));


              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                  const CBottomNavigationBar(role: 'CareHome'),
                ),
                    (route) => false,
              );
            }

        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _registrationBloc,
      child: BlocListener<CareHomeRegistrationBloc, CareHomeRegistrationState>(
        listenWhen: (prev, curr) =>
        prev.errorMessage != curr.errorMessage &&
            curr.errorMessage != null,
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Care Home Registration')),
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
                      const Text(
                        'Step 1 of 3',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Registration Information",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Text("Employer Type"),
                      const SizedBox(height: 8),

                      DropdownButtonFormField<EmployerType>(
                        value: selectedType,
                        decoration:
                        _inputDecoration("Select Employer Type"),
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
                        onChanged: (value) =>
                            setState(() => selectedType = value),
                      ),

                      const SizedBox(height: 25),

                      if (selectedType == EmployerType.individual)
                        const IndividualForm(),

                      if (selectedType == EmployerType.multiple)
                        const MultipleCareHomeForm(),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        child: TElevatedButton(
                          onPressed: () {
                            if (selectedType != null &&
                                _formKey.currentState!.validate()) {
                              _navigateToTerms();
                            }
                          },
                          text: selectedType == null
                              ? "Select Employer Type"
                              : "Continue to Terms & Conditions",
                        ),
                      ),
                    ],
                  ),
                ),
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