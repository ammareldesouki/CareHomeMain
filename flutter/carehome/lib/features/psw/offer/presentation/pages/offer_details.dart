// lib/features/psw/presentation/screens/psw_offer_details_screen.dart

import 'package:flutter/material.dart';

import '../../../../../core/data/fakedata.dart';
import '../../../../careHome/offers/data/models/offer_model.dart';
import '../../../account/data/models/model.dart';

class PswOfferDetailsScreen extends StatefulWidget {
  final OfferModel offer;

  const PswOfferDetailsScreen({super.key, required this.offer});

  @override
  State<PswOfferDetailsScreen> createState() => _PswOfferDetailsScreenState();
}

class _PswOfferDetailsScreenState extends State<PswOfferDetailsScreen> {
  bool get _alreadyApplied =>
      appliedJobs.any((j) => j.offerTitle == widget.offer.title);

  void _applyNow() {
    if (_alreadyApplied) return;
    setState(() {
      appliedJobs.add(AppliedJob(
        id: 'aj_${DateTime
            .now()
            .millisecondsSinceEpoch}',
        offerTitle: widget.offer.title,
        careHomeName: widget.offer.branch
            .split('–')
            .first
            .trim(),
        branch: widget.offer.branch.contains('–')
            ? widget.offer.branch
            .split('–')
            .last
            .trim()
            : widget.offer.branch,
        date: widget.offer.shifts.first.date,
        timeFrom: widget.offer.shifts.first.from,
        timeTo: widget.offer.shifts.first.to,
        hourlyRate: 15.0,
        appliedDate:
        '${DateTime
            .now()
            .year}-${DateTime
            .now()
            .month
            .toString()
            .padLeft(2, '0')}-${DateTime
            .now()
            .day
            .toString()
            .padLeft(2, '0')}',
        status: 'pending',
      ));
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle_outline, color: Colors.white),
            SizedBox(width: 10),
            Text('Application submitted successfully!'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final offer = widget.offer;
    final accent = const Color(0xFF1A73E8);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: CustomScrollView(
        slivers: [
          // ── App Bar ────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: accent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
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
                    padding:
                    const EdgeInsets.fromLTRB(20, 56, 20, 20),
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
                            offer.isActive ? 'Active' : 'Inactive',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(offer.title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5)),
                        const SizedBox(height: 4),
                        Text(
                          offer.branch
                              .split('–')
                              .first
                              .trim(),
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Body ───────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Quick Info Row ──────────────────────────────────────
                  Row(
                    children: [
                      _QuickBadge(
                          icon: Icons.people_outline,
                          label:
                          '${offer.applicationsCount} Applied'),
                      const SizedBox(width: 10),
                      _QuickBadge(
                          icon: Icons.calendar_today_outlined,
                          label: '${offer.shifts.length} Shift${offer.shifts
                              .length > 1 ? 's' : ''}'),
                      const SizedBox(width: 10),
                      _QuickBadge(
                          icon: Icons.location_on_outlined,
                          label: 'On-site'),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── Location ────────────────────────────────────────────
                  _SectionCard(
                    title: 'Location',
                    icon: Icons.apartment_rounded,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(offer.branch,
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined,
                                size: 15,
                                color: Colors.grey.shade500),
                            const SizedBox(width: 4),
                            Text(
                              '${offer.lat.toStringAsFixed(4)}, ${offer.lng
                                  .toStringAsFixed(4)}',
                              style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── Shifts ──────────────────────────────────────────────
                  _SectionCard(
                    title: 'Shifts',
                    icon: Icons.schedule_rounded,
                    child: Column(
                      children: offer.shifts
                          .asMap()
                          .entries
                          .map((e) {
                        final i = e.key;
                        final s = e.value;
                        return Container(
                          margin: EdgeInsets.only(
                              top: i == 0 ? 0 : 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: accent.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: accent.withOpacity(0.12)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: accent,
                                  borderRadius:
                                  BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text('${i + 1}',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight:
                                          FontWeight.bold)),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(s.date,
                                        style: const TextStyle(
                                            fontWeight:
                                            FontWeight.w600,
                                            fontSize: 14)),
                                    const SizedBox(height: 3),
                                    Row(
                                      children: [
                                        Icon(Icons.access_time,
                                            size: 13,
                                            color:
                                            Colors.grey.shade500),
                                        const SizedBox(width: 4),
                                        Text('${s.from} – ${s.to}',
                                            style: TextStyle(
                                                color: Colors
                                                    .grey.shade600,
                                                fontSize: 13)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── Requirements (static flavor) ─────────────────────────
                  _SectionCard(
                    title: 'Requirements',
                    icon: Icons.checklist_rounded,
                    child: Column(
                      children: [
                        _ReqItem('Valid DBS certificate'),
                        _ReqItem(
                            'NVQ Level 2 or above in Health & Social Care'),
                        _ReqItem('At least 1 year of care experience'),
                        _ReqItem('Right to work in the UK'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

      // ── Sticky Apply Button ─────────────────────────────────────────────
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: _alreadyApplied
              ? Container(
            height: 56,
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline,
                    color: Colors.green.shade700),
                const SizedBox(width: 8),
                Text('Already Applied',
                    style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w700,
                        fontSize: 16)),
              ],
            ),
          )
              : ElevatedButton(
            onPressed: _applyNow,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(56),
              backgroundColor: accent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: const Text('Apply Now',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700)),
          ),
        ),
      ),
    );
  }
}

class _QuickBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _QuickBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding:
        const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
          Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xFF1A73E8)),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _ReqItem extends StatelessWidget {
  final String text;

  const _ReqItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Icon(Icons.check,
                size: 11, color: Colors.green.shade700),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: TextStyle(
                    fontSize: 14, color: Colors.grey.shade700)),
          ),
        ],
      ),
    );
  }
}