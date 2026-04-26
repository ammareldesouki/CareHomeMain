import 'package:carehome/core/route/route_name.dart';
import 'package:carehome/features/auth/presentation/widgets/custome_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/image_strings.dart';
import '../../../../../core/utils/validator.dart';
import '../../../../../core/widgets/elvated_button.dart';
import '../../../../auth/presentation/manager/auth_bloc.dart';

class PSWSignUpScreen extends StatefulWidget {
  const PSWSignUpScreen({super.key});

  @override
  State<PSWSignUpScreen> createState() => _PSWSignUpScreenState();
}

class _PSWSignUpScreenState extends State<PSWSignUpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  DateTime? selectedDateOfBirth;
  final TextEditingController dobController = TextEditingController();

  String? selectedGender;
  final List<String> genderOptions = ['Male', 'Female'];

  String selectedJobTitle = 'PSW'; // Default selection

  final TextEditingController apartmentController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  Future<void> _selectDateOfBirth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDateOfBirth = picked;
        dobController.text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  /// Convert DD/MM/YYYY → ISO-8601 for the API
  String _toIso8601(DateTime date) => date.toUtc().toIso8601String();

  @override
  void dispose() {
    nameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    dobController.dispose();
    apartmentController.dispose();
    streetController.dispose();
    cityController.dispose();
    stateController.dispose();
    postalCodeController.dispose();
    countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (context) => AuthBloc(),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSignUpLoading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                    const Center(child: CircularProgressIndicator()),
              );
            }

            if (state is AuthSignUpSuccess) {
              Navigator.pop(context); // close loading dialog
              Navigator.pushReplacementNamed(
                context,
                RouteNames.login,
              );
            }

            if (state is AuthSignUpError) {
              Navigator.pop(context); // close loading dialog
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListView(
                  children: [
                    Image(
                      image: AssetImage(TImages.logoRemove),
                      height: MediaQuery.sizeOf(context).height * 0.2,
                    ),
                    Center(
                      child: Text(
                        'Create Care Giver Account',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _sectionHeader(context, 'Position'),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _jobTitleCard(
                              context,
                              title: 'PSW',

                              icon: Icons.person_search,
                              isSelected: selectedJobTitle == 'PSW',
                              onTap: () =>
                                  setState(() => selectedJobTitle = 'PSW'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _jobTitleCard(
                              context,
                              title: 'DSW',
                              icon: Icons.health_and_safety,
                              isSelected: selectedJobTitle == 'DSW',
                              onTap: () =>
                                  setState(() => selectedJobTitle = 'DSW'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                      ),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _sectionHeader(context, 'Personal Information'),
                            TCustomeFormField(
                              controller: nameController,
                              hint: 'First Name',
                              validation: Validator.validateFullName,
                              prefixIcon: const Icon(
                                Icons.person,
                                color: Colors.grey,
                              ),
                            ),
                            TCustomeFormField(
                              controller: lastNameController,
                              hint: 'Last Name',
                              validation: Validator.validateFullName,
                              prefixIcon: const Icon(
                                Icons.person,
                                color: Colors.grey,
                              ),
                            ),
                            TCustomeFormField(
                              controller: phoneController,
                              hint: 'Phone Number',
                              validation: Validator.validatePhoneNumber,
                              prefixIcon: const Icon(
                                Icons.phone,
                                color: Colors.grey,
                              ),
                            ),
                            TCustomeFormField(
                              controller: emailController,
                              hint: 'Email',
                              validation: Validator.validateEmail,
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                color: Colors.grey,
                              ),
                            ),
                            TCustomeFormField(
                              controller: passwordController,
                              hint: 'Password',
                              isObscured: true,
                              validation: Validator.validatePassword,
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: Colors.grey,
                              ),
                            ),

                            _sectionHeader(context, 'Date of Birth'),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              child: TextFormField(
                                controller: dobController,
                                readOnly: true,
                                onTap: () => _selectDateOfBirth(context),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select your date of birth';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Date of Birth (DD/MM/YYYY)',
                                  prefixIcon: const Icon(
                                    Icons.calendar_today,
                                    color: Colors.grey,
                                  ),
                                  suffixIcon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.grey,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                ),
                              ),
                            ),



                            _sectionHeader(context, 'Gender'),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              child: DropdownButtonFormField<String>(
                                value: selectedGender,
                                hint: const Text('Select Gender'),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.wc,
                                    color: Colors.grey,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select your gender';
                                  }
                                  return null;
                                },
                                items: genderOptions.map((gender) {
                                  return DropdownMenuItem(
                                    value: gender,
                                    child: Text(gender),
                                  );
                                }).toList(),
                                onChanged: (value) =>
                                    setState(() => selectedGender = value),
                              ),
                            ),

                            _sectionHeader(context, 'Address'),
                            TCustomeFormField(
                              controller: apartmentController,
                              hint: 'Apartment / Unit (optional)',
                              validation: (_) => null,
                              prefixIcon: const Icon(
                                Icons.apartment,
                                color: Colors.grey,
                              ),
                            ),
                            TCustomeFormField(
                              controller: streetController,
                              hint: 'Street Address',
                              validation: (v) => (v?.isEmpty ?? true)
                                  ? 'Please enter your street address'
                                  : null,
                              prefixIcon: const Icon(
                                Icons.add_road,
                                color: Colors.grey,
                              ),
                            ),
                            TCustomeFormField(
                              controller: cityController,
                              hint: 'City',
                              validation: (v) => (v?.isEmpty ?? true)
                                  ? 'Please enter your city'
                                  : null,
                              prefixIcon: const Icon(
                                Icons.location_city,
                                color: Colors.grey,
                              ),
                            ),
                            TCustomeFormField(
                              controller: stateController,
                              hint: 'State / Province',
                              validation: (v) => (v?.isEmpty ?? true)
                                  ? 'Please enter your state'
                                  : null,
                              prefixIcon: const Icon(
                                Icons.map,
                                color: Colors.grey,
                              ),
                            ),
                            TCustomeFormField(
                              controller: postalCodeController,
                              hint: 'Postal Code',
                              validation: (v) => (v?.isEmpty ?? true)
                                  ? 'Please enter your postal code'
                                  : null,
                              prefixIcon: const Icon(
                                Icons.markunread_mailbox_outlined,
                                color: Colors.grey,
                              ),
                            ),
                            TCustomeFormField(
                              controller: countryController,
                              hint: 'Country',
                              validation: (v) => (v?.isEmpty ?? true)
                                  ? 'Please enter your country'
                                  : null,
                              prefixIcon: const Icon(
                                Icons.flag_outlined,
                                color: Colors.grey,
                              ),
                            ),

                            // ── Submit ───────────────────────────────────────
                            TElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  context.read<AuthBloc>().add(
                                    PswSignUpEvent(
                                      firstName: nameController.text.trim(),
                                      lastName: lastNameController.text.trim(),
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim(),
                                      phoneNumber: phoneController.text.trim(),
                                      dateOfBirth: _toIso8601(
                                        selectedDateOfBirth!,
                                      ),
                                      gender: selectedGender!,
                                      role: selectedJobTitle,

                                      apartmentNumber: apartmentController.text
                                          .trim(),
                                      street: streetController.text.trim(),
                                      city: cityController.text.trim(),
                                      state: stateController.text.trim(),
                                      postalCode: postalCodeController.text
                                          .trim(),
                                      country: countryController.text.trim(),
                                    ),
                                  );
                                }
                              },
                              text: 'Sign Up',
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account?'),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Sign In'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _jobTitleCard(
    BuildContext context, {
    required String title,

    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? TColors.darkBlue : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? TColors.darkBlue  : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: TColors.darkBlue.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? Colors.white : Colors.grey.shade600,
            ),
            const SizedBox(height: 8),
            Text(
              title,

            ),
            const SizedBox(height: 4),

          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Colors.grey.shade700,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
