import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/network/dio_handler.dart';
import '../../data/models/offer_model.dart';
import '../manager/care_home_offers_bloc.dart';
import '../widgets/offer_card.dart';
import '../widgets/add_offer_form.dart';

/// No required parameters — reads careHomeId from the NetworkDioHandler singleton
/// which is set right after login / registration.
class OfferScreen extends StatelessWidget {
  const OfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Read the logged-in user's ID from the singleton (set after login/register)
    final careHomeId = NetworkDioHandler().currentUserId ?? '';

    return BlocProvider(
      create: (_) =>
      CareHomeOffersBloc()
        ..add(FetchCareHomeOffersEvent(careHomeId: careHomeId)),
      child: BlocListener<CareHomeOffersBloc, CareHomeOffersState>(
        listener: (context, state) {
          if (state is CareHomeOfferMutationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.all(16),
              ),
            );
          }
          if (state is CareHomeOfferMutationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: _OfferBody(careHomeId: careHomeId),
      ),
    );
  }
}

class _OfferBody extends StatefulWidget {
  final String careHomeId;

  const _OfferBody({required this.careHomeId});

  @override
  State<_OfferBody> createState() => _OfferBodyState();
}

class _OfferBodyState extends State<_OfferBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: BlocBuilder<CareHomeOffersBloc, CareHomeOffersState>(
          buildWhen: (_, s) =>
          s is CareHomeOffersLoading ||
              s is CareHomeOffersLoaded ||
              s is CareHomeOffersError,
          builder: (context, state) {
            final offers = state is CareHomeOffersLoaded
                ? state.offers
                : <CareHomeOfferListItem>[];

            return Column(
              children: [
                // ── Top bar ──────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Job Offers',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            Text(
                              '${offers.length} total',
                              style:
                              TextStyle(color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) =>
                                BlocProvider.value(
                                  value:
                                  context.read<CareHomeOffersBloc>(),
                                  child: const AddOfferDialog(),
                                ),
                          );
                        },
                        icon: const Icon(Icons.add, size: 18),
                        label: Text(
                          'Add Offer',
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium,
                        ),
                        style: ElevatedButton.styleFrom(

                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── Loading ───────────────────────────────────────────────
                if (state is CareHomeOffersLoading)
                  const Expanded(
                      child: Center(child: CircularProgressIndicator())),

                // ── Error ─────────────────────────────────────────────────
                if (state is CareHomeOffersError)
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
                                context.read<CareHomeOffersBloc>().add(
                                    FetchCareHomeOffersEvent(
                                        careHomeId: widget.careHomeId)),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),

                // ── Loaded: tabs ──────────────────────────────────────────
                if (state is CareHomeOffersLoaded) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.07),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        labelColor: Colors.black87,
                        unselectedLabelColor: Colors.grey.shade600,
                        labelStyle: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                        tabs: [
                          Tab(
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle),
                                ),
                                const SizedBox(width: 6),
                                Text('All (${state.offers.length})'),
                              ],
                            ),
                          ),
                          const Tab(
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Icon(Icons.history,
                                    size: 14, color: Colors.blue),
                                SizedBox(width: 6),
                                Text('Details'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Tab 1 — offer list
                        RefreshIndicator(
                          onRefresh: () async =>
                              context.read<CareHomeOffersBloc>().add(
                                  FetchCareHomeOffersEvent(
                                      careHomeId: widget.careHomeId)),
                          child: state.offers.isEmpty
                              ? Center(
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Icon(Icons.work_off_outlined,
                                    size: 64,
                                    color: Colors.grey.shade300),
                                const SizedBox(height: 12),
                                Text(
                                  'No offers yet',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                          )
                              : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(
                                16, 4, 16, 20),
                            itemCount: state.offers.length,
                            separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                            itemBuilder: (_, i) =>
                                OfferCard(offer: state.offers[i]),
                          ),
                        ),

                        // Tab 2 — placeholder
                        Center(
                          child: Text(
                            'Tap an offer card to view details',
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}