import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../psw/offer/presentation/manager/offers_bloc.dart';
import '../widgets/care_home_card.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<OffersBloc, OffersState>(
      // CRITICAL: only rebuild when list fields change — never on detail fetch
      buildWhen: (prev, curr) =>
      prev.listLoading != curr.listLoading ||
          prev.offers != curr.offers ||
          prev.listError != curr.listError,
      builder: (context, state) {
        // ── Loading first time ───────────────────────────────────────────────
        if (state.listLoading && state.offers.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // ── Error with no cached data ────────────────────────────────────────
        if (state.listError != null && state.offers.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                      Icons.wifi_off_rounded, size: 56, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(state.listError!, textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600)),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () =>
                        context.read<OffersBloc>().add(FetchOffersEvent()),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        // ── Empty ────────────────────────────────────────────────────────────
        if (state.offers.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.search_off_rounded, size: 56,
                    color: Colors.grey.shade300),
                const SizedBox(height: 12),
                Text('No offers available',
                    style: TextStyle(
                        color: Colors.grey.shade400, fontSize: 15)),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () =>
                      context.read<OffersBloc>().add(FetchOffersEvent()),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                ),
              ],
            ),
          );
        }

        // ── Loaded list ──────────────────────────────────────────────────────
        return RefreshIndicator(
          onRefresh: () async =>
              context.read<OffersBloc>().add(FetchOffersEvent()),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(

                  children: [
                    Container(
                      width: double.infinity,

                      height: 150,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF1A73E8), Color(0xFF0D47A1)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('Available Offers',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: -0.5)),
                            const SizedBox(height: 4),
                            Text('${state.offers.length} offers near you',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) =>
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: OfferListCard(
                              offer: state.offers[index], distance: null),
                        ),
                    childCount: state.offers.length,
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