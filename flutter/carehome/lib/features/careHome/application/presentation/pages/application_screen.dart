import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/network/dio_handler.dart';
import '../../domain/entities/carehome_application_entity.dart';
import '../manager/care_home_application_bloc.dart';
import '../widgets/application_card.dart';

/// CareHome sees all PSW applications grouped by their offer.
/// The screen uses the careHomeId to fetch across all offers,
/// then lets the care home filter by status tabs.
///
/// Since the API is per-offer, we pass a specific offerId.
/// If you want to show applications for ALL offers, call this
/// screen from inside each offer's detail view.
class ApplictionScreen extends StatelessWidget {
  /// Pass the offerId you want to view applications for.
  /// If null, shows a "select an offer" placeholder.
  final String? offerId;

  const ApplictionScreen({super.key, this.offerId});

  @override
  Widget build(BuildContext context) {
    if (offerId == null) {
      return _NoOfferSelected();
    }

    return BlocProvider(
      create: (_) =>
      CareHomeApplicationBloc()
        ..add(FetchApplicationsByOfferEvent(offerId!)),
      child: _ApplicationBody(offerId: offerId!),
    );
  }
}

// ── Placeholder when no offer selected ───────────────────────────────────────

class _NoOfferSelected extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Applications',
                      style: Theme
                          .of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800)),
                  Text('Review & respond to applicants',
                      style: TextStyle(color: Colors.grey.shade500)),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.touch_app_outlined,
                        size: 64, color: Colors.grey.shade300),
                    const SizedBox(height: 16),
                    Text(
                      'Tap an offer to view its applications',
                      style: TextStyle(
                          color: Colors.grey.shade400, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Main body ─────────────────────────────────────────────────────────────────

class _ApplicationBody extends StatelessWidget {
  final String offerId;

  const _ApplicationBody({required this.offerId});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CareHomeApplicationBloc, CareHomeApplicationState>(
      listener: (context, state) {
        if (state is CareHomeApplicationMutationSuccess) {
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
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.grey.shade50,
          body: SafeArea(
            child: BlocBuilder<CareHomeApplicationBloc,
                CareHomeApplicationState>(
              buildWhen: (_, s) =>
              s is CareHomeApplicationsLoading ||
                  s is CareHomeApplicationsLoaded ||
                  s is CareHomeApplicationsError,
              builder: (context, state) {
                final all = state is CareHomeApplicationsLoaded
                    ? state.applications
                    : <CareHomeApplicationEntity>[];

                int _count(int status) =>
                    all
                        .where((a) => a.overallStatus == status)
                        .length;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header ───────────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Applications',
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                              // Refresh button
                              IconButton(
                                onPressed: () =>
                                    context
                                        .read<CareHomeApplicationBloc>()
                                        .add(FetchApplicationsByOfferEvent(
                                        offerId)),
                                icon: const Icon(Icons.refresh_rounded),
                              ),
                            ],
                          ),
                          Text('Review & respond to applicants',
                              style: TextStyle(
                                  color: Colors.grey.shade500)),

                          const SizedBox(height: 12),

                          // ── Summary chips ───────────────────────────────
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(children: [
                              _Chip(
                                  label: 'Pending',
                                  count: _count(1),
                                  color: Colors.orange),
                              const SizedBox(width: 8),
                              _Chip(
                                  label: 'Accepted',
                                  count: _count(3),
                                  color: Colors.green),
                              const SizedBox(width: 8),
                              _Chip(
                                  label: 'Rejected',
                                  count: _count(2),
                                  color: Colors.red),
                            ]),
                          ),

                          const SizedBox(height: 16),

                          // ── Tabs ────────────────────────────────────────
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
                                  fontSize: 14),
                              tabs: [
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

                    // ── Loading / Error ─────────────────────────────────
                    if (state is CareHomeApplicationsLoading)
                      const Expanded(
                          child: Center(
                              child: CircularProgressIndicator())),

                    if (state is CareHomeApplicationsError)
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
                                        .read<CareHomeApplicationBloc>()
                                        .add(FetchApplicationsByOfferEvent(
                                        offerId)),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // ── Tab views ────────────────────────────────────────
                    if (state is CareHomeApplicationsLoaded)
                      Expanded(
                        child: TabBarView(
                          children: [
                            _AppList(
                                all: all,
                                statusFilter: 1,
                                offerId: offerId),
                            _AppList(
                                all: all,
                                statusFilter: 3,
                                offerId: offerId),
                            _AppList(
                                all: all,
                                statusFilter: 2,
                                offerId: offerId),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ── Tab list ──────────────────────────────────────────────────────────────────

class _AppList extends StatelessWidget {
  final List<CareHomeApplicationEntity> all;
  final int statusFilter;
  final String offerId;

  const _AppList({
    required this.all,
    required this.statusFilter,
    required this.offerId,
  });

  @override
  Widget build(BuildContext context) {
    final list =
    all.where((a) => a.overallStatus == statusFilter).toList();

    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined,
                size: 56, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              'No applications here',
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
              .read<CareHomeApplicationBloc>()
              .add(FetchApplicationsByOfferEvent(offerId)),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (ctx, i) =>
            CareHomeApplicationCard(
              application: list[i],
              offerId: offerId,
        ),
      ),
    );
  }
}

// ── Summary chip ──────────────────────────────────────────────────────────────

class _Chip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _Chip({required this.label, required this.count, required this.color});

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
            width: 8, height: 8,
            decoration:
            BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text('$count $label',
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 13)),
        ],
      ),
    );
  }
}