// lib/features/psw/presentation/screens/psw_applied_screen.dart

import 'package:flutter/material.dart';

import '../../../../../core/data/fakedata.dart';
import '../../../account/data/models/model.dart';

class PswAppliedScreen extends StatelessWidget {
  const PswAppliedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FB),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ─────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'My Applications',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${appliedJobs.length} total applications',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                    const SizedBox(height: 16),

                    // ── Summary chips ─────────────────────────────────────
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _SummaryChip(
                            label: 'Pending',
                            count: appliedJobs
                                .where((j) => j.status == 'pending')
                                .length,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 8),
                          _SummaryChip(
                            label: 'Accepted',
                            count: appliedJobs
                                .where((j) => j.status == 'accepted')
                                .length,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 8),
                          _SummaryChip(
                            label: 'Rejected',
                            count: appliedJobs
                                .where((j) => j.status == 'rejected')
                                .length,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Tab bar ───────────────────────────────────────────
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const TabBar(
                        indicator: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        labelColor: Colors.black87,
                        unselectedLabelColor: Colors.grey,
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        tabs: [
                          Tab(text: 'All'),
                          Tab(text: 'Pending'),
                          Tab(text: 'Accepted'),
                          Tab(text: 'Rejected'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // ── Tab Views ─────────────────────────────────────────────
              Expanded(
                child: TabBarView(
                  children: [
                    _AppliedList(status: null),
                    _AppliedList(status: 'pending'),
                    _AppliedList(status: 'accepted'),
                    _AppliedList(status: 'rejected'),
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

class _SummaryChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _SummaryChip({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            '$count $label',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Applied List ─────────────────────────────────────────────────────────────

class _AppliedList extends StatelessWidget {
  final String? status;

  const _AppliedList({this.status});

  @override
  Widget build(BuildContext context) {
    final list = status == null
        ? appliedJobs
        : appliedJobs.where((j) => j.status == status).toList();

    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 56, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              'No ${status ?? ''} applications',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 15),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (ctx, i) => AppliedJobCard(job: list[i]),
    );
  }
}

// ─── Applied Job Card ─────────────────────────────────────────────────────────

class AppliedJobCard extends StatelessWidget {
  final AppliedJob job;

  const AppliedJobCard({super.key, required this.job});

  Color get _statusColor {
    switch (job.status) {
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  IconData get _statusIcon {
    switch (job.status) {
      case 'accepted':
        return Icons.check_circle_outline_rounded;
      case 'rejected':
        return Icons.cancel_outlined;
      default:
        return Icons.hourglass_empty_rounded;
    }
  }

  String get _statusLabel {
    switch (job.status) {
      case 'accepted':
        return 'Accepted';
      case 'rejected':
        return 'Rejected';
      default:
        return 'Pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    final sc = _statusColor;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border(left: BorderSide(color: sc, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Title + Status ────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: Text(
                    job.offerTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: sc.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_statusIcon, size: 13, color: sc),
                      const SizedBox(width: 4),
                      Text(
                        _statusLabel,
                        style: TextStyle(
                          color: sc,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),
            Text(
              job.careHomeName,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
            ),

            const SizedBox(height: 14),
            Divider(color: Colors.grey.shade100),
            const SizedBox(height: 10),

            // ── Details grid ─────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _DetailItem(
                    icon: Icons.apartment_outlined,
                    label: 'Branch',
                    value: job.branch,
                  ),
                ),
                Expanded(
                  child: _DetailItem(
                    icon: Icons.calendar_today_outlined,
                    label: 'Date',
                    value: job.date.split(',').last.trim(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _DetailItem(
                    icon: Icons.access_time_outlined,
                    label: 'Time',
                    value: '${job.timeFrom} – ${job.timeTo}',
                  ),
                ),
                Expanded(
                  child: _DetailItem(
                    icon: Icons.send_outlined,
                    label: 'Applied',
                    value: job.appliedDate,
                  ),
                ),
              ],
            ),

            // ── Accepted extra banner ─────────────────────────────────────
            if (job.status == 'accepted') ...[
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade100),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.celebration_outlined,
                      color: Colors.green.shade700,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Congratulations! Your application was accepted. The care home will contact you shortly.',
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // ── Rejected extra banner ─────────────────────────────────────
            if (job.status == 'rejected') ...[
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade100),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: Colors.red.shade600,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Unfortunately this application was not successful. Keep applying!',
                        style: TextStyle(
                          color: Colors.red.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 15, color: Colors.grey.shade400),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w500,
                ),
              ),
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
    );
  }
}
