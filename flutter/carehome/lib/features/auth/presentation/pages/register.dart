import 'package:flutter/material.dart';

import '../../../../core/constants/image_strings.dart';
import '../../../../core/utils/validator.dart';
import '../../../../core/widgets/elvated_button.dart';
import '../widgets/custome_form_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String selectedRole = 'care_home'; // default value

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Form(
            key: formKey,
            child:   ListView(
                children: [

                  Image(
                    image: AssetImage(TImages.logoImage),
                    height: MediaQuery.sizeOf(context).height * 0.2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Radio<String>(
                            value: 'care_home',
                            groupValue: selectedRole,
                            onChanged: (value) {
                              setState(() {
                                selectedRole = value!;
                              });
                            },
                          ),
                          const Text('Care Home'),
                        ],
                      ),

                      const SizedBox(width: 20),

                      Row(
                        children: [
                          Radio<String>(
                            value: 'psw',
                            groupValue: selectedRole,
                            onChanged: (value) {
                              setState(() {
                                selectedRole = value!;
                              });
                            },
                          ),
                          const Text('PSW'),
                        ],
                      ),
                    ],
                  ),

                  TCustomeFormField(
                    hint: 'First Name',
                    validation: Validator.validateFullName,
                    hintTextStyle: TextStyle(color: Colors.black, fontSize: 16.0),
                    prefixIcon: Icon(Icons.person, color: Colors.grey),
                  ),

                  TCustomeFormField(
                    hint: 'Phone Number',
                    validation: Validator.validatePhoneNumber,
                    hintTextStyle: TextStyle(color: Colors.black, fontSize: 16.0),
                    prefixIcon: Icon(Icons.phone, color: Colors.grey),
                  ),

                  TCustomeFormField(
                    hint: 'Email',
                    validation: Validator.validateEmail,
                    hintTextStyle: TextStyle(color: Colors.black, fontSize: 16.0),
                    prefixIcon: Icon(Icons.email_outlined, color: Colors.grey),
                  ),

                  TCustomeFormField(
                    hint: 'Password',
                    isObscured: true,
                    validation: Validator.validatePassword,
                    hintTextStyle: TextStyle(color: Colors.black, fontSize: 16.0),
                    prefixIcon: Icon(Icons.lock_outline, color: Colors.grey),
                  ),

                  TElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        print(selectedRole); // 👈 Care Home or PSW
                      }
                    },
                    text: "Sign Up",
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
              )

          ),
        ),
      ),
    );
  }
}
