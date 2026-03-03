// lib/features/careHome/application/presentation/screens/application_screen.dart

import 'package:flutter/material.dart';
import '../../../../psw/application/presentation/widgets/application list.dart';

class ApplictionScreen extends StatelessWidget {
  const ApplictionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ─────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Applications',
                        style: Theme
                            .of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w800)),
                    Text('Review & respond to applicants',
                        style: TextStyle(color: Colors.grey.shade500)),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const TabBar(
                        indicator: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        labelColor: Colors.black87,
                        unselectedLabelColor: Colors.grey,
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                        tabs: [
                          Tab(text: 'Pending'),
                          Tab(text: 'Accepted'),
                          Tab(text: 'Expired'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // ── Tab views ───────────────────────────────────────────────
              const Expanded(
                child: TabBarView(
                  children: [
                    ApplicationList(status: 'pending'),
                    ApplicationList(status: 'accepted'),
                    ApplicationList(status: 'expired'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}