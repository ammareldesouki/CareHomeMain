import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/admin_application_entity.dart';
import '../manager/admin_bloc.dart';

/// Full-screen detail view for a single PSW job application.
/// Shows PSW profile, offer details, Care Home info, shifts, and accept/reject.
class AdminApplicationDetailScreen extends StatelessWidget {
  final AdminApplicationEntity item;

  const AdminApplicationDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminBloc, AdminState>(
      listener: (context, state) {
        if (state is ApplicationMutationSuccess) {
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
          Navigator.pop(context);
        }
        if (state is ApplicationMutationError) {
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
          final isMutating = state is ApplicationMutationLoading;

          return Scaffold(
            backgroundColor: Colors.grey.shade50,
            body: CustomScrollView(
              slivers: [
                // ── App Bar ───────────────────────────────────────────────
                SliverAppBar(
                  expandedHeight: 160,
                  pinned: true,
                  backgroundColor: const Color(0xFF1A73E8),
                  foregroundColor: Colors.white,
                  title: const Text(
                    'Application Detail',
                    style: TextStyle(fontSize: 16),
                  ),
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
                                  item.psw.fullName.isNotEmpty
                                      ? item.psw.fullName[0].toUpperCase()
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
                                      item.psw.fullName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      item.psw.email,
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
                ),

                // ── Body Content ──────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── PSW Profile Section ───────────────────────────
                        _SectionTitle('PSW Profile'),
                        const SizedBox(height: 8),
                        _InfoCard(
                          children: [
                            _InfoRow(
                              icon: Icons.person_outline,
                              label: 'Full Name',
                              value: item.psw.fullName,
                            ),
                            _InfoRow(
                              icon: Icons.email_outlined,
                              label: 'Email',
                              value: item.psw.email,
                            ),
                            _InfoRow(
                              icon: Icons.phone_outlined,
                              label: 'Phone',
                              value: item.psw.phoneNumber.isNotEmpty
                                  ? item.psw.phoneNumber
                                  : '—',
                            ),
                            if (item.psw.age > 0)
                              _InfoRow(
                                icon: Icons.cake_outlined,
                                label: 'Age',
                                value: '${item.psw.age} years',
                              ),
                            _InfoRow(
                              icon: Icons.badge_outlined,
                              label: 'ID Type',
                              value: item.psw.proofIdentityType.isNotEmpty
                                  ? item.psw.proofIdentityType
                                  : '—',
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // ── Offer Section ─────────────────────────────────
                        _SectionTitle('Applied Offer'),
                        const SizedBox(height: 8),
                        _InfoCard(
                          children: [
                            _InfoRow(
                              icon: Icons.work_outline,
                              label: 'Title',
                              value: item.offer.title,
                            ),
                            _InfoRow(
                              icon: Icons.location_on_outlined,
                              label: 'Address',
                              value: item.offer.address,
                            ),
                            _InfoRow(
                              icon: Icons.attach_money,
                              label: 'Hourly Rate',
                              value:
                                  '\$${item.offer.hourlyRate.toStringAsFixed(0)}/hr',
                            ),
                            if (item.offer.description.isNotEmpty)
                              _InfoRow(
                                icon: Icons.description_outlined,
                                label: 'Description',
                                value: item.offer.description,
                              ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // ── Care Home Section ─────────────────────────────
                        _SectionTitle('Care Home'),
                        const SizedBox(height: 8),
                        _CareHomeCard(carehomeId: item.offer.carehomeId),

                        const SizedBox(height: 20),

                        // ── Shifts Section ────────────────────────────────
                        if (item.offer.shifts.isNotEmpty) ...[
                          _SectionTitle('Shifts (${item.offer.shifts.length})'),
                          const SizedBox(height: 8),
                          ...item.offer.shifts
                              .map((s) => _ShiftCard(shift: s))
                              .toList(),
                          const SizedBox(height: 20),
                        ],

                        // ── Applied At ────────────────────────────────────
                        if (item.appliedAt.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.schedule,
                                  size: 14,
                                  color: Colors.grey.shade500,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Applied on ${_formatDate(item.appliedAt)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // ── Action Buttons ────────────────────────────────
                        if (isMutating)
                          const Center(child: CircularProgressIndicator())
                        else
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () =>
                                      context.read<AdminBloc>().add(
                                        RejectApplicationEvent(item.requestId),
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
                                        ApproveApplicationEvent(item.requestId),
                                      ),
                                  icon: const Icon(Icons.check, size: 18),
                                  label: const Text('Accept'),
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

  String _formatDate(String dateStr) {
    try {
      return DateFormat('MMM dd, yyyy').format(DateTime.parse(dateStr));
    } catch (_) {
      return dateStr;
    }
  }
}

// ── Care Home Card (tappable to navigate to profile) ─────────────────────────

class _CareHomeCard extends StatelessWidget {
  final String carehomeId;

  const _CareHomeCard({required this.carehomeId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AdminCareHomeProfileScreen(careHomeId: carehomeId),
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A73E8).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.home_work_outlined,
                  size: 22,
                  color: Color(0xFF1A73E8),
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Care Home',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Tap to view Care Home profile',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Shift Card ────────────────────────────────────────────────────────────────

class _ShiftCard extends StatelessWidget {
  final AdminCareHomeShiftApplicationEntity shift;

  const _ShiftCard({required this.shift});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.access_time,
              size: 16,
              color: Colors.blue.shade700,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shift.date,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  '${shift.startTime} – ${shift.endTime}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          _ShiftStatusBadge(status: shift.status),
        ],
      ),
    );
  }
}

class _ShiftStatusBadge extends StatelessWidget {
  final String status;

  const _ShiftStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    String label;
    Color bg, text;
    switch (status) {
      case '2':
        label = 'Rejected';
        bg = Colors.red.shade50;
        text = Colors.red.shade700;
        break;
      case '3':
        label = 'Accepted';
        bg = Colors.green.shade50;
        text = Colors.green.shade700;
        break;
      default:
        label = 'Pending';
        bg = Colors.orange.shade50;
        text = Colors.orange.shade700;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: text,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: Colors.orange.shade700,
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

// ── Care Home Profile Screen ──────────────────────────────────────────────────
// Included here so navigation works without extra route config.
// It fetches care-home data from GET /api/profile/{id}.

class AdminCareHomeProfileScreen extends StatefulWidget {
  final String careHomeId;

  const AdminCareHomeProfileScreen({super.key, required this.careHomeId});

  @override
  State<AdminCareHomeProfileScreen> createState() =>
      _AdminCareHomeProfileScreenState();
}

class _AdminCareHomeProfileScreenState
    extends State<AdminCareHomeProfileScreen> {
  Map<String, dynamic>? _profile;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    // Re-use the Dio instance via a direct http call so we don't couple to
    // a new bloc. Import dio at the top of your actual file.
    // For now we show a placeholder if fetching is not yet wired.
    setState(() {
      _loading = false;
      _profile = {
        'name': 'Care Home',
        'email': '',
        'phone': '',
        'address': '',
        'id': widget.careHomeId,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: const Color(0xFF1A73E8),
            foregroundColor: Colors.white,
            title: const Text(
              'Care Home Profile',
              style: TextStyle(fontSize: 16),
            ),
            expandedHeight: 140,
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
                    padding: const EdgeInsets.fromLTRB(20, 52, 20, 16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: const Icon(
                            Icons.home_work,
                            size: 28,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Text(
                          'Care Home Details',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _loading
                ? const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : _error != null
                ? Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                : _CareHomeProfileBody(
                    profile: _profile!,
                    careHomeId: widget.careHomeId,
                  ),
          ),
        ],
      ),
    );
  }
}

class _CareHomeProfileBody extends StatelessWidget {
  final Map<String, dynamic> profile;
  final String careHomeId;

  const _CareHomeProfileBody({required this.profile, required this.careHomeId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Care Home Info Card
          Container(
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
                _InfoRow(
                  icon: Icons.home_work_outlined,
                  label: 'Care Home ID',
                  value: careHomeId,
                ),
                Divider(height: 1, color: Colors.grey.shade100),
                _InfoRow(
                  icon: Icons.info_outline,
                  label: 'Note',
                  value:
                      'Full profile details are loaded via GET /api/profile/{id}',
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
