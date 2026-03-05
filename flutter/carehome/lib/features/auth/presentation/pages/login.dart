import 'package:carehome/features/auth/presentation/manager/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/image_strings.dart';
import '../../../../core/route/route_name.dart';
import '../../../../core/utils/validator.dart';
import '../../../../core/widgets/elvated_button.dart';
import '../../../layout/bottom_navegation_bar.dart';
import '../../data/models/singIn_request.dart';
import '../widgets/custome_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => AuthBloc(),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            // ── loading ────────────────────────────────────────────────────
            if (state is AuthSignInLoading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                    const Center(child: CircularProgressIndicator()),
              );
            }

            // ── success → navigate based on role ──────────────────────────
            if (state is AuthSignInSuccess) {
              Navigator.pop(context); // close loading dialog

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      CBottomNavigationBar(role: state.user.role),
                ),
              );
            }

            // ── error ─────────────────────────────────────────────────────
            if (state is AuthSignInError) {
              Navigator.pop(context); // close loading dialog

              ScaffoldMessenger.of(context).showSnackBar(
                  (SnackBar(content: Text(state.error))));
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image(
                          image: AssetImage(TImages.logoRemove),
                          height: MediaQuery
                              .sizeOf(context)
                              .height * 0.2,
                        ),

                        // ── Email ──────────────────────────────────────
                        TCustomeFormField(
                          controller: emailController,
                          hint: 'Email',
                          validation: Validator.validateEmail,
                          hintTextStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: Colors.grey,
                          ),
                        ),

                        // ── Password ───────────────────────────────────
                        TCustomeFormField(
                          controller: passwordController,
                          hint: 'Password',
                          isObscured: true,
                          validation: Validator.validatePassword,
                          hintTextStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: Colors.grey,
                          ),
                        ),

                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () =>
                                Navigator.pushNamed(
                                  context,
                                  RouteNames.forgetPassword,
                                ),
                            child: Text(
                              'Forget Password',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                  color: TColors.secondaryTextColor),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ── Sign In button ─────────────────────────────
                        TElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                SignInEvent(
                                  SignInRequest(
                                    email: emailController.text.trim(),
                                    password:
                                    passwordController.text.trim(),
                                  ),
                                ),
                              );
                            }
                          },
                          text: 'Sign In',
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account ?",
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyMedium,
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.pushNamed(
                                    context,
                                    RouteNames.swithchRule,
                                  ),
                              child: Text(
                                'Sign Up',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: TColors.primary),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}