import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/admin_psw_verification_entity.dart';
import '../manager/admin_bloc.dart';
import 'admin_psw_verification_detail_screen.dart';

class AdminVerificationsScreen extends StatelessWidget {
  const AdminVerificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminBloc, AdminState>(
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
      builder: (context, state) {
        final isLoading =
            state is VerificationsLoading ||
            state is VerificationMutationLoading;
        final list = state is VerificationsLoaded
            ? state.list
            .where((e) => e.verificationStatus == "Pending")
            .toList()
            : <AdminPswVerificationEntity>[];

        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          body: Column(
            children: [
              // ── Header ───────────────────────────────────────────────────
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1A73E8), Color(0xFF0D47A1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'PSW Verifications',
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${list.length} pending review',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => context.read<AdminBloc>().add(
                            FetchPendingVerificationsEvent(),
                          ),
                          icon: const Icon(
                            Icons.refresh_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Body ─────────────────────────────────────────────────────
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : state is VerificationsError
                    ? _ErrorView(
                        message: state.message,
                        onRetry: () => context.read<AdminBloc>().add(
                          FetchPendingVerificationsEvent(),
                        ),
                      )
                    : list.isEmpty
                    ? const _EmptyView(
                        icon: Icons.verified_user_outlined,
                        message: 'No pending verifications',
                      )
                    : RefreshIndicator(
                        onRefresh: () async => context.read<AdminBloc>().add(
                          FetchPendingVerificationsEvent(),
                        ),
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                          itemCount: list.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (ctx, i) =>
                              _VerificationCard(item: list[i])

                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Verification Card ─────────────────────────────────────────────────────────

class _VerificationCard extends StatelessWidget {
  final AdminPswVerificationEntity item;

  const _VerificationCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Tapping the card navigates to the full detail / review screen
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: context.read<AdminBloc>(),
            child: AdminPswVerificationDetailScreen(item: item),
          ),
        ),
      ),
      child: Container(
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
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: const Color(0xFF1A73E8).withOpacity(0.12),
                    child: Text(
                      item.fullName.isNotEmpty
                          ? item.fullName[0].toUpperCase()
                          : 'P',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A73E8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.fullName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.email,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        if (item.phoneNumber.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            item.phoneNumber,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Status badge
                  _StatusBadge(status: 'Pending'),
                ],
              ),
            ),

            // Info row (ID type + submitted date)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  if (item.proofIdentityType.isNotEmpty)
                    _InfoChip(
                      icon: Icons.badge_outlined,
                      label: item.proofIdentityType,
                    ),
                  const SizedBox(width: 8),
                  if (item.submittedAt.isNotEmpty)
                    _InfoChip(
                      icon: Icons.schedule,
                      label: _formatDate(item.submittedAt),
                    ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Actions
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          _showRejectDialog(context, item.pswId, item.fullName),
                      icon: const Icon(Icons.close, size: 16),
                      label: const Text('Reject'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // "Review" button navigates to detail screen
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<AdminBloc>(),
                            child: AdminPswVerificationDetailScreen(item: item),
                          ),
                        ),
                      ),
                      icon: const Icon(Icons.visibility_outlined, size: 16),
                      label: const Text('Review'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF1A73E8),
                        side: const BorderSide(color: Color(0xFF1A73E8)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => context.read<AdminBloc>().add(
                        ApproveVerificationEvent(item.pswId),
                      ),
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('Approve'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        elevation: 0,
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
              'You are about to reject the verification for:',
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

// ── Status Badge ──────────────────────────────────────────────────────────────

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

// ── Info chip ─────────────────────────────────────────────────────────────────

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.grey.shade600),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

// ── Shared helpers ────────────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyView({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 56, color: Colors.red.shade300),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
