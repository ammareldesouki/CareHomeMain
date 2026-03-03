// lib/features/careHome/offers/presentation/screens/offers.dart

import 'package:flutter/material.dart';
import '../../data/models/offer_model.dart';
import '../widgets/add_offer_form.dart';
import '../widgets/offer_card.dart';
import '../../../../../../core/data/fakedata.dart';

class OfferScreen extends StatefulWidget {
  const OfferScreen({super.key});

  @override
  State<OfferScreen> createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<OfferModel> offers = List.from(fakeOffers);

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

  List<OfferModel> get activeOffers =>
      offers.where((o) => o.isActive).toList();

  List<OfferModel> get inactiveOffers =>
      offers.where((o) => !o.isActive).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Job Offers',
                            style: Theme
                                .of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w800)),
                        Text('${offers.length} total · ${activeOffers
                            .length} active',
                            style: TextStyle(color: Colors.grey.shade500)),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => const AddOfferForm(),
                      );
                      setState(() {});
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: Text('Add Offer', style: Theme
                        .of(context)
                        .textTheme!
                        .bodyMedium,),
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

            // ── Tab bar ──────────────────────────────────────────────────
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
                          offset: const Offset(0, 2))
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                                color: Colors.green, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 6),
                          Text('Active (${activeOffers.length})'),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                                color: Colors.red, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 6),
                          Text('Inactive (${inactiveOffers.length})'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ── Tab views ────────────────────────────────────────────────
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _OfferList(
                    offers: activeOffers,
                    allOffers: offers,
                    onChanged: () => setState(() {}),
                  ),
                  _OfferList(
                    offers: inactiveOffers,
                    allOffers: offers,
                    onChanged: () => setState(() {}),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OfferList extends StatelessWidget {
  final List<OfferModel> offers;
  final List<OfferModel> allOffers;
  final VoidCallback onChanged;

  const _OfferList({required this.offers,
    required this.allOffers,
    required this.onChanged});

  @override
  Widget build(BuildContext context) {
    if (offers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
                Icons.work_off_outlined, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text('No offers here',
                style: TextStyle(
                    fontSize: 16, color: Colors.grey.shade500)),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
      itemCount: offers.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final offer = offers[i];
        return OfferCard(
          offer: offer,
          onChanged: () {
            // If delete was triggered, remove from list
            if (!allOffers.contains(offer)) {
              allOffers.remove(offer);
            }
            onChanged();
          },
        );
      },
    );
  }
}