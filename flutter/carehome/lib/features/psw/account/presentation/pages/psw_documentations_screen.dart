import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../core/utils/image_picker_helper.dart';

import '../../../../../../core/constants/colors.dart';
import '../../../../profile/domain/entities/document_file_entity.dart';
import '../../../../profile/domain/entities/psw_profile_entity.dart';
import '../../../../profile/presentation/manager/profile_bloc.dart';

class PswDocumentationsScreen extends StatelessWidget {
  const PswDocumentationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc(role: 'PSW')..add(LoadProfileEvent()),
      child: const _PswDocumentationsBody(),
    );
  }
}

class _PswDocumentationsBody extends StatelessWidget {
  const _PswDocumentationsBody();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileDocumentUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Document updated successfully'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
        if (state is ProfileUpdateError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red.shade400,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is ProfileLoading) {
          return Scaffold(
            appBar: _buildAppBar(context, null),
            backgroundColor: Colors.grey.shade50,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ProfileError) {
          return Scaffold(
            appBar: _buildAppBar(context, null),
            backgroundColor: Colors.grey.shade50,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 56,
                    color: Colors.red.shade300,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () =>
                        context.read<ProfileBloc>().add(LoadProfileEvent()),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final PswProfileEntity? profile = state is PswProfileLoaded
            ? state.profile
            : null;

        if (profile == null) {
          return Scaffold(
            appBar: _buildAppBar(context, null),
            backgroundColor: Colors.grey.shade50,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final docs = [
          profile.proofIdentityFile,
          profile.insuranceFile,
          profile.pswCertificateFile,
          profile.cvFile,
          profile.immunizationRecordFile,
          profile.criminalRecordFile,
        ];
        final uploadedCount = docs.where((d) => d != null).length;

        return Scaffold(
          appBar: _buildAppBar(context, profile),
          backgroundColor: Colors.grey.shade50,
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header Card ────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        TColors.darkBlue,
                        TColors.primary.withOpacity(0.75),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.verified_user,
                        color: Colors.white,
                        size: 36,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Document Verification',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              profile.isVerified
                                  ? 'Your profile is verified'
                                  : 'Upload all documents to complete verification',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── Progress ───────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Upload Progress',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: profile.isVerified
                                  ? Colors.green.shade50
                                  : Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  profile.isVerified
                                      ? Icons.verified
                                      : Icons.schedule,
                                  size: 12,
                                  color: profile.isVerified
                                      ? Colors.green.shade700
                                      : Colors.orange.shade700,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  profile.isVerified ? 'Verified' : 'Pending',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: profile.isVerified
                                        ? Colors.green.shade700
                                        : Colors.orange.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: uploadedCount / 6,
                          minHeight: 8,
                          backgroundColor: Colors.grey.shade200,
                          color: uploadedCount == 6
                              ? Colors.green
                              : TColors.primary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$uploadedCount / 6 required documents uploaded',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ── Section 01 : Proof of Identity ─────────────────────
                _sectionHeader(
                  '01',
                  'Proof of Identity',
                  'Government-issued ID document',
                ),
                const SizedBox(height: 10),
                _DocTile(
                  title: 'Proof of Identity',
                  subtitle: profile.proofIdentityType.isNotEmpty
                      ? profile.proofIdentityType
                      : 'National ID / Passport / Driving License',
                  documentType: 'ProofIdentity',
                  document: profile.proofIdentityFile,
                  onUpload: (path) => context.read<ProfileBloc>().add(
                    UpdatePswDocumentEvent(
                      documentType: 'ProofIdentity',
                      filePath: path,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Section 02 : Work Status & Insurance ───────────────
                _sectionHeader(
                  '02',
                  'Work Status & Insurance',
                  'Work authorization and insurance documents',
                ),
                const SizedBox(height: 10),
                _DocTile(
                  title: 'Insurance Certificate',
                  subtitle: 'Liability / professional insurance',
                  documentType: 'Insurance',
                  document: profile.insuranceFile,
                  onUpload: (path) => context.read<ProfileBloc>().add(
                    UpdatePswDocumentEvent(
                      documentType: 'Insurance',
                      filePath: path,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Section 03 : Certification & CV ───────────────────
                _sectionHeader(
                  '03',
                  'Certification & CV',
                  'PSW certificate and resume',
                ),
                const SizedBox(height: 10),
                _DocTile(
                  title: 'PSW Certificate',
                  subtitle: 'Personal Support Worker certification',
                  documentType: 'PswCertificate',
                  document: profile.pswCertificateFile,
                  onUpload: (path) => context.read<ProfileBloc>().add(
                    UpdatePswDocumentEvent(
                      documentType: 'PswCertificate',
                      filePath: path,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _DocTile(
                  title: 'CV / Resume',
                  subtitle: 'Your curriculum vitae',
                  documentType: 'CV',
                  document: profile.cvFile,
                  onUpload: (path) => context.read<ProfileBloc>().add(
                    UpdatePswDocumentEvent(documentType: 'CV', filePath: path),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Section 04 : Health & Legal ────────────────────────
                _sectionHeader(
                  '04',
                  'Health & Legal Documents',
                  'Immunization and criminal record checks',
                ),
                const SizedBox(height: 10),
                _DocTile(
                  title: 'Immunization Record',
                  subtitle: 'Up-to-date vaccination records',
                  documentType: 'ImmunizationRecord',
                  document: profile.immunizationRecordFile,
                  onUpload: (path) => context.read<ProfileBloc>().add(
                    UpdatePswDocumentEvent(
                      documentType: 'ImmunizationRecord',
                      filePath: path,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _DocTile(
                  title: 'Criminal Record Check',
                  subtitle: 'Police clearance certificate',
                  documentType: 'CriminalRecord',
                  document: profile.criminalRecordFile,
                  onUpload: (path) => context.read<ProfileBloc>().add(
                    UpdatePswDocumentEvent(
                      documentType: 'CriminalRecord',
                      filePath: path,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Section 05 : Optional ──────────────────────────────
                _sectionHeader(
                  '05',
                  'Additional Documents',
                  'Optional — strengthens your profile',
                ),
                const SizedBox(height: 10),
                _DocTile(
                  title: 'First Aid / CPR Card',
                  subtitle: 'First Aid or CPR certification',
                  documentType: 'FirstAidCPR',
                  document: profile.firstAidOrCPRFile,
                  isOptional: true,
                  onUpload: (path) => context.read<ProfileBloc>().add(
                    UpdatePswDocumentEvent(
                      documentType: 'FirstAidCPR',
                      filePath: path,
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, PswProfileEntity? profile) {
    return AppBar(
      title: const Text('Documentations'),
      leading: const BackButton(),
      elevation: 0,
    );
  }

  Widget _sectionHeader(String step, String title, String subtitle) {
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
                  fontSize: 16,
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

// ── Document Tile ─────────────────────────────────────────────────────────────

class _DocTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final String documentType;
  final bool isOptional;
  final DocumentFileEntity? document;
  final Function(String filePath) onUpload;

  const _DocTile({
    required this.title,
    required this.subtitle,
    required this.documentType,
    this.isOptional = false,
    this.document,
    required this.onUpload,
  });

  @override
  State<_DocTile> createState() => _DocTileState();
}

class _DocTileState extends State<_DocTile> {
  bool _isUploading = false;

  bool get _hasDoc => widget.document != null;

  Future<void> _pick(ImageSource source) async {
    final path = await ImagePickerHelper.pick(context, source);
    if (path != null) {
      setState(() => _isUploading = true);
      await widget.onUpload(path);
      if (mounted) setState(() => _isUploading = false);
    }
  }

  Future<void> _pickFile() async {
    final path = await ImagePickerHelper.pickFile(context);
    if (path != null) {
      setState(() => _isUploading = true);
      await widget.onUpload(path);
      if (mounted) setState(() => _isUploading = false);
    }
  }

  void _showPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                _hasDoc ? 'Update ${widget.title}' : 'Upload ${widget.title}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pick(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pick(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.insert_drive_file_outlined),
              title: const Text('Choose File (PDF, DOC)'),
              onTap: () {
                Navigator.pop(context);
                _pickFile();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _viewDocument() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 8, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Image.network(
                widget.document!.fullUrl,
                height: 300,
                fit: BoxFit.contain,
                loadingBuilder: (_, child, progress) => progress == null
                    ? child
                    : const SizedBox(
                        height: 200,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                errorBuilder: (_, __, ___) => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      Icon(Icons.broken_image, size: 48, color: Colors.grey),
                      SizedBox(height: 8),
                      Text(
                        'Unable to load image',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _hasDoc ? Colors.green.shade200 : Colors.grey.shade200,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            // Icon block
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: _hasDoc
                    ? Colors.green.withOpacity(0.1)
                    : TColors.darkBlue.withOpacity(0.07),
                borderRadius: BorderRadius.circular(10),
              ),
              child: _isUploading
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(
                      _hasDoc ? Icons.description : Icons.upload_file,
                      color: _hasDoc ? Colors.green : TColors.darkBlue,
                      size: 22,
                    ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      if (widget.isOptional)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Optional',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _hasDoc ? widget.document!.fileName : widget.subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: _hasDoc
                          ? Colors.green.shade600
                          : Colors.grey.shade500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // View button (only if uploaded)
            if (_hasDoc)
              InkWell(
                onTap: _viewDocument,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: TColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.visibility,
                    size: 16,
                    color: TColors.primary,
                  ),
                ),
              ),
            const SizedBox(width: 6),
            // Upload / Update button
            InkWell(
              onTap: _isUploading ? null : _showPicker,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: _hasDoc
                      ? Colors.orange.withOpacity(0.1)
                      : TColors.darkBlue.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _hasDoc ? Icons.edit : Icons.upload,
                  size: 16,
                  color: _hasDoc ? Colors.orange : TColors.darkBlue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
