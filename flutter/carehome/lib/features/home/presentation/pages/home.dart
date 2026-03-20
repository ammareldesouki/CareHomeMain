import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../psw/offer/presentation/manager/offers_bloc.dart';
import '../widgets/care_home_card.dart';

// ── Sort options ──────────────────────────────────────────────────────────────
class _SortOption {
  final String label;
  final String value;

  const _SortOption(this.label, this.value);
}

const _kSortOptions = [
  _SortOption('Highest Rate', 'rate_desc'),
  _SortOption('Lowest Rate', 'rate_asc'),
  _SortOption('Newest', 'date_desc'),
  _SortOption('Oldest', 'date_asc'),
];

const _kPageSize = 10;

// ── Home screen ───────────────────────────────────────────────────────────────

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // ── Controllers ─────────────────────────────────────────────────────────────
  late final TabController _tabController;
  late final ScrollController _scrollController;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  bool _isSearchVisible = false;
  String? _currentSort;
  int _currentPage = 1;

  // ── Tab → posterType filter ──────────────────────────────────────────────────
  // Tab 0 = All, Tab 1 = Individual, Tab 2 = CareHome (Organizations)
  static const _tabs = ['All', 'Individual', 'Organizations'];

  // posterType values used for client-side filtering
  String? get _currentPosterType {
    switch (_tabController.index) {
      case 1:
        return 'Individual';
      case 2:
        return 'CareHome';
      default:
        return null; // All
    }
  }

  // ── Fetch helpers ────────────────────────────────────────────────────────────

  void _fetchFresh() {
    _currentPage = 1;
    context.read<OffersBloc>().add(FetchOffersEvent(
      pageIndex: 1,
      pageSize: _kPageSize,
      search: _searchController.text
          .trim()
          .isEmpty
          ? null
          : _searchController.text.trim(),
      sort: _currentSort,
    ));
  }

  void _loadMore() {
    _currentPage++;
    context.read<OffersBloc>().add(LoadMoreOffersEvent(
      pageIndex: _currentPage,
      pageSize: _kPageSize,
      search: _searchController.text
          .trim()
          .isEmpty
          ? null
          : _searchController.text.trim(),
      sort: _currentSort,
    ));
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = context
          .read<OffersBloc>()
          .state;
      if (!state.listLoadingMore && state.hasMore && !state.listLoading) {
        _loadMore();
      }
    }
  }

  void _onSearchChanged(String _) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), _fetchFresh);
  }

  // ── Lifecycle ────────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this)
      ..addListener(() {
        if (!_tabController.indexIsChanging) {
          setState(() {});
          // No extra network call: just filter the already-loaded list.
        }
      });
    _scrollController = ScrollController()
      ..addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // ── Filtered list ────────────────────────────────────────────────────────────

  List filteredOffers(List offers) {
    final type = _currentPosterType;
    if (type == null) return offers;
    return offers
        .where((o) => o.posterType.toLowerCase() == type.toLowerCase())
        .toList();
  }

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<OffersBloc, OffersState>(
      buildWhen: (prev, curr) =>
      prev.listLoading != curr.listLoading ||
          prev.listLoadingMore != curr.listLoadingMore ||
          prev.offers != curr.offers ||
          prev.listError != curr.listError ||
          prev.hasMore != curr.hasMore,
      builder: (context, state) {
        final filtered = filteredOffers(state.offers);

        // ── Full-screen loading (first load) ─────────────────────────────────
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
                  const Icon(Icons.wifi_off_rounded,
                      size: 56, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(state.listError!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600)),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _fetchFresh,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          children: [
            // ── Header ────────────────────────────────────────────────────────
            _buildHeader(state),

            // ── Search bar (collapsible) ──────────────────────────────────────
            AnimatedSize(
              duration: const Duration(milliseconds: 220),
              child: _isSearchVisible
                  ? _buildSearchBar()
                  : const SizedBox.shrink(),
            ),

            // ── Tab bar ───────────────────────────────────────────────────────
            _buildTabBar(state.offers),

            // ── Content ───────────────────────────────────────────────────────
            Expanded(
              child: filtered.isEmpty && !state.listLoading
                  ? _EmptyView(
                message: _currentPosterType == null
                    ? 'No offers available'
                    : 'No ${_tabs[_tabController.index].toLowerCase()} offers',
              )
                  : RefreshIndicator(
                onRefresh: () async => _fetchFresh(),
                child: ListView.builder(
                  controller: _scrollController,
                  padding:
                  const EdgeInsets.fromLTRB(16, 8, 16, 120),
                  itemCount: filtered.length +
                      (state.listLoadingMore ? 1 : 0),
                  itemBuilder: (ctx, i) {
                    if (i == filtered.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                            child: CircularProgressIndicator(
                                strokeWidth: 2)),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: OfferListCard(
                        offer: filtered[i],
                        distance: null,
                      ),
                    );
                  },
                ),
              ),
            ),

            // ── Pagination strip ──────────────────────────────────────────────
            if (state.offers.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 6),
                color: Colors.white,
                child: Text(
                  'Showing ${filtered.length} offer${filtered.length != 1
                      ? 's'
                      : ''}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12, color: Colors.grey.shade500),
                ),
              ),
          ],
        );
      },
    );
  }

  // ── Header ───────────────────────────────────────────────────────────────────

  Widget _buildHeader(OffersState state) {
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
                    const Text(
                      'Available Offers',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      state.listLoading
                          ? 'Loading…'
                          : '${state.offers.length} offers near you',
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              // Search toggle
              IconButton(
                tooltip: 'Search',
                onPressed: () =>
                    setState(() {
                      _isSearchVisible = !_isSearchVisible;
                      if (!_isSearchVisible) {
                        _searchController.clear();
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
              // Refresh
              IconButton(
                tooltip: 'Refresh',
                onPressed: _fetchFresh,
                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Search bar ────────────────────────────────────────────────────────────────

  Widget _buildSearchBar() {
    return Container(
      color: const Color(0xFF0D47A1),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search offers…',
          hintStyle:
          const TextStyle(color: Colors.white60, fontSize: 13),
          prefixIcon:
          const Icon(Icons.search, color: Colors.white60, size: 20),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear,
                color: Colors.white60, size: 18),
            onPressed: () {
              _searchController.clear();
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

  // ── Tab bar ───────────────────────────────────────────────────────────────────

  Widget _buildTabBar(List allOffers) {
    // Count per tab
    final allCount = allOffers.length;
    final individualCount = allOffers
        .where((o) => o.posterType.toLowerCase() == 'individual')
        .length;
    final orgCount = allOffers
        .where((o) => o.posterType.toLowerCase() == 'carehome')
        .length;

    final counts = [allCount, individualCount, orgCount];

    return Container(
      color: const Color(0xFF0D47A1),
      child: TabBar(
        controller: _tabController,
        isScrollable: false,
        indicatorColor: Colors.white,
        indicatorWeight: 3,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white54,
        labelStyle: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        tabs: List.generate(
          _tabs.length,
              (i) =>
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_tabs[i]),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${counts[i]}',
                        style: const TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
        ),
      ),
    );
  }

  // ── Sort bottom sheet ─────────────────────────────────────────────────────────

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
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Sort by',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                _SortTile(
                  label: 'Default',
                  isSelected: _currentSort == null,
                  onTap: () {
                    setState(() => _currentSort = null);
                    Navigator.pop(ctx);
                    _fetchFresh();
                  },
                ),
                ..._kSortOptions.map((opt) =>
                    _SortTile(
                      label: opt.label,
                      isSelected: _currentSort == opt.value,
                      onTap: () {
                        setState(() => _currentSort = opt.value);
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
  final bool isSelected;
  final VoidCallback onTap;

  const _SortTile(
      {required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        isSelected
            ? Icons.radio_button_checked
            : Icons.radio_button_unchecked,
        color: isSelected
            ? const Color(0xFF1A73E8)
            : Colors.grey.shade400,
        size: 20,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          color: isSelected ? const Color(0xFF1A73E8) : Colors.black87,
          fontWeight:
          isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      onTap: onTap,
    );
  }
}

// ── Empty view ────────────────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  final String message;

  const _EmptyView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded,
              size: 56, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(message,
              style:
              TextStyle(color: Colors.grey.shade400, fontSize: 15)),
        ],
      ),
    );
  }
}