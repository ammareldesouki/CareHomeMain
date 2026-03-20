import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../psw/application/presentation/manager/psw_application_bloc.dart';
import '../../../psw/offer/domain/entities/offer_entity.dart';
import '../../../psw/offer/presentation/manager/offers_bloc.dart';
import '../../../psw/offer/presentation/pages/offer_details.dart';

class OfferListCard extends StatelessWidget {
  final OfferListItemEntity offer;
  final double? distance;

  const OfferListCard({super.key, required this.offer, this.distance});

  bool get _isIndividual =>
      offer.posterType.toLowerCase() == 'individual';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          context.read<OffersBloc>().add(FetchOfferDetailEvent(offer.id));
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) =>
                MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: context.read<OffersBloc>()),
                    BlocProvider.value(
                        value: context.read<PswApplicationBloc>()),
                  ],
                  child: const OfferDetailSheet(),
                ),
          );
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border(
              left: BorderSide(
                color: _isIndividual
                    ? Colors.deepPurple.shade400
                    : Colors.blue,
                width: 5,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Row 1: Rate · Title · Distance ──────────────────────────
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      child: Text(
                        '\$${offer.hourlyRate.toStringAsFixed(0)}/H',
                        style: TextStyle(
                            color: _isIndividual
                                ? Colors.deepPurple.shade700
                                : Colors.blue.shade700,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        offer.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (distance != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.location_on,
                                size: 14, color: Colors.blue.shade600),
                            const SizedBox(width: 4),
                            Text(
                              '${distance!.toStringAsFixed(1)} km',
                              style: TextStyle(
                                  color: Colors.blue.shade600,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 8),

                // ── Row 2: Poster name + type badge ─────────────────────────
                Row(
                  children: [
                    Icon(
                      _isIndividual
                          ? Icons.person_outline
                          : Icons.business_outlined,
                      size: 14,
                      color: _isIndividual
                          ? Colors.deepPurple.shade400
                          : Colors.blue.shade400,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        offer.posterName.isNotEmpty
                            ? offer.posterName
                            : 'Unknown',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: _isIndividual
                              ? Colors.deepPurple.shade600
                              : Colors.blue.shade600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Poster type pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _isIndividual
                            ? Colors.deepPurple.withOpacity(0.08)
                            : Colors.blue.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _isIndividual
                              ? Colors.deepPurple.shade200
                              : Colors.blue.shade200,
                        ),
                      ),
                      child: Text(
                        offer.posterType,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: _isIndividual
                              ? Colors.deepPurple.shade600
                              : Colors.blue.shade600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // ── Row 3: Address ───────────────────────────────────────────
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 15, color: Colors.grey),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        offer.address,
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 13),
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
    );
  }
}