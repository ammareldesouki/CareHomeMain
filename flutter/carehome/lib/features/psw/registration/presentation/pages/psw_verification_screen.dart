import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/widgets/elvated_button.dart';
import '../../../../layout/bottom_navegation_bar.dart';
import '../../domain/entities/psw_document.dart';
import '../manager/pswrigster_bloc.dart';
import '../widgets/document_upload_tile.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PSW Verification Screen  (single-page form — all sections visible at once)
// ─────────────────────────────────────────────────────────────────────────────

class PswVerificationScreen extends StatelessWidget {
  const PswVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PswRegistrationBloc(),
      child: const _PswVerificationBody(),
    );
  }
}

class _PswVerificationBody extends StatelessWidget {
  const _PswVerificationBody();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PswRegistrationBloc, PswRegistrationState>(
      listener: (context, state) {
        if (state.isSubmitted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => const CBottomNavigationBar(role: 'PSW'),
            ),
            (route) => false,
          );
        }
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!),
              backgroundColor: Colors.red.shade400,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            title: const Text('PSW Verification'),
            leading: const BackButton(),
            actions: [
              InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const CBottomNavigationBar(role: 'PSW'),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Skip',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium!.copyWith(color: TColors.darkBlue),
                  ),
                ),
              ),
            ],
            elevation: 0,
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── header card ──────────────────────────────────
                      _HeaderCard(),
                      const SizedBox(height: 20),

                      // ── Section 1 : Proof of Identity ─────────────────
                      const _SectionHeader(
                        step: '01',
                        title: 'Proof of Identity',
                        subtitle:
                            'Select your ID type and upload clear photos of both sides',
                      ),
                      const SizedBox(height: 12),
                      _IdTypeDropdown(),
                      const SizedBox(height: 12),
                      _IdFrontBack(),
                      const _SupportText(
                        'Supports: JPG, PNG (Max 5 MB per file)',
                      ),

                      const SizedBox(height: 20),

                      // ── Section 2 : Work Status & Insurance ───────────
                      const _SectionHeader(
                        step: '02',
                        title: 'Work Status & Insurance',
                        subtitle:
                            'Upload your work authorization and insurance documents',
                      ),
                      const SizedBox(height: 12),
                      const _SimpleUploadTile(
                        docType: PswDocumentType.workStatus,
                        subtitle: 'Upload work authorization document',
                      ),
                      const _SimpleUploadTile(
                        docType: PswDocumentType.insurance,
                        subtitle: 'Upload insurance certificate',
                      ),
                      const _SupportText('Supports: JPG, PNG, PDF (Max 10 MB)'),

                      const SizedBox(height: 20),

                      // ── Section 3 : Certification & CV ────────────────
                      const _SectionHeader(
                        step: '03',
                        title: 'Certification & CV',
                        subtitle: 'Upload your PSW certificate and resume',
                      ),
                      const SizedBox(height: 12),
                      const _SimpleUploadTile(
                        docType: PswDocumentType.pswCertificate,
                        subtitle: 'Upload PSW certification document',
                      ),
                      const _SimpleUploadTile(
                        docType: PswDocumentType.cv,
                        subtitle: 'Upload your CV / Resume',
                      ),
                      const _SupportText('Supports: JPG, PNG, PDF (Max 10 MB)'),

                      const SizedBox(height: 20),

                      // ── Section 4 : Health & Legal ────────────────────
                      const _SectionHeader(
                        step: '04',
                        title: 'Health & Legal Documents',
                        subtitle:
                            'Upload your immunization and criminal record documents',
                      ),
                      const SizedBox(height: 12),
                      const _SimpleUploadTile(
                        docType: PswDocumentType.immunizationRecord,
                        subtitle: 'Upload immunization records',
                      ),
                      const _SimpleUploadTile(
                        docType: PswDocumentType.criminalRecord,
                        subtitle: 'Upload criminal record check',
                      ),
                      const _SupportText('Supports: JPG, PNG, PDF (Max 10 MB)'),

                      const SizedBox(height: 20),

                      // ── Section 5 : Optional ──────────────────────────
                      const _SectionHeader(
                        step: '05',
                        title: 'Additional Documents',
                        subtitle:
                            'Optional documents to strengthen your profile',
                      ),
                      const SizedBox(height: 12),
                      const _SimpleUploadTile(
                        docType: PswDocumentType.firstAidCpr,
                        subtitle: 'Upload First Aid / CPR card',
                        isOptional: true,
                      ),

                      const SizedBox(height: 20),

                      // ── Summary ───────────────────────────────────────
                      _UploadSummary(),
                    ],
                  ),
                ),
              ),

              // ── Submit button ────────────────────────────────────────
              _SubmitBar(),
            ],
          ),
        );
      },
    );
  }
}

// ─── header card ─────────────────────────────────────────────────────────────

class _HeaderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [TColors.darkBlue, TColors.primary.withOpacity(0.75)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_user, color: Colors.white, size: 36),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Document Verification',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Upload all required documents to complete your PSW profile.',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── section header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.step,
    required this.title,
    required this.subtitle,
  });

  final String step;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: TColors.darkBlue,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            step,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── support text ─────────────────────────────────────────────────────────────

class _SupportText extends StatelessWidget {
  const _SupportText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 2),
      child: Text(
        text,
        style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
      ),
    );
  }
}

// ─── ID type dropdown ─────────────────────────────────────────────────────────

class _IdTypeDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PswRegistrationBloc, PswRegistrationState>(
      builder: (context, state) {
        return DropdownButtonFormField<IdType>(
          value: state.selectedIdType,
          decoration: InputDecoration(
            labelText: 'ID Type',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          items: IdType.values
              .map((t) => DropdownMenuItem(value: t, child: Text(t.label)))
              .toList(),
          onChanged: (v) {
            if (v != null) {
              context.read<PswRegistrationBloc>().add(SelectIdTypeEvent(v));
            }
          },
        );
      },
    );
  }
}

