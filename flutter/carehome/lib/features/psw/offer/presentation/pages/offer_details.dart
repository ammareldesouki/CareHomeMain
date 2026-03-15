import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      builder: (_, controller) =>
          Container(
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
                    child: Text(state.detailError!,
                        style: const TextStyle(color: Colors.red)),
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

  const _OfferDetailBody({
    required this.controller,
    required this.detail,
  });

  @override
  State<_OfferDetailBody> createState() => _OfferDetailBodyState();
}

class _OfferDetailBodyState extends State<_OfferDetailBody> {
  final Set<String> _selectedShiftIds = {};

  static const accent = Color(0xFF1A73E8);

  // ── helpers ──────────────────────────────────────────────────────────────

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

  @override
  Widget build(BuildContext context) {
    final offer = widget.detail;
    final workStatus = NetworkDioHandler().currentWorkStatus;
    final available = _availableShifts;

    return BlocListener<PswApplicationBloc, PswApplicationState>(
      listener: (context, state) {
        if (state is PswApplicationMutationSuccess) {
          Navigator.pop(context);
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
      child: CustomScrollView(
        controller: widget.controller,
        slivers: [
          // ── App Bar ───────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: accent,
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [accent, Color(0xFF0D47A1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '\$${offer.hourlyRate.toStringAsFixed(0)}/hr',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          offer.title,
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.white),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          offer.address,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
                  // ── workStatus warning ──────────────────────────────────
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
                          Icon(Icons.warning_amber_rounded,
                              color: Colors.orange.shade700, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'You cannot apply until the admin approves your account.',
                              style: TextStyle(
                                  color: Colors.orange.shade800,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // ── Quick badges ────────────────────────────────────────
                  Row(
                    children: [
                      _QuickBadge(
                        icon: Icons.schedule_rounded,
                        label:
                        '${offer.shifts.length} Shift${offer.shifts.length != 1
                            ? 's'
                            : ''}',
                      ),
                      const SizedBox(width: 10),
                      _QuickBadge(
                        icon: Icons.check_circle_outline,
                        label: '${available.length} Available',
                      ),
                      const SizedBox(width: 10),
                      const _QuickBadge(
                          icon: Icons.location_on_outlined, label: 'On-site'),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ── Description ─────────────────────────────────────────
                  if (offer.description.isNotEmpty) ...[
                    _SectionCard(
                      title: 'About this offer',
                      icon: Icons.info_outline_rounded,
                      child: Text(
                        offer.description,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            height: 1.5),
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],

                  // ── Location ────────────────────────────────────────────
                  _SectionCard(
                    title: 'Location',
                    icon: Icons.apartment_rounded,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(offer.address,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        Row(children: [
                          Icon(Icons.location_on_outlined,
                              size: 15, color: Colors.grey.shade500),
                          const SizedBox(width: 4),
                          Text(
                            '${offer.latitude.toStringAsFixed(4)}, ${offer
                                .longitude.toStringAsFixed(4)}',
                            style: TextStyle(
                                color: Colors.grey.shade500, fontSize: 13),
                          ),
                        ]),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── Shifts ───────────────────────────────────────────────
                  _SectionCard(
                    title: workStatus == "Approved"
                        ? 'Select Shifts to Apply'
                        : 'Shifts',
                    icon: Icons.schedule_rounded,
                    child: Column(
                      children: [
                        // ── Select All / Deselect All ─────────────────────
                        if (workStatus == "Approved" &&
                            available.isNotEmpty) ...[
                          GestureDetector(
                            onTap: _toggleSelectAll,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 11),
                              decoration: BoxDecoration(
                                color: _allSelected
                                    ? accent.withOpacity(0.1)
                                    : Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: _allSelected
                                      ? accent
                                      : Colors.grey.shade300,
                                  width: _allSelected ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  // animated checkbox
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      color: _allSelected
                                          ? accent
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: _allSelected
                                            ? accent
                                            : Colors.grey.shade400,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: _allSelected
                                        ? const Icon(Icons.check,
                                        color: Colors.white, size: 14)
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      _allSelected
                                          ? 'Deselect All Shifts'
                                          : 'Select All Available Shifts  (${available
                                          .length})',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: _allSelected
                                            ? accent
                                            : Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                  // selected counter pill (shown when partial)
                                  if (!_allSelected &&
                                      _selectedShiftIds.isNotEmpty)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: accent.withOpacity(0.1),
                                        borderRadius:
                                        BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        '${_selectedShiftIds.length} selected',
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: accent,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],

                        // ── Individual shift tiles ─────────────────────────
                        ...offer.shifts
                            .asMap()
                            .entries
                            .map((entry) {
                          final i = entry.key;
                          final s = entry.value;
                          final isSelected =
                          _selectedShiftIds.contains(s.shiftId);

                          return GestureDetector(
                            onTap: workStatus == "Approved" && s.isAvailable
                                ? () => _toggleShift(s.shiftId)
                                : null,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              margin: EdgeInsets.only(top: i == 0 ? 0 : 10),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? accent.withOpacity(0.1)
                                    : s.isAvailable
                                    ? Colors.blue.shade50
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                                border: isSelected
                                    ? Border.all(color: accent, width: 1.5)
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  // checkbox / number badge
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? accent
                                          : s.isAvailable
                                          ? accent
                                          : Colors.grey,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: isSelected
                                          ? const Icon(Icons.check,
                                          color: Colors.white, size: 16)
                                          : Text(
                                        '${i + 1}',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),

                                  // date + time
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(s.date,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14)),
                                        const SizedBox(height: 3),
                                        Row(children: [
                                          Icon(Icons.access_time,
                                              size: 13,
                                              color: Colors.grey.shade500),
                                          const SizedBox(width: 4),
                                          Text(
                                              '${s.startTime} – ${s.endTime}',
                                              style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontSize: 13)),
                                        ]),
                                      ],
                                    ),
                                  ),

                                  // available / taken badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
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
                                          fontWeight: FontWeight.w600),
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

                  // ── Apply button ─────────────────────────────────────────
                  BlocBuilder<PswApplicationBloc, PswApplicationState>(
                    builder: (context, appState) {
                      final isLoading =
                      appState is PswApplicationMutationLoading;
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: workStatus == "Approved" &&
                              !isLoading &&
                              _selectedShiftIds.isNotEmpty
                              ? () =>
                              context.read<PswApplicationBloc>().add(
                                ApplyForOfferEvent(
                                  offerId: offer.id,
                                  shiftIds:
                                  _selectedShiftIds.toList(),
                                ),
                              )
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accent,
                            disabledBackgroundColor: Colors.grey.shade300,
                            padding:
                            const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          child: isLoading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2),
                          )
                              : Text(
                            workStatus == "None" || workStatus == "Pending"
                                ? 'Account Pending Approval'
                                : _selectedShiftIds.isEmpty
                                ? 'Select Shifts to Apply'
                                : 'Apply for ${_selectedShiftIds
                                .length} Shift${_selectedShiftIds.length > 1
                                ? 's'
                                : ''}',
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
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
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis),
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
  const _SectionCard(
      {required this.title, required this.icon, required this.child});

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
          Row(children: [
            Icon(icon, size: 18, color: const Color(0xFF1A73E8)),
            const SizedBox(width: 8),
            Text(title,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}