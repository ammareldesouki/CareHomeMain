import 'package:flutter/material.dart';

import '../../../../core/constants/image_strings.dart';
import '../../../../core/utils/validator.dart';
import '../widgets/custome_form_field.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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

                TCustomeFormField(
                  hint: 'Email',
                  validation: Validator.validateEmail,
                  hintTextStyle: TextStyle(color: Colors.black, fontSize: 16.0),

                  prefixIcon: Icon(Icons.email_outlined, color: Colors.grey),
                ),

                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {}
                  },
                  child: Text("Send Reset Link"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
