import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/carehome_application_entity.dart';
import '../manager/care_home_application_bloc.dart';

// ── Application Card ──────────────────────────────────────────────────────────

class CareHomeApplicationCard extends StatelessWidget {
  final CareHomeApplicationEntity application;
  final String offerId;

  const CareHomeApplicationCard({
    super.key,
    required this.application,
    required this.offerId,
  });

  Color get _statusColor {
    switch (application.overallStatus) {
      case "Accepted":
        return Colors.green;
      case "QualifiedByAdmin":
        return Colors.orange;
      case "RejectedByAdmin":
        return Colors.red;
      case"RejectedByCareHome":
        return Colors.red;
      case "QualifiedByAdmin":
        return Colors.green;

      default:
        return Colors.orange;
    }
  }

  IconData get _statusIcon {
    switch (application.overallStatus) {
      case "QualifiedByAdmin":
        return Icons.check_circle_outline;
      case"RejectedByCareHome":
        return Icons.cancel_outlined;
      case "RejectedByAdmin":
        return Icons.cancel_outlined;
      case "Accepted":
        return Icons.check_circle_outline;
      case "Pending":
        return Icons.hourglass_empty_rounded;
      case "Canceled":
        return Icons.cancel_outlined;

      default:
        return Icons.hourglass_empty_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final psw = application.psw;
    final sc = _statusColor;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _showDetails(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Avatar + Name + Status ──────────────────────────────────
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.blue.shade50,
                  child: Text(
                    psw.fullName.isNotEmpty
                        ? psw.fullName[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(psw.fullName,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                      Row(
                        children: [
                          if (psw.isVerified)
                            Icon(Icons.verified,
                                size: 13,
                                color: Colors.blue.shade600),
                          if (psw.isVerified)
                            const SizedBox(width: 3),
                          Text(
                            psw.isVerified ? 'Verified' : 'Unverified',
                            style: TextStyle(
                                fontSize: 12,
                                color: psw.isVerified
                                    ? Colors.blue.shade600
                                    : Colors.grey),
                          ),
                          const SizedBox(width: 8),
                          Text('Age ${psw.age}',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500)),
                        ],
                      ),
                    ],
                  ),
                ),
                // Overall status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: sc.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_statusIcon, size: 13, color: sc),
                      const SizedBox(width: 4),
                      Text(application.overallStatusLabel,
                          style: TextStyle(
                              color: sc,
                              fontWeight: FontWeight.w600,
                              fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Divider(color: Colors.grey.shade100),
            const SizedBox(height: 8),

            // ── Shifts summary ──────────────────────────────────────────
            Text(
              '${application.shifts.length} shift${application.shifts.length !=
                  1 ? 's' : ''} applied',
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500),
            ),

            // ── Shift pills ─────────────────────────────────────────────
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: application.shifts.map((shift) {
                final color = shift.status == "QualifiedByAdmin"
                    ? Colors.green
                    : shift.status == "RejectedByCareHome"
                    ? Colors.red
                    : Colors.orange;
                return Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Text(
                    '${shift.date}  ${shift.startTime}–${shift.endTime}',
                    style: TextStyle(
                        fontSize: 11,
                        color: color,
                        fontWeight: FontWeight.w600),
                  ),
                );
              }).toList(),
            ),

            // ── Quick actions (only for pending) ────────────────────────
            if (application.overallStatus == "Pending") ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showDetails(context),
                      icon: const Icon(Icons.visibility_outlined, size: 15),
                      label: const Text('View Details'),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding:
                        const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _quickAcceptAll(context),
                      icon: const Icon(Icons.check, size: 15),
                      label: const Text('Accept All'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding:
                        const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Accepts all pending shifts in this application
  void _quickAcceptAll(BuildContext context) {
    final pendingShifts =
    application.shifts.where((s) => s.status == 2).toList();
    for (final shift in pendingShifts) {
      context.read<CareHomeApplicationBloc>().add(
        AcceptApplicationEvent(
          shiftId: shift.shiftId,
          jobRequestItemId: shift.jobRequestItemId,
          offerId: offerId,
        ),
      );
    }
  }

  void _showDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) =>
          BlocProvider.value(
            value: context.read<CareHomeApplicationBloc>(),
            child: CareHomeApplicationDetailsDialog(
              application: application,
              offerId: offerId,
            ),
          ),
    );
  }
}

// ── Details Dialog ────────────────────────────────────────────────────────────

class CareHomeApplicationDetailsDialog extends StatelessWidget {
  final CareHomeApplicationEntity application;
  final String offerId;

  const CareHomeApplicationDetailsDialog({
    super.key,
    required this.application,
    required this.offerId,
  });

