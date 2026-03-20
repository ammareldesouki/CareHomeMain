import 'package:carehome/core/constants/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/admin_psw_verification_entity.dart';
import '../../domain/entities/psw_profile_entity.dart';
import '../manager/admin_bloc.dart';

class AdminPswVerificationDetailScreen extends StatefulWidget {
  final AdminPswVerificationEntity item;

  const AdminPswVerificationDetailScreen({super.key, required this.item});

  @override
  State<AdminPswVerificationDetailScreen> createState() =>
      _AdminPswVerificationDetailScreenState();
}

class _AdminPswVerificationDetailScreenState
    extends State<AdminPswVerificationDetailScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminBloc>().add(
          FetchPswProfileEvent("33117571-e6cc-4e9b-18dd-08de83d79a7b"));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminBloc, AdminState>(
      listener: (context, state) {
        if (state is VerificationMutationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }

        if (state is VerificationMutationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: CustomScrollView(
          slivers: [

            /// APP BAR
            SliverAppBar(
              expandedHeight: 170,
              pinned: true,
              backgroundColor: const Color(0xFF1A73E8),
              foregroundColor: Colors.white,
              title: const Text('Verification Review'),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1A73E8), Color(0xFF0D47A1)],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 52, 20, 16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            child: Text(
                              widget.item.fullName.isNotEmpty
                                  ? widget.item.fullName[0].toUpperCase()
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
                                  widget.item.fullName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                                Text(
                                  widget.item.email,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                Row(
                                  children: [
                                    _StatusBadge(
                                      status: widget.item.verificationStatus,
                                    ),


                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            /// BODY
            SliverToBoxAdapter(
              child: BlocBuilder<AdminBloc, AdminState>(
                builder: (context, state) {
                  /// Loading profile
                  if (state is PswProfileLoading) {
                    return const Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  /// Profile
                  final profile = state is PswProfileLoaded
                      ? state.profile
                      : null;

                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// PERSONAL INFO
                        _SectionTitle('Personal Information'),
                        const SizedBox(height: 8),

                        _InfoCard(
                          children: [
                            _InfoRow(
                              icon: Icons.person_outline,
                              label: 'Full Name',
                              value: profile?.fullName ?? widget.item.fullName,
                            ),

                            _InfoRow(
                              icon: Icons.email_outlined,
                              label: 'Email',
                              value: profile?.email ?? widget.item.email,
                            ),

                            _InfoRow(
                              icon: Icons.phone_outlined,
                              label: 'Phone',
                              value:
                              profile?.phoneNumber ??
                                  widget.item.phoneNumber,
                            ),

                            if (profile?.gender != null)
                              _InfoRow(
                                icon: Icons.wc_outlined,
                                label: 'Gender',
                                value: profile!.gender,
                              ),

                            if (profile?.dateOfBirth != null)
                              _InfoRow(
                                icon: Icons.cake_outlined,
                                label: 'Date of Birth',
                                value: _formatDate(profile!.dateOfBirth),
                              ),

                            _InfoRow(
                              icon: Icons.badge_outlined,
                              label: 'Identity Type',
                              value:
                              profile?.proofIdentityType ??
                                  widget.item.proofIdentityType ??
                                  '—',
                            ),

                            _InfoRow(
                              icon: Icons.location_on_outlined,
                              label: 'Address',
                              value: profile?.address.state ?? '',
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        /// DOCUMENTS
                        _SectionTitle('Uploaded Documents'),
                        const SizedBox(height: 8),

                        if (profile == null)
                          const Center(child: Text("Loading documents..."))
                        else
                          _DocumentsFromProfile(profile: profile),

                        const SizedBox(height: 32),
                        if(widget.item.verificationStatus == "Pending")

                        /// ACTIONS
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    _showRejectDialog(
                                    context,
                                      widget.item.pswId,
                                      widget.item.fullName,
                                    );
                                  },
                                  icon: const Icon(Icons.close),
                                  label: const Text("Reject"),
                                ),
                              ),

                              const SizedBox(width: 16),

                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    context.read<AdminBloc>().add(
                                      ApproveVerificationEvent(
                                          widget.item.pswId),
                                    );
                                  },
                                  icon: const Icon(Icons.check),
                                  label: const Text("Approve"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                ),
                              ),
                            ],
                          ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Reject dialog
  void _showRejectDialog(BuildContext context, String pswId, String name) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Reject Verification"),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(hintText: "Reason..."),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),

          ElevatedButton(
            onPressed: () {
              context.read<AdminBloc>().add(
                RejectVerificationEvent(pswId: pswId, reason: controller.text),
              );

              Navigator.pop(ctx);
            },
            child: const Text("Reject"),
          ),
        ],
      ),
    );
  }

  String _formatDate(String raw) {
    try {
      return DateFormat('MMM dd, yyyy').format(DateTime.parse(raw));
    } catch (_) {
      return raw;
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});
  @override
  Widget build(BuildContext context) {
    Color bg, border, text;
    switch (status.toLowerCase()) {
      case 'approved':
        bg = Colors.green.shade400;
        border = Colors.green.shade400;
        text = Colors.white;
        break;
      case 'rejected':
        bg = Colors.red.shade400;
        border = Colors.red.shade400;
        text = Colors.white;
        break;
      default:
        bg = Colors.orange.shade400;
        border = Colors.orange.shade400;
        text = Colors.white;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
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
          fontWeight: FontWeight.w700,
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
        crossAxisAlignment: CrossAxisAlignment.start,
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

// ── Documents — from full profile ─────────────────────────────────────────────
class _DocumentsFromProfile extends StatelessWidget {
  final PswProfileEntity profile;

  const _DocumentsFromProfile({required this.profile});

  @override
  Widget build(BuildContext context) {
    final docs = [
      (
      'Proof of Identity',
      profile.proofIdentityFile,
      Icons.credit_card_outlined,
      ),
      ('Insurance', profile.insuranceFile, Icons.security_outlined),
      (
      'PSW Certificate',
      profile.pswCertificateFile,
      Icons.workspace_premium_outlined,
      ),
      ('CV / Resume', profile.cvFile, Icons.description_outlined),
      (
      'Immunization Record',
      profile.immunizationRecordFile,
      Icons.vaccines_outlined,
      ),
      ('Criminal Record', profile.criminalRecordFile, Icons.policy_outlined),
      (
      'First Aid / CPR',
      profile.firstAidOrCPRFile,
      Icons.health_and_safety_outlined,
      ),
    ];
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
        children: docs
            .asMap()
            .entries
            .map((entry) {
          final i = entry.key;
          final (label, file, icon) = entry.value;
          final hasFile = file != null;
          return Column(
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (hasFile ? Colors.green : Colors.grey).withOpacity(
                      0.1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: hasFile ? Colors.green.shade600 : Colors.grey,
                  ),
                ),
                title: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: hasFile
                    ? Text(
                  file.fileName,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
                    : null,
                trailing: hasFile
                    ? GestureDetector(
                  onTap: () =>
                      _showDocumentPreview(context, file.url, label),
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
                    : Container(
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
              ),
              if (i < docs.length - 1)
                Divider(height: 1, color: Colors.grey.shade100),
            ],
          );
        }).toList(),
      ),
    );
  }

  void _showDocumentPreview(BuildContext context, String url, String title) {
    final isPdf = url.toLowerCase().endsWith('.pdf');
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) =>
          GestureDetector(
            onTap: () => Navigator.pop(ctx),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black87,
              child: Center(
                child: isPdf
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.picture_as_pdf,
                      color: Colors.white70,
                      size: 64,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'PDF preview not available. Tap outside to close.',
                      style: TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  ],
                )
                    : InteractiveViewer(
                  child: Image.network(
                    "https://relief-app-file.s3.ca-central-1.amazonaws.com/psw/certificate/33117571-e6cc-4e9b-18dd-08de83d79a7b/486ac558-8f19-4c3a-b835-3866ddc32b80.jpg?X-Amz-Expires=900&X-Amz-Security-Token=IQoJb3JpZ2luX2VjECoaDGNhLWNlbnRyYWwtMSJIMEYCIQDpXZFEMOX8egucebOM0khN812u0%2BY7WFPyhNdoLqqUmQIhALz4BHBxMprL%2FLMPeVkTstSVrtcg1z6vJ9RM2nMbE4DiKs8FCPP%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEQABoMOTM4NTM2NDk5OTk1IgwPXAnJqVBExmmn3AgqowW0pTh3Bxe0YV52LxxQBopzPlc1ztj9x%2BnM9RQQpjUy%2BbomreYKRFrOvcATeN3RNXtjtlQCrrcQb9097K8tY9qeSKO5Fl%2F5XKss7Eu%2FFCDEDaDfmH6rCehNOqB8lqnSukGoIPLn3g%2FMeCbnFtnWu78HzQq141cIJI3aCKLXDpOvpGN%2FDBVErzq6i4BR%2FLxjIHrypZPSfC1u4e%2FH1dnsPLXg9ai2KXsfWPRE%2B4NzgAfegGV8XTo%2BuEb9LfK8el2Ci0eFkoKyUDc4ILoLkLzdkEBOLo64%2BlEi066M07f1emJyFXRBdgStZ%2FqhpaP9IfmtR5u%2F69Z0dZ0EIvGkJXJ1aFdkaQ5QfuIBp2LEc1mbEmyTqcEjCjTivilm3yjjR1S4amWjXkcP8inoM2I29bfkCI0CmBTQljYhoQRL0x6V2BWsiJOsI1Hz23dbc0Ecnpqo%2FkClePseXQSDI%2BZMCjBPl%2B1ccGmyEdyv2RtFl%2B0KThbuW2HUJ8%2F00mXQYyjlvZEQMWySEHjxyusKbhzu5Hgz5IaxebyruvMSVB2HQW8tPv2zxhkK3GgCWnIzscVFv2y5sNueX7S4pAyIsJ%2BkgMot3GYKgmIWA5Od3D3QJy2W%2Fdng%2BxdOY66XpQEzFB3By3asOHVX7prCeJPfoKaMusbEbjtYD5%2FPWWk8W9h%2F535zhe2OOWAqYBoUMVhc1cXO8i45I2U2ybdUWmTUmo8uLaRg4NWqnxn5KdlE5o8qFIagQzI3cyEWlyo%2B2Mn2eaxHSaruVfmAbD2T971boxPgDdIfiJWFAVu%2B7K3ndyU%2BRFuaugd9n5A1IBwh7cLoe%2FH0r9rBrdoSJhkPlqSdfpYmTC10TaRnnkJD%2FmOhdRRgsXhOB8%2F%2B4rnnyW56o07XilO0tfq3IS17rFAw0q%2FmzQY6sAFTo%2FR9nr1%2FqIDs310%2BP0%2FSfA668DV%2BhawtQImuanAP1zdbKHGE8nSVcKaeOshbRwL%2BrIeTRKwM02YG4VVxq9vGIGjK4fi%2FpW5hxKicbpkZV159j5TnG5RVNB9XbJ5twwmjfwcGIaRhzK2oY0UC%2FQHMajrwg3IQCrsb%2B92NcdA0w26LUOZIzdczCJh2k%2BPjzynuk4fFWud26x8Brh2epkDSbnbOxEYVo1%2FoCfF67YzFlQ%3D%3D&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=ASIA5VBJCPMNYR26SKED%2F20260317%2Fca-central-1%2Fs3%2Faws4_request&X-Amz-Date=20260317T183758Z&X-Amz-SignedHeaders=host&X-Amz-Signature=2cfce2cf4b10a4838509eeed0c4e1381552478e5265413d88b0ba390ac1e9618",
                    fit: BoxFit.contain,
                    loadingBuilder: (_, child, progress) =>
                    progress == null
                        ? child
                        : const CircularProgressIndicator(
                      color: Colors.white,
                    ),
                    errorBuilder: (_, __, ___) =>
                    const Icon(
                      Icons.error,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
              ),
            ),
          ),
    );
  }
}
