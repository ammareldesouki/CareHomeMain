import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/api.dart';
import '../../../../core/network/dio_handler.dart';
import '../manager/admin_bloc.dart';
import 'admin_offer_detail_screen.dart';

/// Standalone Care Home Profile page.
/// Fetches GET /api/profile/{id} and shows:
///  - Care Home information
///  - All offers created by that Care Home (from the existing AdminBloc state)
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
    try {
      final dio = NetworkDioHandler().dio;
      final res = await dio.get('api/admin/users/profile',
          queryParameters: {"id": widget.careHomeId});
      setState(() {
        _profile = Map<String, dynamic>.from(res.data["data"] ?? {});
        _loading = false;
      });
    } on DioException catch (e) {
      setState(() {
        _error = e.response?.data?['message'] ?? 'Failed to load profile';
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Something went wrong';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 150,
            pinned: true,
            backgroundColor: const Color(0xFF1A73E8),
            foregroundColor: Colors.white,
            title: const Text(
              'Care Home Profile',
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
                          radius: 30,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: Text(
                            _profile != null &&
                                (_profile!['legalName'] ?? '').isNotEmpty
                                ? (_profile!['name'] as String)[0].toUpperCase()
                                : 'C',
                            style: const TextStyle(
                              fontSize: 24,
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
                                _profile?['name'] ??
                                    '${_profile?['firstName'] ?? ''} ${_profile?['lastName'] ?? ''}'
                                        .trim(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                _profile?['email'] ?? '',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
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

          // ── Body ─────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: _loading
                ? const Padding(
                    padding: EdgeInsets.all(48),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : _error != null
                ? Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red.shade300,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _loading = true;
                              _error = null;
                            });
                            _loadProfile();
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : _ProfileBody(
                    profile: _profile!,
                    careHomeId: widget.careHomeId,
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Profile body ──────────────────────────────────────────────────────────────

class _ProfileBody extends StatelessWidget {
  final Map<String, dynamic> profile;
  final String careHomeId;

  const _ProfileBody({required this.profile, required this.careHomeId});

  @override
  Widget build(BuildContext context) {
    // Resolve name
    final name =
        (profile['name'] as String?) ??
        '${profile['firstName'] ?? ''} ${profile['lastName'] ?? ''}'.trim();
    final email = profile['email'] as String? ?? '';
    final phone = profile['phoneNumber'] as String? ?? '';

    // Address fields
    final address = profile['address'] as Map<String, dynamic>?;
    final addressStr = address != null
        ? [
            address['street'],
            address['city'],
            address['state'],
            address['country'],
          ].where((v) => v != null && v.toString().isNotEmpty).join(', ')
        : '';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Care Home Info ────────────────────────────────────────
          const _SectionTitle('Care Home Information'),
          const SizedBox(height: 8),
          _InfoCard(
            children: [
              _InfoRow(
                icon: Icons.home_work_outlined,
                label: 'Name',
                value: name.isNotEmpty ? name : '—',
              ),
              if (email.isNotEmpty)
                _InfoRow(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: email,
                ),
              if (phone.isNotEmpty)
                _InfoRow(
                  icon: Icons.phone_outlined,
                  label: 'Phone',
                  value: phone,
                ),
              if (addressStr.isNotEmpty)
                _InfoRow(
                  icon: Icons.location_on_outlined,
                  label: 'Address',
                  value: addressStr,
                ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Additional profile fields ─────────────────────────────
          if (_hasAdditionalFields(profile)) ...[
            const _SectionTitle('Additional Details'),
            const SizedBox(height: 8),
            _InfoCard(
              children: [
                if ((profile['workStatus'] ?? '').toString().isNotEmpty)
                  _InfoRow(
                    icon: Icons.work_outline,
                    label: 'Work Status',
                    value: profile['workStatus'].toString(),
                  ),
                if ((profile['isVerified'] ?? '').toString().isNotEmpty)
                  _InfoRow(
                    icon: Icons.verified_outlined,
                    label: 'Verified',
                    value: profile['isVerified'] == true ? 'Yes' : 'No',
                  ),
              ],
            ),
            const SizedBox(height: 20),
          ],

          // ── Offers by this Care Home ──────────────────────────────
          BlocBuilder<AdminBloc, AdminState>(
            builder: (context, state) {
              final offers = state is AdminOffersLoaded
                  ? state.list
                        .where(
                          (o) => o.careHomeName == name || o.id == careHomeId,
                        )
                        .toList()
                  : [];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle('Offers by this Care Home (${offers.length})'),
                  const SizedBox(height: 8),
                  if (offers.isEmpty)
                    _EmptyWidget(
                      icon: Icons.work_off_outlined,
                      message: 'No offers found for this care home',
                    )
                  else
                    ...offers
                        .map(
                          (offer) => _OfferMiniCard(
                            offer: offer,
                            bloc: context.read<AdminBloc>(),
                          ),
                        )
                        .toList(),
                ],
              );
            },
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  bool _hasAdditionalFields(Map<String, dynamic> p) {
    return p.containsKey('workStatus') || p.containsKey('isVerified');
  }
}

// ── Offer mini card ───────────────────────────────────────────────────────────

class _OfferMiniCard extends StatelessWidget {
  final dynamic offer;
  final AdminBloc bloc;

  const _OfferMiniCard({required this.offer, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: bloc,
            child: AdminOfferDetailScreen(offer: offer),
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A73E8), Color(0xFF0D47A1)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.work_outline,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    offer.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    offer.address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Text(
              '\$${offer.hourlyRate.toStringAsFixed(0)}/hr',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A73E8),
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}

// ── Empty placeholder ─────────────────────────────────────────────────────────

class _EmptyWidget extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyWidget({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: Colors.grey.shade300),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// ── Shared Widgets ────────────────────────────────────────────────────────────

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
