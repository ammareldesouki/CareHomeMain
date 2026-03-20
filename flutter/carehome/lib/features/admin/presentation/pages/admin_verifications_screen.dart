import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/admin_psw_verification_entity.dart';
import '../manager/admin_bloc.dart';
import 'admin_psw_verification_detail_screen.dart';

// ── Tab definition ────────────────────────────────────────────────────────────

class _TabDef {
  final String label;
  final String? apiStatus; // null = no filter (All)
  final IconData icon;

  const _TabDef(this.label, this.apiStatus, this.icon);
}

const _tabs = [
  _TabDef('All', null, Icons.people_outline),
  _TabDef('Pending', 'Pending', Icons.hourglass_top_rounded),
  _TabDef('Approved', 'Approved', Icons.verified_rounded),
  _TabDef('Rejected', 'Rejected', Icons.cancel_outlined),
];

// ── Sort options ──────────────────────────────────────────────────────────────

class _SortOption {
  final String label;
  final String value;

  const _SortOption(this.label, this.value);
}

const _sortOptions = [
  _SortOption('Newest First', 'createdAt_desc'),
  _SortOption('Oldest First', 'createdAt_asc'),
  _SortOption('Name A → Z', 'name_asc'),
  _SortOption('Name Z → A', 'name_desc'),
];

// ── Screen ────────────────────────────────────────────────────────────────────

class AdminVerificationsScreen extends StatefulWidget {
  const AdminVerificationsScreen({super.key});

  @override
  State<AdminVerificationsScreen> createState() =>
      _AdminVerificationsScreenState();
}