// ─── ID front + back tiles ────────────────────────────────────────────────────

class _IdFrontBack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PswRegistrationBloc, PswRegistrationState>(
      builder: (context, state) {
        final isPassport = state.selectedIdType == IdType.passport;

        return Column(
          children: [
            // ── front (always shown) ──────────────────────────────────
            DocumentUploadTile(
              title: isPassport
                  ? 'Passport Photo Page'
                  : 'Front of ${state.selectedIdType.label}',
              subtitle: isPassport
                  ? 'Upload the photo / bio-data page'
                  : 'Upload front side',
              filePath: state.getDocumentPath(
                PswDocumentType.proofOfId,
                isFront: true,
              ),
              onFileSelected: (path) {
                context.read<PswRegistrationBloc>().add(
                  UploadDocumentEvent(
                    documentType: PswDocumentType.proofOfId,
                    filePath: path,
                    isFront: true,
                  ),
                );
              },
              onRemove: () {
                context.read<PswRegistrationBloc>().add(
                  RemoveDocumentEvent(
                    documentType: PswDocumentType.proofOfId,
                    isFront: true,
                  ),
                );
              },
            ),

            // ── back (hidden for passport) ────────────────────────────
            if (!isPassport)
              DocumentUploadTile(
                title: 'Back of ${state.selectedIdType.label}',
                subtitle: 'Upload back side',
                filePath: state.getDocumentPath(
                  PswDocumentType.proofOfId,
                  isFront: false,
                ),
                onFileSelected: (path) {
                  context.read<PswRegistrationBloc>().add(
                    UploadDocumentEvent(
                      documentType: PswDocumentType.proofOfId,
                      filePath: path,
                      isFront: false,
                    ),
                  );
                },
                onRemove: () {
                  context.read<PswRegistrationBloc>().add(
                    RemoveDocumentEvent(
                      documentType: PswDocumentType.proofOfId,
                      isFront: false,
                    ),
                  );
                },
              ),

            // ── passport hint ─────────────────────────────────────────
            if (isPassport)
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 2),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 14,
                      color: Colors.blue.shade400,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Passport requires one page only (bio-data page)',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.blue.shade400,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

// ─── simple upload tile wrapper ───────────────────────────────────────────────

class _SimpleUploadTile extends StatelessWidget {
  const _SimpleUploadTile({
    required this.docType,
    required this.subtitle,
    this.isOptional = false,
  });

  final PswDocumentType docType;
  final String subtitle;
  final bool isOptional;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PswRegistrationBloc, PswRegistrationState>(
      builder: (context, state) {
        return DocumentUploadTile(
          title: docType.label,
          subtitle: subtitle,
          isOptional: isOptional,
          filePath: state.getDocumentPath(docType),
          onFileSelected: (path) {
            context.read<PswRegistrationBloc>().add(
              UploadDocumentEvent(documentType: docType, filePath: path),
            );
          },
          onRemove: () {
            context.read<PswRegistrationBloc>().add(
              RemoveDocumentEvent(documentType: docType),
            );
          },
        );
      },
    );
  }
}

// ─── upload summary ───────────────────────────────────────────────────────────

class _UploadSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PswRegistrationBloc, PswRegistrationState>(
      builder: (context, state) {
        final required = [
          PswDocumentType.proofOfId,
          PswDocumentType.workStatus,
          PswDocumentType.insurance,
          PswDocumentType.pswCertificate,
          PswDocumentType.cv,
          PswDocumentType.immunizationRecord,
          PswDocumentType.criminalRecord,
        ];
        final isPassport = state.selectedIdType == IdType.passport;
        final uploaded = required.where((d) {
          if (d == PswDocumentType.proofOfId) {
            return isPassport
                ? state.isDocumentUploaded(d, isFront: true)
                : state.isDocumentUploaded(d, isFront: true) &&
                      state.isDocumentUploaded(d, isFront: false);
          }
          return state.isDocumentUploaded(d);
        }).length;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Upload Summary',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: uploaded / required.length,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade200,
                  color: uploaded == required.length
                      ? Colors.green
                      : TColors.primary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '$uploaded / ${required.length} required documents uploaded',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 12),
              ...required.map((doc) {
                final done = doc == PswDocumentType.proofOfId
                    ? (isPassport
                          ? state.isDocumentUploaded(doc, isFront: true)
                          : state.isDocumentUploaded(doc, isFront: true) &&
                                state.isDocumentUploaded(doc, isFront: false))
                    : state.isDocumentUploaded(doc);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(
                        done ? Icons.check_circle : Icons.cancel,
                        color: done ? Colors.green : Colors.red,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Text(doc.label, style: const TextStyle(fontSize: 13)),
                    ],
                  ),
                );
              }),
              // optional
              Builder(
                builder: (_) {
                  final optUploaded = state.isDocumentUploaded(
                    PswDocumentType.firstAidCpr,
                  );
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(
                          optUploaded
                              ? Icons.check_circle
                              : Icons.remove_circle,
                          color: optUploaded ? Colors.green : Colors.orange,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'First Aid / CPR Card (Optional)',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── submit bar ───────────────────────────────────────────────────────────────

class _SubmitBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PswRegistrationBloc, PswRegistrationState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.12),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              width: double.infinity,

              child: TElevatedButton(
                text: state.isLoading ? 'Submitting…' : 'Submit Documents',

                onPressed: state.isLoading
                    ? null
                    : () => context.read<PswRegistrationBloc>().add(
                        SubmitDocumentsEvent(),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
