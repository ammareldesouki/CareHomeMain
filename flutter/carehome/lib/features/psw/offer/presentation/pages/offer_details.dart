import 'package:carehome/core/models/care_home.dart';
import 'package:flutter/material.dart';

class OfferDetailsBottomSheet extends StatelessWidget {
  final CareHomeData careHomeData;

  const OfferDetailsBottomSheet({
    super.key,
    required this.careHomeData,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Offer Details",
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),

                const Divider(),

                /// Care Home Info
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.blue.withOpacity(0.2),
                      child: Text(
                        careHomeData.name.substring(0, 2).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          careHomeData.name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "Riyadh - Certified",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    )
                  ],
                ),

                const SizedBox(height: 20),

                _infoRow(
                  Icons.location_on,
                  "Location",
                  "Toronto, ON",
                ),

                _infoRow(
                  Icons.work,
                  "Requirements",
                  "PSW Degree include 5 years",
                ),

                _infoRow(
                  Icons.attach_money,
                  "Expected Rate",
                  "\$${careHomeData.salaryPerHour}/hour",
                ),

                const SizedBox(height: 24),

                /// Shifts
                Text(
                  "Shifts",
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                CheckboxListTile(
                  value: false,
                  onChanged: (_) {},
                  title: const Text("Select All"),
                  controlAffinity: ListTileControlAffinity.leading,
                ),

                ...careHomeData.appointments.map((e) {
                  return CheckboxListTile(
                    value: false,
                    onChanged: (_) {},
                    title: Text(e.day),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: e.timeSlots.map((slot) {
                        return Row(
                          children: [
                            Icon(
                              slot.isAvailable ? Icons.check_circle : Icons
                                  .cancel,
                              size: 14,
                              color: slot.isAvailable ? Colors.green : Colors
                                  .red,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "${slot.from} - ${slot.to}",
                              style: TextStyle(
                                color: slot.isAvailable ? Colors.green : Colors
                                    .red,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                }),

                const SizedBox(height: 24),

                /// Buttons
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                  ),
                  onPressed: () {},
                  child: const Text("Apply"),
                ),

                const SizedBox(height: 12),

                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                  ),
                  onPressed: () {},
                  child: const Text("MESSAGE"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _infoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Text(value,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          )
        ],
      ),
    );
  }
}
