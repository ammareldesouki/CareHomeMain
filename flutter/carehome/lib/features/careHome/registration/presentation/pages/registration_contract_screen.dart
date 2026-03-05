import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/widgets/elvated_button.dart';
import '../manager/care_home_registration_bloc.dart';

class RegistrationContractScreen extends StatefulWidget {
  final CareHomeRegistrationBloc bloc;
  final VoidCallback onSigned;

  const RegistrationContractScreen({
    super.key,
    required this.bloc,
    required this.onSigned,
  });

  @override
  State<RegistrationContractScreen> createState() =>
      _RegistrationContractScreenState();
}

class _RegistrationContractScreenState
    extends State<RegistrationContractScreen> {
  final TextEditingController _signatureController = TextEditingController();
  bool _hasAgreed = false;

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.bloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Registration Contract'),
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
                          'Service Agreement',
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
                            'RELIFE CARE SERVICES AGREEMENT\n\n'
                            'This Service Agreement ("Agreement") is entered into between ReLife Care Services ("Platform") and the undersigned party ("Client").\n\n'
                            '1. SCOPE OF SERVICES\n'
                            'The Platform agrees to provide access to qualified Personal Support Workers (PSWs) for care services as requested by the Client.\n\n'
                            '2. PAYMENT TERMS\n'
                            'The Client agrees to pay for all services rendered at the agreed-upon rates. Payment shall be processed through the Platform\'s payment system.\n\n'
                            '3. RESPONSIBILITIES\n'
                            'a) The Client shall provide a safe working environment for PSWs.\n'
                            'b) The Client shall communicate any specific care requirements in advance.\n'
                            'c) The Platform shall ensure all PSWs are properly verified and certified.\n\n'
                            '4. CANCELLATION POLICY\n'
                            'Cancellations must be made at least 24 hours in advance. Late cancellations may incur a fee.\n\n'
                            '5. CONFIDENTIALITY\n'
                            'Both parties agree to maintain the confidentiality of all personal and medical information.\n\n'
                            '6. DURATION\n'
                            'This agreement remains in effect until terminated by either party with 30 days written notice.\n\n'
                            '7. DISPUTE RESOLUTION\n'
                            'Any disputes arising from this agreement shall be resolved through mediation before pursuing legal action.',
                            style: TextStyle(fontSize: 14, height: 1.6),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Digital Signature',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Type your full legal name below to sign this contract',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        const SizedBox(height: 12),

                        const SizedBox(height: 16),
                        CheckboxListTile(
                          value: _hasAgreed,
                          onChanged: (value) {
                            setState(() {
                              _hasAgreed = value ?? false;
                            });
                          },
                          title: const Text(
                            'I agree to the terms of this contract and confirm that the information provided is accurate',
                            style: TextStyle(fontSize: 13),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: TColors.primary,
                          contentPadding: EdgeInsets.zero,
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
                      text: 'Sign & Continue',
                      onPressed: _hasAgreed
                          ? () {
                              context.read<CareHomeRegistrationBloc>().add(
                                SignContractEvent(),
                              );
                              widget.onSigned();
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