  @override
  Widget build(BuildContext context) {
    final psw = application.psw;

    return BlocListener<CareHomeApplicationBloc, CareHomeApplicationState>(
      listener: (context, state) {
        if (state is CareHomeApplicationMutationSuccess) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ));
        }
        if (state is CareHomeApplicationMutationError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ));
        }
      },
      child: Dialog(
        backgroundColor: Colors.white,
        // ✅ Remove insetPadding horizontal so the dialog touches screen edges
        insetPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        // ✅ clipBehavior ensures the gradient header is clipped to the dialog's rounded corners
        clipBehavior: Clip.antiAlias,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: SingleChildScrollView(
          // ✅ NO padding here — the gradient header must be edge-to-edge
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header — full bleed, no outer padding ─────────────────
              Container(
                width: double.infinity,
                // ✅ Padding lives INSIDE the container, not outside
                padding: const EdgeInsets.fromLTRB(20, 20, 8, 28),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1A73E8), Color(0xFF0D47A1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(36),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Application Details',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Full profile & response',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, color: Colors.white),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ── PSW Profile ───────────────────────────────────────
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 36,
                            // ✅ White translucent avatar on the gradient
                            backgroundColor: Colors.white.withOpacity(0.2),
                            child: Text(
                              psw.fullName.isNotEmpty
                                  ? psw.fullName[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            psw.fullName,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (psw.isVerified) ...[
                                const Icon(Icons.verified,
                                    size: 15, color: Colors.white70),
                                const SizedBox(width: 4),
                                const Text(
                                  'Verified',
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(width: 10),
                              ],
                              Text(
                                'Age ${psw.age}',
                                style: const TextStyle(
                                    color: Colors.white60, fontSize: 13),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── Rest of the content — padded normally ─────────────────
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Divider(color: Colors.grey.shade100),
                    const SizedBox(height: 16),

                    // ── PSW Info ──────────────────────────────────────────
                    _InfoCard(children: [
                      _InfoItem(Icons.badge_outlined, 'ID Type',
                          psw.proofIdentityType),
                      _InfoItem(
                          Icons.work_outline_outlined,
                          'Work Status',
                          psw.workStatus ? 'Approved' : 'Pending Approval'),
                      _InfoItem(
                          Icons.calendar_today_outlined,
                          'Applied At',
                          application.appliedAt
                              .split('T')
                              .first),
                    ]),

                    const SizedBox(height: 20),

                    // ── Shifts ────────────────────────────────────────────
                    const Text(
                      'Applied Shifts',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 10),

                    ...application.shifts
                        .asMap()
                        .entries
                        .map((entry) {
                      final i = entry.key;
                      final shift = entry.value;
                      final color = shift.status == "Accepted"
                          ? Colors.green
                          : shift.status == "QualifiedByAdmin"
                          ? Colors.orange
                          : Colors.red;
                      final statusLabel = shift.status;

                      return Container(
                        margin: EdgeInsets.only(top: i == 0 ? 0 : 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(14),
                          border:
                          Border.all(color: color.withOpacity(0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(shift.date,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14)),
                                      const SizedBox(height: 2),
                                      Text(
                                          '${shift.startTime} – ${shift
                                              .endTime}',
                                          style: TextStyle(
                                              color: Colors.grey.shade500,
                                              fontSize: 13)),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(statusLabel,
                                      style: TextStyle(
                                          color: color,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12)),
                                ),
                              ],
                            ),

                            // ── Per-shift actions (only if pending) ───────
                            if (shift.status == "QualifiedByAdmin") ...[
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () =>
                                          context
                                              .read<CareHomeApplicationBloc>()
                                              .add(RejectApplicationEvent(
                                            jobRequestItemId:
                                            shift.jobRequestItemId,
                                            offerId: offerId,
                                          )),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.red,
                                        side: const BorderSide(
                                            color: Colors.red),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10)),
                                        padding:
                                        const EdgeInsets.symmetric(
                                            vertical: 8),
                                      ),
                                      child: const Text('Reject'),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () =>
                                          context
                                              .read<CareHomeApplicationBloc>()
                                              .add(AcceptApplicationEvent(
                                            shiftId: shift.shiftId,
                                            jobRequestItemId:
                                            shift.jobRequestItemId,
                                            offerId: offerId,
                                          )),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10)),
                                        padding:
                                        const EdgeInsets.symmetric(
                                            vertical: 8),
                                      ),
                                      child: const Text('Accept'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      );
                    }).toList(),

                    const SizedBox(height: 24),

                    // ── Close button ──────────────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      child: BlocBuilder<CareHomeApplicationBloc,
                          CareHomeApplicationState>(
                        builder: (context, state) {
                          if (state is CareHomeApplicationMutationLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          return OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Close'),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Info helpers ──────────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final List<Widget> children;

  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: children
            .expand((w) => [w, Divider(color: Colors.grey.shade200, height: 1)])
            .toList()
          ..removeLast(),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: Colors.blue.shade600),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}