import 'package:carehome/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/psw_application_entity.dart';
import '../manager/psw_application_bloc.dart';


class PswAppliedScreen extends StatelessWidget {
  const PswAppliedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // PswApplicationBloc is hoisted from CBottomNavigationBar
    return const _PswAppliedBody();
  }
}

class _PswAppliedBody extends StatelessWidget {
  const _PswAppliedBody();

  @override
  Widget build(BuildContext context) {
    return BlocListener<PswApplicationBloc, PswApplicationState>(
      listener: (context, state) {
        if (state is PswApplicationMutationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ));
        }
        if (state is PswApplicationMutationError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ));
        }
      },
      child: DefaultTabController(
        length: 5,
        child: Scaffold(
          backgroundColor: const Color(0xFFF4F6FB),
          body: BlocBuilder<PswApplicationBloc, PswApplicationState>(
            buildWhen: (_, s) =>
            s is PswApplicationsLoading ||
                s is PswApplicationsLoaded ||
                s is PswApplicationsError,
            builder: (context, state) {
              final all = state is PswApplicationsLoaded
                  ? state.applications
                  : <PswApplicationEntity>[];

              int _count(String code) =>
                  all
                      .where((a) => a.statusCode == code)
                      .length;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start
                ,
                children: [
                  // ── Header ───────────────────────────────────────────
                  Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.3,
                    width: double.infinity,
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'My Applications',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${all.length} total applications',
                          style:
                          TextStyle(color: Colors.grey.shade500),
                        ),
                        const SizedBox(height: 16),

                        // ── Summary chips ────────────────────────────
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _SummaryChip(
                                  label: 'Pending',
                                  count: _count("Pending"),
                                  color: Colors.orange),
                              const SizedBox(width: 8),
                              _SummaryChip(
                                  label: 'Accepted',
                                  count: _count("Accepted"),
                                  color: Colors.green),
                              const SizedBox(width: 8),
                              _SummaryChip(
                                  label: 'Rejected',
                                  count: _count("RejectedByCareHome"),
                                  color: Colors.red),
                              const SizedBox(width: 8),
                              _SummaryChip(
                                  label: 'Cancelled',
                                  count: _count("Canceled"),
                                  color: Colors.grey),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ── Tab bar ──────────────────────────────────
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const TabBar(
                            indicator: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10)),
                            ),
                            indicatorSize: TabBarIndicatorSize.tab,
                            dividerColor: Colors.transparent,
                            labelColor: Colors.black87,
                            unselectedLabelColor: Colors.grey,
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 10),
                            tabs: [
                              Tab(text: 'All'),
                              Tab(text: 'Pending'),
                              Tab(text: 'Accepted'),
                              Tab(text: 'Rejected'),
                              Tab(text: 'Cancelled'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ── Loading / Error ──────────────────────────────────
                  if (state is PswApplicationsLoading)
                    const Expanded(
                        child:
                        Center(child: CircularProgressIndicator())),

                  if (state is PswApplicationsError)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error_outline,
                                size: 48, color: Colors.red),
                            const SizedBox(height: 12),
                            Text(state.message,
                                textAlign: TextAlign.center),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () =>
                                  context
                                      .read<PswApplicationBloc>()
                                      .add(FetchMyApplicationsEvent()),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // ── Tab views ────────────────────────────────────────
                  if (state is PswApplicationsLoaded)
                    Expanded(
                      child: TabBarView(
                        children: [
                          _AppList(all: all, filter: null),
                          _AppList(all: all,
                              filter: "Pending",
                              SecondryFilter: "QualifiedByAdmin"),
                          _AppList(all: all, filter: "Accepted"),
                          _AppList(all: all,
                            filter: "RejectedByCareHome",
                            SecondryFilter: "RejectedByAdmin",),
                          _AppList(all: all, filter: "Canceled"),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// ── Tab list ──────────────────────────────────────────────────────────────────

class _AppList extends StatelessWidget {
  final List<PswApplicationEntity> all;
  final String? filter;
  final String? SecondryFilter; // null = all

  const _AppList(
      {required this.all, required this.filter, this.SecondryFilter});

  @override
  Widget build(BuildContext context) {
    final list =
    filter == null ? all : all.where((a) =>
    a.statusCode == filter || a.statusCode == SecondryFilter).toList();

    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined,
                size: 56, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              'No applications found',
              style:
              TextStyle(color: Colors.grey.shade400, fontSize: 15),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async =>
          context
              .read<PswApplicationBloc>()
              .add(FetchMyApplicationsEvent()),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (ctx, i) => _ApplicationCard(app: list[i]),
      ),
    );
  }
}

// ── Application card ──────────────────────────────────────────────────────────

class _ApplicationCard extends StatelessWidget {
  final PswApplicationEntity app;

  const _ApplicationCard({required this.app});

  Color get _color {
    switch (app.statusCode) {
      case "Accepted":
        return Colors.green;
      case "RejectedByCareHome":
        return Colors.red;
      case "Pending":
        return Colors.orange;
      case "RejectedByAdmin":
        return Colors.red;
      case "QualifiedByAdmin":
        return Colors.green;



      case "Canceled":
        return Colors.grey;
      default:
        return Colors.orange;
    }
  }

  IconData get _icon {
    switch (app.statusCode) {
      case "Pending":
        return Icons.hourglass_empty_rounded;
      case "QualifiedByAdmin":
        return Icons.check_circle_outline_rounded;
      case "RejectedByCareHome":
        return Icons.cancel_outlined;
      case "Accepted":
        return Icons.check_circle_outline_rounded;
      case "Canceled":
        return Icons.block_outlined;
      default:
        return Icons.hourglass_empty_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sc = _color;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border(left: BorderSide(color: TColors.primary, width: 4)),
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
            // ── Title + status ────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: Text(
                    app.offerTitle,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
                app.statusCode == "QualifiedByAdmin" ?
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.hourglass_empty, size: 13,
                          color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(
                        "Pending",
                        style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.w600,
                            fontSize: 12),
                      ),
                    ],

                  ),
                )

                    : app.statusCode == "RejectedByAdmin" ||
                    app.statusCode == "RejectedByCareHome" ?
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
                      Icon(_icon, size: 13, color: sc),
                      const SizedBox(width: 4),
                      Text(
                        "Rejected",
                        style: TextStyle(
                            color: sc,
                            fontWeight: FontWeight.w600,
                            fontSize: 12),
                      ),
                    ],

                  ),
                ) : Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: sc.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_icon, size: 13, color: sc),
                      const SizedBox(width: 4),
                      Text(
                        app.statusCode,
                        style: TextStyle(
                            color: sc,
                            fontWeight: FontWeight.w600,
                            fontSize: 12),
                      ),
                    ],

                  ),
                )

              ],
            ),

            const SizedBox(height: 4),
            Text(app.careHomeName,
                style: TextStyle(
                    color: Colors.grey.shade500, fontSize: 13)),

            const SizedBox(height: 14),
            Divider(color: Colors.grey.shade100),
            const SizedBox(height: 10),

            // ── Details ───────────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _DetailItem(
                    icon: Icons.location_on_outlined,
                    label: 'Address',
                    value: app.address,
                  ),
                ),
                Expanded(
                  child: _DetailItem(
                    icon: Icons.attach_money,
                    label: 'Rate',
                    value: '\$${app.hourlyRate.toStringAsFixed(0)}/hr',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _DetailItem(
                    icon: Icons.calendar_today_outlined,
                    label: 'Date',
                    value: app.shiftDate,
                  ),
                ),
                Expanded(
                  child: _DetailItem(
                    icon: Icons.access_time_outlined,
                    label: 'Time',
                    value: '${app.startTime} – ${app.endTime}',
                  ),
                ),
              ],
            ),

            // ── Status banners ────────────────────────────────────────────
            if (app.statusCode == "RejectedByCareHome") ...[
              const SizedBox(height: 14),
              _Banner(
                icon: Icons.info_outline_rounded,
                message:
                'Unfortunately this application Has been Rejected , Keep Applying',
                color: TColors.primary,
              ),
            ],
            if (app.statusCode == "Accepted") ...[
              const SizedBox(height: 14),
              _Banner(

                icon: Icons.celebration_outlined,
                message:
                'Congratulations! Your application Has been accepted.',
                color: TColors.primary,
              ),
            ],

            // ── Cancel button (only for pending) ──────────────────────────
            if (app.statusCode == "Pending") ...[
              const SizedBox(height: 14),
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton.icon(
                  onPressed: () => _confirmCancel(context),
                  icon: const Icon(Icons.cancel_outlined,
                      size: 16, color: Colors.red),
                  label: const Text('Cancel Application',
                      style: TextStyle(color: Colors.red)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _confirmCancel(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) =>
          AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            title: const Text('Cancel Application'),
            content:
            const Text('Are you sure you want to cancel this application?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('No')),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.pop(context);
                  context.read<PswApplicationBloc>().add(
                      CancelApplicationEvent(app.jobRequestItemId));
                },
                child: const Text('Yes, Cancel',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

class _SummaryChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _SummaryChip(
      {required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
            decoration:
            BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            '$count $label',
            style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  final IconData icon;
  final String message;
  final Color color;

  const _Banner({required this.icon,
    required this.message,
    required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailItem(
      {required this.icon, required this.label, required this.value});

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
              Text(label,
                  style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w500)),
              Text(value,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    );
  }
}