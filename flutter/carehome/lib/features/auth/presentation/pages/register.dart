import 'package:carehome/features/auth/presentation/manager/auth_bloc.dart';
import 'package:carehome/features/auth/presentation/pages/upload_screen.dart';
import 'package:carehome/features/layout/bottom_navegation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/image_strings.dart';
import '../../../../core/utils/validator.dart';
import '../../../../core/widgets/elvated_button.dart';
import '../../data/models/signup_request.dart';
import '../widgets/custome_form_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String selectedRole = 'CareHome'; // default value

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

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
              Navigator.pop(context); // close loading

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => UploadIdScreen(),
                  // CBottomNavigationBar(role: state.user.role),
                ),
              );
            }

            if (state is AuthSignUpError) {
              Navigator.pop(context); // close loading

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error)));
            }
            // TODO: implement listener
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
                        " Create An Account For CareHome ",
                        style: Theme.of(context).textTheme!.titleMedium,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                      ),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TCustomeFormField(
                              controller: nameController,
                              hint: 'First Name',
                              validation: Validator.validateFullName,
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.grey,
                              ),
                            ),

                            TCustomeFormField(
                              controller: phoneController,
                              hint: 'Phone Number',
                              validation: Validator.validatePhoneNumber,
                              prefixIcon: Icon(Icons.phone, color: Colors.grey),
                            ),

                            TCustomeFormField(
                              controller: emailController,
                              hint: 'Email',
                              validation: Validator.validateEmail,
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: Colors.grey,
                              ),
                            ),

                            TCustomeFormField(
                              controller: passwordController,
                              hint: 'Password',
                              isObscured: true,
                              validation: Validator.validatePassword,
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: Colors.grey,
                              ),
                            ),

                            TCustomeFormField(
                              controller: confirmPasswordController,
                              hint: 'Confirm Password',
                              isObscured: true,
                              validation: (value) =>
                                  Validator.validateConfirmPassword(
                                    value,
                                    passwordController.text,
                                  ),
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: Colors.grey,
                              ),
                            ),

                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     Row(
                            //       children: [
                            //         Radio<String>(
                            //           value: 'CareHome',
                            //           groupValue: selectedRole,
                            //           onChanged: (value) {
                            //             setState(() {
                            //               selectedRole = value!;
                            //             });
                            //           },
                            //         ),
                            //         const Text('Care Home'),
                            //       ],
                            //     ),
                            //
                            //     const SizedBox(width: 20),
                            //
                            //     // Row(
                            //     //   children: [
                            //     //     Radio<String>(
                            //     //       value: 'PSW',
                            //     //       groupValue: selectedRole,
                            //     //       onChanged: (value) {
                            //     //         setState(() {
                            //     //           selectedRole = value!;
                            //     //         });
                            //     //       },
                            //     //     ),
                            //     //     const Text('PSW'),
                            //     //   ],
                            //     // ),
                            //   ],
                            // ),
                            TElevatedButton(
                              onPressed: () {
                                // if (formKey.currentState!.validate()) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UploadIdScreen(),
                                  ),
                                );
                                // final request = SignupRequest(
                                //   fullName: nameController.text,
                                //   email: emailController.text,
                                //   password: passwordController.text,
                                //   phoneNumber: phoneController.text,
                                //   dateOfBirth: "2000-01-01",
                                //   // مؤقتًا
                                //   role: selectedRole,
                                // );
                                //
                                // context.read<AuthBloc>().add(
                                //   SignUpEvent(request),
                                // );
                                // }
                              },
                              text: "Sign Up",
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account ?"),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Sign In"),
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
}