class _AdminVerificationsScreenState extends State<AdminVerificationsScreen>
    with SingleTickerProviderStateMixin {
  static const int _pageSize = 10;

  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Timer? _debounce;
  String? _currentSort;
  int _currentPage = 1;

  String? get _currentStatus => _tabs[_tabController.index].apiStatus;

  String get _searchQuery => _searchController.text.trim();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchPage(1));
    _tabController.addListener(_onTabChanged);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_onTabChanged)
      ..dispose();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // ── Fetch helpers ─────────────────────────────────────────────────────────

  void _fetchPage(int page, {bool append = false}) {
    _currentPage = page;
    context.read<AdminBloc>().add(
      FetchVerificationsEvent(
        verificationStatus: _currentStatus,
        pageIndex: page,
        pageSize: _pageSize,
        search: _searchQuery.isEmpty ? null : _searchQuery,
        sort: _currentSort,

      ),
    );
  }

  void _reload() => _fetchPage(1, append: false);

  // ── Listeners ─────────────────────────────────────────────────────────────

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    _searchController.clear();
    setState(() => _currentSort = null);
    _fetchPage(1);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final atBottom = _scrollController.offset >=
        _scrollController.position.maxScrollExtent - 200;
    if (!atBottom) return;
    final state = context
        .read<AdminBloc>()
        .state;
    if (state is VerificationsLoaded && state.hasMore) {
      _fetchPage(_currentPage + 1, append: true);
    }
  }

  void _onSearchChanged(String _) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), _reload);
  }

  void _applySort(String? sortValue) {
    setState(() => _currentSort = sortValue);
    _fetchPage(1);
  }

  // ── Sort bottom sheet ─────────────────────────────────────────────────────

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) =>
          SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                  child: Row(
                    children: [
                      const Icon(Icons.sort_rounded, color: Color(0xFF1A73E8)),
                      const SizedBox(width: 8),
                      Text('Sort By',
                          style: Theme
                              .of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                const Divider(height: 1),
                _sortTile(
                  label: 'Default',
                  icon: Icons.clear_all_rounded,
                  value: null,
                ),
                ..._sortOptions.map((opt) =>
                    _sortTile(
                      label: opt.label,
                      icon: Icons.sort,
                      value: opt.value,
                    )),
                const SizedBox(height: 8),
              ],
            ),
          ),
    );
  }

  Widget _sortTile(
      {required String label, required IconData icon, required String? value}) {
    final selected = _currentSort == value;
    return ListTile(
      leading: Icon(icon,
          color: selected ? const Color(0xFF1A73E8) : Colors.grey.shade600),
      title: Text(
        label,
        style: TextStyle(
          color: selected ? const Color(0xFF1A73E8) : Colors.black87,
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      trailing: selected
          ? const Icon(Icons.check, color: Color(0xFF1A73E8), size: 18)
          : null,
      onTap: () {
        Navigator.pop(context);
        _applySort(value);
      },
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminBloc, AdminState>(
      listener: (context, state) {
        if (state is VerificationMutationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ));
        }
        if (state is VerificationMutationError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: Column(
          children: [
            _buildHeader(),
            _buildSearchAndSort(),
            _buildTabBar(),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return BlocBuilder<AdminBloc, AdminState>(
      builder: (context, state) {
        int total = 0;
        if (state is VerificationsLoaded) total = state.totalCount;
        if (state is VerificationsLoadingMore) total = state.totalCount;
        final tabLabel = _tabs[_tabController.index].label;
        final sub = total > 0
            ? '$total ${tabLabel == 'All' ? 'users' : tabLabel.toLowerCase()}'
            : 'PSW verifications';

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
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PSW Verifications',
                          style: Theme
                              .of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Text(sub,
                              key: ValueKey(sub),
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 13)),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _reload,
                    icon: const Icon(Icons.refresh_rounded,
                        color: Colors.white),
                    tooltip: 'Refresh',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Search + Sort ─────────────────────────────────────────────────────────

  Widget _buildSearchAndSort() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 42,
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search by name, email…',
                  hintStyle:
                  TextStyle(color: Colors.grey.shade400, fontSize: 13),
                  prefixIcon: Icon(Icons.search_rounded,
                      color: Colors.grey.shade500, size: 20),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      setState(() {});
                      _reload();
                    },
                    child: Icon(Icons.close,
                        color: Colors.grey.shade500, size: 18),
                  )
                      : null,
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Sort button
          GestureDetector(
            onTap: _showSortSheet,
            child: Container(
              height: 42,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: _currentSort != null
                    ? const Color(0xFF1A73E8).withOpacity(0.1)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _currentSort != null
                      ? const Color(0xFF1A73E8).withOpacity(0.4)
                      : Colors.transparent,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.sort_rounded,
                      size: 18,
                      color: _currentSort != null
                          ? const Color(0xFF1A73E8)
                          : Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    'Sort',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: _currentSort != null
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: _currentSort != null
                          ? const Color(0xFF1A73E8)
                          : Colors.grey.shade700,
                    ),
                  ),
                  if (_currentSort != null) ...[
                    const SizedBox(width: 4),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1A73E8),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Tab bar ───────────────────────────────────────────────────────────────

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: const Color(0xFF1A73E8),
            unselectedLabelColor: Colors.grey.shade500,
            indicatorColor: const Color(0xFF1A73E8),
            indicatorWeight: 2.5,
            labelStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(fontSize: 13),
            tabs: _tabs
                .map((t) =>
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(t.icon, size: 16),
                      const SizedBox(width: 5),
                      Text(t.label),
                    ],
                  ),
                ))
                .toList(),
          ),
          const Divider(height: 1, thickness: 1),
        ],
      ),
    );
  }

  // ── Body ──────────────────────────────────────────────────────────────────

  Widget _buildBody() {
    return BlocBuilder<AdminBloc, AdminState>(
      builder: (context, state) {
        if (state is VerificationsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is VerificationsError) {
          return _ErrorView(message: state.message, onRetry: _reload);
        }

        List<AdminPswVerificationEntity> list = [];
        bool isLoadingMore = false;
        bool hasMore = false;

        if (state is VerificationsLoaded) {
          list = state.list;
          hasMore = state.hasMore;
        } else if (state is VerificationsLoadingMore) {
          list = state.list;
          isLoadingMore = true;
        }

        if (list.isEmpty && !isLoadingMore) {
          return _EmptyView(
            icon: Icons.verified_user_outlined,
            message: _searchQuery.isNotEmpty
                ? 'No results for "$_searchQuery"'
                : 'No ${_tabs[_tabController.index].label
                .toLowerCase()} verifications',
          );
        }

        return RefreshIndicator(
          onRefresh: () async => _reload(),
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            itemCount: list.length + (isLoadingMore || hasMore ? 1 : 0),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (ctx, i) {
              if (i == list.length) {
                return isLoadingMore
                    ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child:
                      CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
                    : const SizedBox.shrink();
              }
              return _VerificationCard(item: list[i]);
            },
          ),
        );
      },
    );
  }
}

