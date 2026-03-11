import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/admin_psw_verification_entity.dart';
import '../manager/admin_bloc.dart';

/// Full-screen detail view for a single PSW verification request.
/// The admin can review all uploaded documents and then Approve or Reject.
class AdminPswVerificationDetailScreen extends StatelessWidget {
  final AdminPswVerificationEntity item;

  const AdminPswVerificationDetailScreen({super.key, required this.item});

  // ── Base URL for file downloads ──────────────────────────────────────────
  // Adjust this to match your backend's file-serving endpoint.
  static const String _fileBaseUrl = 'http://3.99.158.214:5000/api/files/';

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminBloc, AdminState>(
      listener: (context, state) {
        if (state is VerificationMutationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
          Navigator.pop(context); // go back after action
        }
        if (state is VerificationMutationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red.shade400,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      },
      child: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          final isMutating = state is VerificationMutationLoading;

          return Scaffold(
            backgroundColor: Colors.grey.shade50,
            body: CustomScrollView(
              slivers: [
                // ── App Bar ──────────────────────────────────────────────
                SliverAppBar(
                  expandedHeight: 160,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF1A73E8), Color(0xFF0D47A1)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 48, 20, 16),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 32,
                                backgroundColor: Colors.white.withOpacity(0.2),
                                child: Text(
                                  item.fullName.isNotEmpty
                                      ? item.fullName[0].toUpperCase()
                                      : 'P',
                                  style: const TextStyle(
                                    fontSize: 26,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      item.fullName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      item.email,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    _StatusBadge(status: 'Pending'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  backgroundColor: const Color(0xFF1A73E8),
                  foregroundColor: Colors.white,
                  title: const Text(
                    'Verification Review',
                    style: TextStyle(fontSize: 16),
                  ),
                ),

                // ── Content ──────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Personal Info Card
                        _SectionTitle('Personal Information'),
                        const SizedBox(height: 8),
                        _InfoCard(
                          children: [
                            _InfoRow(
                              icon: Icons.person_outline,
                              label: 'Full Name',
                              value: item.fullName,
                            ),
                            _InfoRow(
                              icon: Icons.email_outlined,
                              label: 'Email',
                              value: item.email,
                            ),
                            _InfoRow(
                              icon: Icons.phone_outlined,
                              label: 'Phone',
                              value: item.phoneNumber.isNotEmpty
                                  ? item.phoneNumber
                                  : '—',
                            ),
                            _InfoRow(
                              icon: Icons.badge_outlined,
                              label: 'ID Type',
                              value: item.proofIdentityType.isNotEmpty
                                  ? item.proofIdentityType
                                  : '—',
                            ),
                            if (item.submittedAt.isNotEmpty)
                              _InfoRow(
                                icon: Icons.calendar_today_outlined,
                                label: 'Submitted',
                                value: _formatDate(item.submittedAt),
                              ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Documents Section
                        _SectionTitle('Uploaded Documents'),
                        const SizedBox(height: 8),
                        _DocumentsCard(
                          documents: [
                            _DocItem(
                              icon: Icons.credit_card_outlined,
                              label: 'Proof of Identity',
                              fileId: item.proofIdentityFileId,
                            ),
                            _DocItem(
                              icon: Icons.school_outlined,
                              label: 'PSW Certificate',
                              fileId: item.pswCertificateFileId,
                            ),
                            _DocItem(
                              icon: Icons.description_outlined,
                              label: 'CV / Resume',
                              fileId: item.cvFileId,
                            ),
                            _DocItem(
                              icon: Icons.medical_services_outlined,
                              label: 'Immunization Record',
                              fileId: item.immunizationRecordFileId,
                            ),
                            _DocItem(
                              icon: Icons.gavel_outlined,
                              label: 'Criminal Record',
                              fileId: item.criminalRecordFileId,
                            ),
                            _DocItem(
                              icon: Icons.favorite_border,
                              label: 'First Aid / CPR Certificate',
                              fileId: item.firstAidOrCprFileId,
                            ),
                          ],
                          baseUrl: _fileBaseUrl,
                        ),

                        const SizedBox(height: 28),

                        // ── Action Buttons ────────────────────────────────
                        if (isMutating)
                          const Center(child: CircularProgressIndicator())
                        else
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => _showRejectDialog(
                                    context,
                                    item.pswId,
                                    item.fullName,
                                  ),
                                  icon: const Icon(Icons.close, size: 18),
                                  label: const Text('Reject'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red,
                                    side: const BorderSide(color: Colors.red),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () =>
                                      context.read<AdminBloc>().add(
                                        ApproveVerificationEvent(item.pswId),
                                      ),
                                  icon: const Icon(
                                    Icons.verified_outlined,
                                    size: 18,
                                  ),
                                  label: const Text('Approve'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showRejectDialog(BuildContext context, String pswId, String name) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.cancel, color: Colors.red.shade600, size: 20),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Reject Verification',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rejecting verification for:',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Explain the reason for rejection...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF1A73E8)),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This reason will be visible to the PSW.',
              style: TextStyle(fontSize: 12, color: Colors.orange.shade700),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final reason = controller.text.trim();
              if (reason.isEmpty) return;
              Navigator.pop(ctx);
              context.read<AdminBloc>().add(
                RejectVerificationEvent(pswId: pswId, reason: reason),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      return DateFormat('MMM dd, yyyy').format(DateTime.parse(dateStr));
    } catch (_) {
      return dateStr;
    }
  }
}

// ── Documents Card ────────────────────────────────────────────────────────────

class _DocItem {
  final IconData icon;
  final String label;
  final String fileId;

  const _DocItem({
    required this.icon,
    required this.label,
    required this.fileId,
  });
}

class _DocumentsCard extends StatelessWidget {
  final List<_DocItem> documents;
  final String baseUrl;

  const _DocumentsCard({required this.documents, required this.baseUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: documents.map((doc) {
          final hasFile = doc.fileId.isNotEmpty;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: hasFile
                            ? const Color(0xFF1A73E8).withOpacity(0.08)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        doc.icon,
                        size: 18,
                        color: hasFile
                            ? const Color(0xFF1A73E8)
                            : Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        doc.label,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (hasFile)
                      GestureDetector(
                        onTap: () {
                          // final url = Uri.parse('$baseUrl${doc.fileId}');
                          // if (await canLaunchUrl(url)) {
                          //   await launchUrl(url,
                          //       mode: LaunchMode.externalApplication);
                          // }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A73E8).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.open_in_new,
                                size: 14,
                                color: Color(0xFF1A73E8),
                              ),
                              SizedBox(width: 4),
                              Text(
                                'View',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF1A73E8),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Not uploaded',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (doc != documents.last)
                Divider(height: 1, color: Colors.grey.shade100),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ── Shared Widgets ────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg, border, text;
    switch (status.toLowerCase()) {
      case 'verified':
      case 'approved':
        bg = Colors.green.shade50;
        border = Colors.green.shade200;
        text = Colors.green.shade700;
        break;
      case 'rejected':
        bg = Colors.red.shade50;
        border = Colors.red.shade200;
        text = Colors.red.shade700;
        break;
      default:
        bg = Colors.orange.shade50;
        border = Colors.orange.shade200;
        text = Colors.orange.shade700;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: text,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
  );
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;

  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children:
            children
                .expand(
                  (w) => [w, Divider(height: 1, color: Colors.grey.shade100)],
                )
                .toList()
              ..removeLast(),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: const Color(0xFF1A73E8).withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: const Color(0xFF1A73E8)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
