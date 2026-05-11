import 'package:carehome/core/utils/validator.dart';
import 'package:carehome/features/auth/presentation/widgets/custome_form_field.dart';
import 'package:carehome/features/careHome/registration/presentation/wedgits/common_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../manager/care_home_registration_bloc.dart';


class IndividualForm extends StatefulWidget {
  const IndividualForm({super.key});

  @override
  State<IndividualForm> createState() => _IndividualFormState();
}

class _IndividualFormState extends State<IndividualForm> {
  final TextEditingController apartmentController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void _dispatch(BuildContext context, String field, String value) {
    context.read<CareHomeRegistrationBloc>().add(
      UpdateFormFieldEvent(fieldName: field, value: value),
    );
  }

  @override
  void dispose() {
    apartmentController.dispose();
    streetController.dispose();
    cityController.dispose();
    stateController.dispose();
    postalCodeController.dispose();
    countryController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Personal Information ────────────────────────────────────────────
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
          hint: "Phone Number",
          validation: Validator.validatePhoneNumber,
          prefixIcon: const Icon(Icons.phone, color: Colors.grey),
          onChanged: (val) => _dispatch(context, 'phone', val),
        ),

        // ── Address ─────────────────────────────────────────────────────────
        TCustomeFormField(
          controller: apartmentController,
          hint: 'Apartment / Unit (optional)',
          validation: (_) => null,
          prefixIcon: const Icon(Icons.apartment, color: Colors.grey),
          onChanged: (val) => _dispatch(context, 'apartment', val),
        ),
        TCustomeFormField(
          controller: streetController,
          hint: 'Street Address',
          validation: (v) =>
          (v?.isEmpty ?? true) ? 'Please enter your street address' : null,
          prefixIcon: const Icon(Icons.add_road, color: Colors.grey),
          onChanged: (val) => _dispatch(context, 'street', val),
        ),
        TCustomeFormField(
          controller: cityController,
          hint: 'City',
          validation: (v) =>
          (v?.isEmpty ?? true) ? 'Please enter your city' : null,
          prefixIcon: const Icon(Icons.location_city, color: Colors.grey),
          onChanged: (val) => _dispatch(context, 'city', val),
        ),
        TCustomeFormField(
          controller: stateController,
          hint: 'State / Province',
          validation: (v) =>
          (v?.isEmpty ?? true) ? 'Please enter your state' : null,
          prefixIcon: const Icon(Icons.map, color: Colors.grey),
          onChanged: (val) => _dispatch(context, 'state', val),
        ),
        TCustomeFormField(
          controller: postalCodeController,
          hint: 'Postal Code',
          validation: (v) =>
          (v?.isEmpty ?? true) ? 'Please enter your postal code' : null,
          prefixIcon: const Icon(
              Icons.markunread_mailbox_outlined, color: Colors.grey),
          onChanged: (val) => _dispatch(context, 'postalCode', val),
        ),
        TCustomeFormField(
          controller: countryController,
          hint: 'Country',
          validation: (v) =>
          (v?.isEmpty ?? true) ? 'Please enter your country' : null,
          prefixIcon: const Icon(Icons.flag_outlined, color: Colors.grey),
          onChanged: (val) => _dispatch(context, 'country', val),
        ),

        const SizedBox(height: 25),

        // ── Customer Information ────────────────────────────────────────────
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

        // ── Account Access ──────────────────────────────────────────────────
        sectionTitle("ACCOUNT ACCESS"),
        const SizedBox(height: 15),

        TCustomeFormField(
          hint: "Email",
          validation: Validator.validateEmail,
          prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
          onChanged: (val) => _dispatch(context, 'accountEmail', val),
        ),
        TCustomeFormField((
          controller: passwordControllerhint: "Password",
          isObscured: true,
          validation: Validator.validatePassword,
          prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
          onChanged: (val) => _dispatch(context, 'password', val),
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
          prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
        ),
      ],
    );
  }
}