// ── Verification Card ─────────────────────────────────────────────────────────

class _VerificationCard extends StatelessWidget {
  final AdminPswVerificationEntity item;
  const _VerificationCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: context.read<AdminBloc>(),
            child: AdminPswVerificationDetailScreen(item: item),
          ),
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
        child: Column(
          children: [
            // Card body
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor:
                    const Color(0xFF1A73E8).withOpacity(0.12),
                    child: Text(
                      item.fullName.isNotEmpty
                          ? item.fullName[0].toUpperCase()
                          : 'P',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A73E8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.fullName,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15),
                        ),
                        const SizedBox(height: 3),
                        Text(item.email,
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 12)),
                        if (item.phoneNumber.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(item.phoneNumber,
                              style: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 12)),
                        ],
                      ],
                    ),
                  ),
                  _StatusBadge(status: item.verificationStatus),
                ],
              ),
            ),
            // Card footer
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  if (item.submittedAt.isNotEmpty)
                    _InfoChip(
                      icon: Icons.calendar_today_outlined,
                      label: _formatDate(item.submittedAt),
                    ),
                  const Spacer(),
                  if (item.verificationStatus.toLowerCase() == 'pending') ...[
                    _ActionButton(
                      label: 'Reject',
                      icon: Icons.close_rounded,
                      color: Colors.red,
                      onTap: () =>
                          _showRejectDialog(context, item.pswId, item.fullName),
                    ),
                    const SizedBox(width: 8),
                    _ActionButton(
                      label: 'Approve',
                      icon: Icons.check_rounded,
                      color: Colors.green,
                      onTap: () =>
                          context
                              .read<AdminBloc>()
                              .add(ApproveVerificationEvent(item.pswId)),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRejectDialog(BuildContext context, String pswId, String name) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child:
              Icon(Icons.cancel, color: Colors.red.shade600, size: 20),
            ),
            const SizedBox(width: 10),
            const Expanded(
                child: Text('Reject Verification',
                    style: TextStyle(fontSize: 16))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('You are about to reject the verification for:',
                style:
                TextStyle(color: Colors.grey.shade600, fontSize: 13)),
            const SizedBox(height: 4),
            Text(name,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 16),
            TextField(
              controller: ctrl,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Explain the reason for rejection…',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                  const BorderSide(color: Color(0xFF1A73E8)),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text('This reason will be visible to the PSW.',
                style: TextStyle(
                    fontSize: 12, color: Colors.orange.shade700)),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final reason = ctrl.text.trim();
              if (reason.isEmpty) return;
              Navigator.pop(ctx);
              context.read<AdminBloc>().add(
                RejectVerificationEvent(pswId: pswId, reason: reason),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Reject'),
          ),
        ],
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

// ── Action button ─────────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({required this.label,
    required this.icon,
    required this.color,
    required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(label,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color)),
          ],
        ),
      ),
    );
  }
}

// ── Status Badge ──────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg, border, fg;
    IconData icon;
    switch (status.toLowerCase()) {
      case 'verified':
      case 'approved':
        bg = Colors.green.shade50;
        border = Colors.green.shade200;
        fg = Colors.green.shade700;
        icon = Icons.check_circle_outline_rounded;
        break;
      case 'rejected':
        bg = Colors.red.shade50;
        border = Colors.red.shade200;
        fg = Colors.red.shade700;
        icon = Icons.cancel_outlined;
        break;
      case 'pending':
        bg = Colors.orange.shade50;
        border = Colors.orange.shade200;
        fg = Colors.orange.shade700;
        icon = Icons.hourglass_top_rounded;
        break;
      default:
        bg = Colors.grey.shade100;
        border = Colors.grey.shade300;
        fg = Colors.grey.shade600;
        icon = Icons.remove_circle_outline;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
          Text(status,
              style: TextStyle(
                  color: fg, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ── Info chip ─────────────────────────────────────────────────────────────────

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.grey.shade500),
          const SizedBox(width: 4),
          Text(label,
              style:
              TextStyle(fontSize: 11, color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}

// ── Empty view ────────────────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptyView({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 15)),
        ],
      ),
    );
  }
}

// ── Error view ────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 56, color: Colors.red.shade300),
          const SizedBox(height: 12),
          Text(message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}