import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/image_strings.dart';
import '../../../../core/route/route_name.dart';
import '../../../../core/utils/validator.dart';
import '../../../../core/widgets/elvated_button.dart';
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

  void _onLoginPressed() {
    if (formKey.currentState!.validate()) {
      // UI only – no backend / bloc
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Validation Successful")),
      );

      Navigator.pushNamed(context, RouteNames.layout);

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image(
                  image: AssetImage(TImages.logoImage),
                  height: MediaQuery.sizeOf(context).height * 0.2,
                ),

                /// Email
                TCustomeFormField(
                  controller: emailController,
                  hint: "email",
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

                /// Password
                TCustomeFormField(
                  controller: passwordController,
                  hint: "password",
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
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RouteNames.forgetPassword,
                      );
                    },
                    child: Text(
                      "forgetPassword",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: TColors.secondaryTextColor),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                TElevatedButton(
                  onPressed:   _onLoginPressed,
               text:   "Sign In",
                  ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account ?",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RouteNames.register);
                      },
                      child: const Text("Sign Up"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
