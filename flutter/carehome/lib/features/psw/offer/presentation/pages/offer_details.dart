import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/network/dio_handler.dart';
import '../../../application/presentation/manager/psw_application_bloc.dart';
import '../../domain/entities/offer_entity.dart';
import '../manager/offers_bloc.dart';

class OfferDetailSheet extends StatelessWidget {
  const OfferDetailSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF4F6FB),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: BlocBuilder<OffersBloc, OffersState>(
          buildWhen: (prev, curr) =>
              prev.detailLoading != curr.detailLoading ||
              prev.detail != curr.detail ||
              prev.detailError != curr.detailError,
          builder: (context, state) {
            if (state.detailLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.detailError != null) {
              return Center(
                child: Text(
                  state.detailError!,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            if (state.detail != null) {
              return _OfferDetailBody(
                controller: controller,
                detail: state.detail!,
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class _OfferDetailBody extends StatefulWidget {
  final ScrollController controller;
  final OfferDetailEntity detail;

  const _OfferDetailBody({required this.controller, required this.detail});

  @override
  State<_OfferDetailBody> createState() => _OfferDetailBodyState();
}

class _OfferDetailBodyState extends State<_OfferDetailBody> {
  final Set<String> _selectedShiftIds = {};

  static const accent = Color(0xFF1A73E8);

  List<ShiftEntity> get _availableShifts =>
      widget.detail.shifts.where((s) => s.isAvailable).toList();

  bool get _allSelected =>
      _availableShifts.isNotEmpty &&
      _availableShifts.every((s) => _selectedShiftIds.contains(s.shiftId));

  void _toggleSelectAll() {
    setState(() {
      if (_allSelected) {
        for (final s in _availableShifts) {
          _selectedShiftIds.remove(s.shiftId);
        }
      } else {
        for (final s in _availableShifts) {
          _selectedShiftIds.add(s.shiftId);
        }
      }
    });
  }

  void _toggleShift(String shiftId) {
    setState(() {
      if (_selectedShiftIds.contains(shiftId)) {
        _selectedShiftIds.remove(shiftId);
      } else {
        _selectedShiftIds.add(shiftId);
      }
    });
  }

  /// For Individual offers show only the postal-code portion of the address.
  /// The address format from API: "street, City, Country"
  /// We show the last segment as the area reference, labelled "Postal Code".
  String _postalCodeDisplay(String address) {
    if (address.isEmpty) return 'Unknown';
    final parts = address.split(',');
    return parts.last.trim();
  }

  @override
  Widget build(BuildContext context) {
    final offer = widget.detail;
    final workStatus = NetworkDioHandler().currentWorkStatus;
    final available = _availableShifts;
    final isIndividual = offer.isIndividual;

    return BlocListener<PswApplicationBloc, PswApplicationState>(
      listener: (context, state) {
        if (state is PswApplicationMutationSuccess) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        if (state is PswApplicationMutationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: CustomScrollView(
        controller: widget.controller,
        slivers: [
          // ── App Bar ───────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: accent,
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [accent, const Color(0xFF0D47A1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 56, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // ── Poster name + type badge ─────────────────────────
                        Row(
                          children: [
                            Icon(
                              isIndividual
                                  ? Icons.person_outline
                                  : Icons.business_outlined,
                              color: Colors.white70,
                              size: 14,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              offer.posterName.isNotEmpty
                                  ? offer.posterName
                                  : 'Unknown',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                offer.posterType,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // ── Rate badge ──────────────────────────────────────
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '\$${offer.hourlyRate.toStringAsFixed(0)}/hr',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          offer.title,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.copyWith(color: Colors.white),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 4),
                        // ── Address / Postal code ────────────────────────────
                        Row(
                          children: [
                            if (isIndividual) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Postal Code',
                                  style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _postalCodeDisplay(offer.address),
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.85),
                                  fontSize: 13,
                                ),
                              ),
                            ] else
                              Expanded(
                                child: Text(
                                  offer.address,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.85),
                                    fontSize: 13,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Work status warning ─────────────────────────────────────
                  if (workStatus == "None" || workStatus == "Pending") ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.orange.shade700,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              workStatus == "None"
                                  ? 'Your account is not yet verified. Complete your profile to apply.'
                                  : 'Your verification is pending. You will be notified once approved.',
                              style: TextStyle(
                                color: Colors.orange.shade700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // ── Quick badges ────────────────────────────────────────────
                  Row(
                    children: [
                      _QuickBadge(
                        icon: Icons.attach_money,
                        label: '\$${offer.hourlyRate.toStringAsFixed(0)}/hr',
                      ),
                      const SizedBox(width: 10),
                      _QuickBadge(
                        icon: isIndividual
                            ? Icons.person_outline
                            : Icons.business_outlined,
                        label: offer.posterType,
                      ),
                      const SizedBox(width: 10),
                      _QuickBadge(
                        icon: Icons.event_available_outlined,
                        label: '${available.length} available',
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ── Description ─────────────────────────────────────────────
                  if (offer.description.isNotEmpty)
                    _SectionCard(
                      title: 'About this offer',
                      icon: Icons.info_outline,
                      child: Text(
                        offer.description,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),

                  if (offer.description.isNotEmpty) const SizedBox(height: 16),

                  // ── Preferences ─────────────────────────────────────────────
                  if (offer.preferences.isNotEmpty) ...[
                    _SectionCard(
                      title: 'Preferences',
                      icon: Icons.star_border,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: offer.preferences
                            .map(
                              (p) => Chip(
                                label: Text(
                                  p,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                backgroundColor: accent.withOpacity(0.08),
                                side: BorderSide.none,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // ── Position ────────────────────────────────────────────────
                  if (offer.position.isNotEmpty) ...[
                    _SectionCard(
                      title: 'Position',
                      icon: Icons.work_outline,
                      child: Text(
                        offer.position,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // ── Location ────────────────────────────────────────────────
                  _SectionCard(
                    title: isIndividual ? 'Poster' : 'Location',
                    icon: isIndividual
                        ? Icons.person_outline
                        : Icons.location_on_outlined,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isIndividual ? offer.posterName : offer.address,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 14,
                          ),
                        ),
                        if (!isIndividual) ...[
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: () async {
                              final uri = Uri.parse(
                                'https://www.google.com/maps/search/?api=1&query=${offer.latitude},${offer.longitude}',
                              );
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri);
                              }
                            },
                            icon: const Icon(Icons.map_outlined, size: 18),
                            label: const Text('Open in Google Maps'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: accent,
                              side: BorderSide(color: accent.withOpacity(0.5)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Shifts ──────────────────────────────────────────────────
                  _SectionCard(
                    title: 'Shifts',
                    icon: Icons.schedule_outlined,
                    child: Column(
                      children: [
                        // Select all row
                        if (available.isNotEmpty) ...[
                          InkWell(
                            onTap: _toggleSelectAll,
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                children: [
                                  Icon(
                                    _allSelected
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank,
                                    size: 18,
                                    color: _allSelected
                                        ? accent
                                        : Colors.grey.shade400,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _allSelected
                                        ? 'Deselect all'
                                        : 'Select all (${available.length})',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: _allSelected
                                          ? accent
                                          : Colors.grey.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(height: 1, color: Colors.grey.shade200),
                          const SizedBox(height: 8),
                        ],
                        // Shift list
                        ...offer.shifts.asMap().entries.map((entry) {
                          final i = entry.key;
                          final s = entry.value;
                          final isSelected = _selectedShiftIds.contains(
                            s.shiftId,
                          );

                          return GestureDetector(
                            onTap: s.isAvailable
                                ? () => _toggleShift(s.shiftId)
                                : null,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? accent.withOpacity(0.08)
                                    : s.isAvailable
                                    ? Colors.grey.shade50
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? accent
                                      : Colors.grey.shade200,
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Number / check circle
                                  Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? accent
                                          : s.isAvailable
                                          ? Colors.grey.shade300
                                          : Colors.grey.shade200,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: isSelected
                                          ? const Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 16,
                                            )
                                          : Text(
                                              '${i + 1}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  // Date + time
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          s.date,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.access_time,
                                              size: 13,
                                              color: Colors.grey.shade500,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${s.startTime} – ${s.endTime}',
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Available / Taken badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: s.isAvailable
                                          ? Colors.green.shade100
                                          : Colors.red.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      s.isAvailable ? 'Available' : 'Taken',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: s.isAvailable
                                            ? Colors.green.shade700
                                            : Colors.red.shade700,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Apply button ─────────────────────────────────────────────
                  BlocBuilder<PswApplicationBloc, PswApplicationState>(
                    builder: (context, appState) {
                      final isLoading =
                          appState is PswApplicationMutationLoading;
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              workStatus == "Approved" &&
                                  !isLoading &&
                                  _selectedShiftIds.isNotEmpty
                              ? () => context.read<PswApplicationBloc>().add(
                                  ApplyForOfferEvent(
                                    offerId: offer.id,
                                    shiftIds: _selectedShiftIds.toList(),
                                  ),
                                )
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                              accent,
                            disabledBackgroundColor: Colors.grey.shade300,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  workStatus == "None" ||
                                          workStatus == "Pending"
                                      ? 'Account Pending Approval'
                                      : _selectedShiftIds.isEmpty
                                      ? 'Select Shifts to Apply'
                                      : 'Apply for ${_selectedShiftIds.length} Shift${_selectedShiftIds.length > 1 ? 's' : ''}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Quick Badge ──────────────────────────────────────────────────────────────

class _QuickBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _QuickBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 15, color: const Color(0xFF1A73E8)),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Section Card ─────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xFF1A73E8)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
