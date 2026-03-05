import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/widgets/elvated_button.dart';
import '../manager/care_home_registration_bloc.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  final CareHomeRegistrationBloc bloc;
  final VoidCallback onAccepted;

  const TermsAndConditionsScreen({
    super.key,
    required this.bloc,
    required this.onAccepted,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Terms & Conditions'),
          leading: const BackButton(),
        ),
        body: BlocBuilder<CareHomeRegistrationBloc, CareHomeRegistrationState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Terms and Conditions',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: const Text(
                            'Welcome to ReLife Care Services.\n\n'
                            '1. ACCEPTANCE OF TERMS\n'
                            'By registering and using this platform, you agree to be bound by these Terms and Conditions.\n\n'
                            '2. SERVICE DESCRIPTION\n'
                            'ReLife provides a platform connecting Personal Support Workers (PSWs) with Care Homes and Individual clients seeking care services.\n\n'
                            '3. REGISTRATION AND ACCOUNT\n'
                            'You must provide accurate, current, and complete information during the registration process. You are responsible for maintaining the confidentiality of your account credentials.\n\n'
                            '4. CARE HOME OBLIGATIONS\n'
                            'Care Homes agree to: (a) Maintain valid business licenses and insurance; (b) Provide accurate information about their facilities; (c) Comply with all applicable health and safety regulations; (d) Pay PSWs in accordance with agreed-upon rates.\n\n'
                            '5. PSW OBLIGATIONS\n'
                            'PSWs agree to: (a) Maintain valid certifications and licenses; (b) Provide services in a professional manner; (c) Comply with all applicable regulations and standards of care.\n\n'
                            '6. PRIVACY POLICY\n'
                            'Your personal information will be collected, used, and stored in accordance with our Privacy Policy. We are committed to protecting your data.\n\n'
                            '7. LIABILITY\n'
                            'ReLife acts as a platform connector and is not liable for the quality of care services provided. Both Care Homes and PSWs maintain their independent obligations.\n\n'
                            '8. TERMINATION\n'
                            'Either party may terminate their account at any time. ReLife reserves the right to suspend or terminate accounts that violate these terms.\n\n'
                            '9. GOVERNING LAW\n'
                            'These terms shall be governed by and construed in accordance with applicable provincial and federal laws.',
                            style: TextStyle(fontSize: 14, height: 1.6),
                          ),
                        ),
                        const SizedBox(height: 20),
                        CheckboxListTile(
                          value: state.isTermsAccepted,
                          onChanged: (value) {
                            context.read<CareHomeRegistrationBloc>().add(
                              AcceptTermsEvent(value ?? false),
                            );
                          },
                          title: const Text(
                            'I have read and agree to the Terms and Conditions',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: TColors.primary,
                          contentPadding: EdgeInsets.zero,
                        ),
                        if (state.error != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              state.error!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 13,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: TElevatedButton(
                      text: 'Continue',
                      onPressed: state.isTermsAccepted
                          ? () {
                              context.read<CareHomeRegistrationBloc>().add(
                                NextRegistrationStepEvent(),
                              );
                              onAccepted();
                            }
                          : null,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
