import 'package:flutter/material.dart';

class OfferCardMap extends StatelessWidget {
  final String title;
  final String subtitle; // address
  final double? hourlyRate;
  final double? distance;
  final String? posterName; // care home name
  final VoidCallback onTap;

  const OfferCardMap({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.hourlyRate,
    this.distance,
    this.posterName,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: const Border(
              left: BorderSide(color: Colors.blue, width: 4),
            ),
            boxShadow: const [
              BoxShadow(blurRadius: 8, color: Colors.black12),
            ],
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Title + rate badge ─────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (hourlyRate != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '\$${hourlyRate!.toStringAsFixed(0)}/H',
                        style: TextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w600,
                            fontSize: 12),
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 5),

              // ── Poster (care home) name ────────────────────────────────────
              if (posterName != null && posterName!.isNotEmpty)
                Row(
                  children: [
                    Icon(Icons.business_outlined,
                        size: 13, color: Colors.blue.shade400),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        posterName!,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade600,
                            fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 4),

              // ── Address ────────────────────────────────────────────────────
              Row(
                children: [
                  Icon(Icons.location_on_outlined,
                      size: 13, color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      subtitle,
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              // ── Distance ──────────────────────────────────────────────────
              if (distance != null) ...[
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(Icons.straighten,
                        size: 13, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(
                      '${distance!.toStringAsFixed(2)} km away',
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ],

              const Spacer(),

              // ── Tap hint ──────────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Tap to view details',
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.blue.shade400,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios,
                      size: 10, color: Colors.blue.shade400),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}