import 'package:carehome/features/admin/presentation/pages/admin_account_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../manager/admin_bloc.dart';
import 'admin_applications_screen.dart';
import 'admin_offers_screen.dart';
import 'admin_verifications_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminBloc()
        ..add(FetchPendingVerificationsEvent())
        ..add(FetchPendingApplicationsEvent())
        ..add(FetchAllOffersEvent()),
      child: _AdminDashboardBody(
        currentIndex: _currentIndex,
        onTabChanged: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

class _AdminDashboardBody extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChanged;

  const _AdminDashboardBody({
    required this.currentIndex,
    required this.onTabChanged,
  });

  static final _screens = [
    const AdminVerificationsScreen(),
    const AdminApplicationsScreen(),
    const AdminOffersScreen(),
    AdminAccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (i) {
            onTabChanged(i);
            final bloc = context.read<AdminBloc>();
            switch (i) {
              case 0:
                bloc.add(FetchPendingVerificationsEvent());
                break;
              case 1:
                bloc.add(FetchPendingApplicationsEvent());
                break;
              case 2:
                bloc.add(FetchAllOffersEvent());
                break;
            }
          },
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF1A73E8),
          unselectedItemColor: Colors.grey.shade500,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 11,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.verified_user_outlined),
              activeIcon: Icon(Icons.verified_user),
              label: 'Verifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined),
              activeIcon: Icon(Icons.assignment),
              label: 'Applications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_work_outlined),
              activeIcon: Icon(Icons.home_work),
              label: 'Offers',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              activeIcon: Icon(Icons.person),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}
