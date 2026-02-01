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
        create: (context) => AuthBloc(),

        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSignInLoading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (state is AuthSignInSuccess) {
              Navigator.pop(context); // close loading

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      CBottomNavigationBar(role: state.user.role),
                ),
              );
            }

            if (state is AuthSignInError) {
              Navigator.pop(context); // close loading

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                ),
              );
            }
          },
          builder: (context, state) {
            return SafeArea(
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
                      "Forget Password",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: TColors.secondaryTextColor),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                TElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      var data = SignInRequest(
                          email: emailController.text,
                          password: passwordController.text);
                      context.read<AuthBloc>().add(SignInEvent(data));
                    }

                  },
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
            );
          },
        ),
      ),
    );
  }
}
