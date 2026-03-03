import 'package:carehome/features/careHome/application/presentation/widgets/application_card.dart';
import 'package:flutter/material.dart';

import '../../../../../core/data/fakedata.dart';

class ApplicationList extends StatelessWidget {
  final String status;

  const ApplicationList({required this.status});

  @override
  Widget build(BuildContext context) {
    final filteredList = applications
        .where((app) => app.status == status)
        .toList();

    if (filteredList.isEmpty) {
      return const Center(
        child: Text('No applications found', style: TextStyle(fontSize: 16)),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: filteredList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final app = filteredList[index];

        return ApplicationCard(
          name: app.name,
          email: app.email,
          position: app.position,
          appliedDate: app.appliedDate,
          status: app.status,
        );
      },
    );
  }
}
