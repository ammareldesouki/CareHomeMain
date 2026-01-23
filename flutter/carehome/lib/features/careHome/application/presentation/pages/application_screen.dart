import 'package:carehome/features/careHome/application/presentation/widgets/application%20list.dart';
import 'package:flutter/material.dart';

class ApplictionScreen extends StatelessWidget {
  const ApplictionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Applications'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Accepted'),
              Tab(text: 'Expired'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ApplicationList(status: 'pending'),
            ApplicationList(status: 'accepted'),
            ApplicationList(status: 'expired'),
          ],
        ),
      ),
    );
  }
}
