import 'package:carehome/core/utils/validator.dart';
import 'package:carehome/features/careHome/registration/wedgits/common_field.dart';
import 'package:carehome/features/auth/presentation/widgets/custome_form_field.dart';
import 'package:carehome/features/careHome/registration/presentation/manager/carehome_registration_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IndividualForm extends StatelessWidget {
  const IndividualForm({super.key});

  void _dispatch(BuildContext context, String field, String value) {
    context.read<CareHomeRegistrationBloc>().add(
      UpdateFormFieldEvent(fieldName: field, value: value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        sectionTitle("PERSONAL INFORMATION"),
        const SizedBox(height: 15),

        TCustomeFormField(
          hint: "First Name",
          validation: Validator.validateFullName,
          prefixIcon: const Icon(Icons.person, color: Colors.grey),
          onChanged: (val) => _dispatch(context, 'firstName', val),
        ),
        TCustomeFormField(
          hint: "Last Name",
          validation: Validator.validateFullName,
          prefixIcon: const Icon(Icons.person_outline, color: Colors.grey),
          onChanged: (val) => _dispatch(context, 'lastName', val),
        ),
        TCustomeFormField(
          hint: "Address",
          validation: Validator.validateFullName,
          prefixIcon: const Icon(Icons.location_on, color: Colors.grey),
          onChanged: (val) => _dispatch(context, 'address', val),
        ),

        TCustomeFormField(
          hint: "Phone Number",
          validation: Validator.validatePhoneNumber,
          prefixIcon: const Icon(Icons.phone, color: Colors.grey),
          onChanged: (val) => _dispatch(context, 'phone', val),
        ),

        const SizedBox(height: 25),

        sectionTitle("CUSTOMER INFORMATION"),
        const SizedBox(height: 15),

        TCustomeFormField(
          hint: "Customer First Name",
          validation: Validator.validateFullName,
          prefixIcon: const Icon(Icons.person, color: Colors.grey),
          onChanged: (val) => _dispatch(context, 'customerFirstName', val),
        ),
        TCustomeFormField(
          hint: "Customer Last Name",
          validation: Validator.validateFullName,
          prefixIcon: const Icon(Icons.person_outline, color: Colors.grey),
          onChanged: (val) => _dispatch(context, 'customerLastName', val),
        ),

        const SizedBox(height: 25),

        sectionTitle("ACCOUNT ACCESS"),
        const SizedBox(height: 15),

        TCustomeFormField(
          hint: "Email",
          validation: Validator.validateEmail,
          prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
          onChanged: (val) => _dispatch(context, 'accountEmail', val),
        ),

        TCustomeFormField(
          hint: "Password",
          isObscured: true,
          validation: Validator.validatePassword,
          prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
          onChanged: (val) => _dispatch(context, 'password', val),
        ),
        TCustomeFormField(
          hint: "Confirm Password",
          isObscured: true,
          validation: Validator.validatePassword,
          prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
        ),
      ],
    );
  }
}
