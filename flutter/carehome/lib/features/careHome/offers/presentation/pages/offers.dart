import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/network/dio_handler.dart';
import '../../../../../core/constants/data.dart';
import '../../data/models/offer_model.dart';
import '../manager/care_home_offers_bloc.dart';
import '../widgets/add_offer_form.dart';
import '../widgets/offer_card.dart';

// ── Sort option ───────────────────────────────────────────────────────────────

class _SortOpt {
  final String label;
  final String value;
  final IconData icon;

  const _SortOpt(this.label, this.value, this.icon);
}

const _kSortOpts = [
  _SortOpt('Highest Rate', 'rate_desc', Icons.arrow_upward),
  _SortOpt('Lowest Rate', 'rate_asc', Icons.arrow_downward),
  _SortOpt('Newest', 'date_desc', Icons.calendar_today),
  _SortOpt('Oldest', 'date_asc', Icons.history),
];

const int _kPageSize = Data.kOffersPageSize;

// ── Screen ────────────────────────────────────────────────────────────────────

class OfferScreen extends StatelessWidget {
  const OfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final careHomeId = NetworkDioHandler().currentUserId ?? '';

    return BlocProvider(
      create: (_) =>
      CareHomeOffersBloc()
        ..add(FetchCareHomeOffersEvent(careHomeId: careHomeId)),
      child: BlocListener<CareHomeOffersBloc, CareHomeOffersState>(
        listener: (context, state) {
          if (state is CareHomeOfferMutationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.all(16),
            ));
          }
          if (state is CareHomeOfferMutationError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ));
          }
        },
        child: _OfferBody(careHomeId: careHomeId),
      ),
    );
  }
}

// ── Body ──────────────────────────────────────────────────────────────────────

class _OfferBody extends StatefulWidget {
  final String careHomeId;
  const _OfferBody({required this.careHomeId});

  @override
  State<_OfferBody> createState() => _OfferBodyState();
}

class _OfferBodyState extends State<_OfferBody> {
  final ScrollController _scroll = ScrollController();
  final TextEditingController _searchCtrl = TextEditingController();
  Timer? _debounce;

  bool _isSearchVisible = false;
  String? _currentSort;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.dispose();
    _searchCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  void _fetchFresh() {
    _currentPage = 1;
    context.read<CareHomeOffersBloc>().add(FetchCareHomeOffersEvent(
      careHomeId: widget.careHomeId,
      pageSize: _kPageSize,
      search: _searchCtrl.text
          .trim()
          .isEmpty
          ? null
          : _searchCtrl.text.trim(),
      sort: _currentSort,
    ));
  }

  void _loadMore() {
    _currentPage++;
    context.read<CareHomeOffersBloc>().add(LoadMoreCareHomeOffersEvent(
      pageIndex: _currentPage,
      pageSize: _kPageSize,
      search: _searchCtrl.text
          .trim()
          .isEmpty
          ? null
          : _searchCtrl.text.trim(),
      sort: _currentSort,
    ));
  }

