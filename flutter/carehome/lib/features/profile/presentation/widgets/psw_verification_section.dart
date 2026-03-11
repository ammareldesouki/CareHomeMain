import 'package:flutter/material.dart';

import '../../../../../core/constants/colors.dart';
import '../../domain/entities/psw_profile_entity.dart';
import 'psw_document_item_card.dart';

class PswVerificationSection extends StatelessWidget {
  final PswProfileEntity profile;
  final Function(String filePath, String documentType)? onUploadDocument;

  const PswVerificationSection({
    super.key,
    required this.profile,
    this.onUploadDocument,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: TColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.verified_user,
                    color: TColors.primary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Verification Documents',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const Spacer(),
                _buildVerificationBadge(),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                _buildVerificationStats(),
                const SizedBox(height: 14),
                PswDocumentItemCard(
                  title: 'Proof of Identity',
                  documentType: 'ProofIdentity',
                  document: profile.proofIdentityFile,
                  onUpload: onUploadDocument,
                  onView: profile.proofIdentityFile != null
                      ? () => _viewDocument(
                          context,
                          profile.proofIdentityFile!.fullUrl,
                        )
                      : null,
                ),
                PswDocumentItemCard(
                  title: 'Insurance',
                  documentType: 'Insurance',
                  document: profile.insuranceFile,
                  onUpload: onUploadDocument,
                  onView: profile.insuranceFile != null
                      ? () => _viewDocument(
                          context,
                          profile.insuranceFile!.fullUrl,
                        )
                      : null,
                ),
                PswDocumentItemCard(
                  title: 'PSW Certificate',
                  documentType: 'PswCertificate',
                  document: profile.pswCertificateFile,
                  onUpload: onUploadDocument,
                  onView: profile.pswCertificateFile != null
                      ? () => _viewDocument(
                          context,
                          profile.pswCertificateFile!.fullUrl,
                        )
                      : null,
                ),
                PswDocumentItemCard(
                  title: 'CV / Resume',
                  documentType: 'CV',
                  document: profile.cvFile,
                  onUpload: onUploadDocument,
                  onView: profile.cvFile != null
                      ? () => _viewDocument(context, profile.cvFile!.fullUrl)
                      : null,
                ),
                PswDocumentItemCard(
                  title: 'Immunization Record',
                  documentType: 'ImmunizationRecord',
                  document: profile.immunizationRecordFile,
                  onUpload: onUploadDocument,
                  onView: profile.immunizationRecordFile != null
                      ? () => _viewDocument(
                          context,
                          profile.immunizationRecordFile!.fullUrl,
                        )
                      : null,
                ),
                PswDocumentItemCard(
                  title: 'Criminal Record',
                  documentType: 'CriminalRecord',
                  document: profile.criminalRecordFile,
                  onUpload: onUploadDocument,
                  onView: profile.criminalRecordFile != null
                      ? () => _viewDocument(
                          context,
                          profile.criminalRecordFile!.fullUrl,
                        )
                      : null,
                ),
                PswDocumentItemCard(
                  title: 'First Aid / CPR Card',
                  documentType: 'FirstAidCPR',
                  isOptional: true,
                  document: profile.firstAidOrCPRFile,
                  onUpload: onUploadDocument,
                  onView: profile.firstAidOrCPRFile != null
                      ? () => _viewDocument(
                          context,
                          profile.firstAidOrCPRFile!.fullUrl,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationBadge() {
    if (profile.isVerified) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.verified, size: 12, color: Colors.green.shade700),
            const SizedBox(width: 4),
            Text(
              'Verified',
              style: TextStyle(
                fontSize: 11,
                color: Colors.green.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.schedule, size: 12, color: Colors.orange.shade700),
          const SizedBox(width: 4),
          Text(
            'Pending',
            style: TextStyle(
              fontSize: 11,
              color: Colors.orange.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationStats() {
    final docs = [
      profile.proofIdentityFile,
      profile.insuranceFile,
      profile.pswCertificateFile,
      profile.cvFile,
      profile.immunizationRecordFile,
      profile.criminalRecordFile,
    ];
    final uploaded = docs.where((d) => d != null).length;
    final total = docs.length;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem(
            '$uploaded/$total',
            'Documents\nUploaded',
            uploaded == total ? Colors.green : Colors.orange,
          ),
          Container(width: 1, height: 36, color: Colors.grey.shade200),
          _statItem(
            profile.isVerified ? 'Yes' : 'No',
            'Profile\nVerified',
            profile.isVerified ? Colors.green : Colors.grey,
          ),
          Container(width: 1, height: 36, color: Colors.grey.shade200),
          _statItem(
            profile.workStatus ? 'Active' : 'Inactive',
            'Work\nStatus',
            profile.workStatus ? Colors.green : Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label, Color valueColor) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: valueColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  void _viewDocument(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Document',
                    style: TextStyle(fontWeight: FontWeight.bold),
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
              child: Column(
                children: [
                  Image.network(
                    url,
                    height: 300,
                    fit: BoxFit.contain,
                    loadingBuilder: (_, child, progress) => progress == null
                        ? child
                        : const SizedBox(
                            height: 200,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                    errorBuilder: (_, __, ___) => const Padding(
                      padding: EdgeInsets.all(40),
                      child: Column(
                        children: [
                          Icon(
                            Icons.broken_image,
                            size: 48,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Unable to load image',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