  void _onScroll() {
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 200) {
      final s = context
          .read<CareHomeOffersBloc>()
          .state;
      if (s is CareHomeOffersLoaded && s.hasMore && !s.isLoadingMore) {
        _loadMore();
      }
    }
  }

  void _onSearchChanged(String _) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), _fetchFresh);
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: BlocBuilder<CareHomeOffersBloc, CareHomeOffersState>(
        buildWhen: (_, s) =>
        s is CareHomeOffersLoading ||
            s is CareHomeOffersLoaded ||
            s is CareHomeOffersError,
        builder: (context, state) {
          final loaded =
          state is CareHomeOffersLoaded ? state : null;
          final offers = loaded?.offers ?? <CareHomeOfferListItem>[];

          return Column(
            children: [
              // ── Header ─────────────────────────────────────────────────
              _buildHeader(context, loaded),

              // ── Search bar (collapsible) ────────────────────────────────
              AnimatedSize(
                duration: const Duration(milliseconds: 220),
                child: _isSearchVisible
                    ? _buildSearchBar()
                    : const SizedBox.shrink(),
              ),

              // ── Loading ────────────────────────────────────────────────
              if (state is CareHomeOffersLoading)
                const Expanded(
                    child: Center(child: CircularProgressIndicator())),

              // ── Error ──────────────────────────────────────────────────
              if (state is CareHomeOffersError)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 48, color: Colors.red),
                        const SizedBox(height: 12),
                        Text(state.message, textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _fetchFresh,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),

              // ── Loaded list ────────────────────────────────────────────
              if (loaded != null) ...[
                // Pagination strip
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      vertical: 6, horizontal: 20),
                  child: Text(
                    'Showing ${offers.length} of ${loaded.totalCount}',
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade500),
                  ),
                ),

                Expanded(
                  child: offers.isEmpty
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.work_off_outlined,
                            size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        Text('No offers found',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade500)),
                      ],
                    ),
                  )
                      : RefreshIndicator(
                    onRefresh: () async => _fetchFresh(),
                    child: ListView.builder(
                      controller: _scroll,
                      padding: const EdgeInsets.fromLTRB(
                          16, 12, 16, 24),
                      itemCount: offers.length +
                          (loaded.isLoadingMore ? 1 : 0),
                      itemBuilder: (_, i) {
                        if (i == offers.length) {
                          return const Padding(
                            padding:
                            EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                                child: CircularProgressIndicator(
                                    strokeWidth: 2)),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: OfferCard(offer: offers[i]),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context, CareHomeOffersLoaded? loaded) {
    final count = loaded?.totalCount ?? 0;
    return Container(
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
          padding: const EdgeInsets.fromLTRB(20, 14, 8, 16),
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
                          ?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800),
                    ),
                    Text(
                      '$count total offers',
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              // Search
              IconButton(
                tooltip: 'Search',
                onPressed: () =>
                    setState(() {
                      _isSearchVisible = !_isSearchVisible;
                      if (!_isSearchVisible) {
                        _searchCtrl.clear();
                        _fetchFresh();
                      }
                    }),
                icon: Icon(
                  _isSearchVisible ? Icons.search_off : Icons.search,
                  color: Colors.white,
                ),
              ),
              // Sort
              IconButton(
                tooltip: 'Sort',
                onPressed: _showSortSheet,
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.sort_rounded, color: Colors.white),
                    if (_currentSort != null)
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Add offer
              TextButton.icon(
                onPressed: () =>
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) =>
                          BlocProvider.value(
                            value: context.read<CareHomeOffersBloc>(),
                            child: const AddOfferDialog(),
                          ),
                    ),
                icon: const Icon(Icons.add, color: Colors.white, size: 18),
                label: const Text('Add',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600)),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                ),
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }

  // ── Search bar ────────────────────────────────────────────────────────────

  Widget _buildSearchBar() {
    return Container(
      color: const Color(0xFF0D47A1),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: TextField(
        controller: _searchCtrl,
        onChanged: _onSearchChanged,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search offers…',
          hintStyle: const TextStyle(color: Colors.white60, fontSize: 13),
          prefixIcon:
          const Icon(Icons.search, color: Colors.white60, size: 20),
          suffixIcon: _searchCtrl.text.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear,
                color: Colors.white60, size: 18),
            onPressed: () {
              _searchCtrl.clear();
              _fetchFresh();
              setState(() {});
            },
          )
              : null,
          filled: true,
          fillColor: Colors.white.withOpacity(0.15),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // ── Sort sheet ────────────────────────────────────────────────────────────

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) =>
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Sort by',
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                // Default
                _SortTile(
                  label: 'Default',
                  icon: Icons.format_list_bulleted,
                  isSelected: _currentSort == null,
                  onTap: () {
                    setState(() => _currentSort = null);
                    Navigator.pop(ctx);
                    _fetchFresh();
                  },
                ),
                ..._kSortOpts.map((o) =>
                    _SortTile(
                      label: o.label,
                      icon: o.icon,
                      isSelected: _currentSort == o.value,
                      onTap: () {
                        setState(() => _currentSort = o.value);
                        Navigator.pop(ctx);
                        _fetchFresh();
                      },
                    )),
              ],
            ),
          ),
    );
  }
}

// ── Sort tile ─────────────────────────────────────────────────────────────────

class _SortTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortTile({required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c =
    isSelected ? const Color(0xFF1A73E8) : Colors.black87;
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon,
          size: 18,
          color: isSelected
              ? const Color(0xFF1A73E8)
              : Colors.grey.shade500),
      trailing: Icon(
        isSelected
            ? Icons.radio_button_checked
            : Icons.radio_button_unchecked,
        color: isSelected
            ? const Color(0xFF1A73E8)
            : Colors.grey.shade400,
        size: 18,
      ),
      title: Text(label,
          style: TextStyle(
              fontSize: 14,
              color: c,
              fontWeight:
              isSelected ? FontWeight.w600 : FontWeight.normal)),
      onTap: onTap,
    );
  }
}