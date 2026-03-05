import 'package:carehome/features/careHome/account/presentation/pages/account.dart';
import 'package:carehome/features/psw/application/presentation/manager/psw_application_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/colors.dart';
import '../careHome/application/presentation/pages/application_screen.dart';
import '../careHome/offers/presentation/pages/offers.dart';
import '../home/presentation/pages/home.dart';
import '../map/presentation/pages/map.dart';
import '../psw/account/presentation/pages/account.dart';
import '../psw/application/presentation/pages/application_screen.dart';
import '../psw/offer/presentation/manager/offers_bloc.dart';

class CBottomNavigationBar extends StatefulWidget {
  final String role;
  const CBottomNavigationBar({super.key, required this.role});

  @override
  State<CBottomNavigationBar> createState() => _CBottomNavigationBarState();
}

class _CBottomNavigationBarState extends State<CBottomNavigationBar> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.role == 'PSW') return _buildPsw();
    return _buildCareHome();
  }

  // ── PSW layout ─────────────────────────────────────────────────────────────
  Widget _buildPsw() {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) =>
            OffersBloc()
              ..add(FetchOffersEvent())),
        BlocProvider(
            create: (_) =>
            PswApplicationBloc()
              ..add(FetchMyApplicationsEvent())),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FB),
        // IndexedStack keeps every screen alive — tab switches are instant
        // and state (scroll position, map markers, bloc data) is preserved
        body: SafeArea(
          bottom: false,
          child: IndexedStack(
            index: _index,
            children: const [
              HomeScreen(), // pure content widget — no inner Scaffold
              MapScreen(), // pure content widget — no inner Scaffold
              PswAppliedScreen(),
              PswAccountScreen(),
            ],
          ),
        ),
        bottomNavigationBar: _navBar(
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.search_rounded),
                activeIcon: Icon(Icons.search_rounded),
                label: 'Search'),
            BottomNavigationBarItem(
                icon: Icon(Icons.map_outlined),
                activeIcon: Icon(Icons.map_rounded),
                label: 'Map'),
            BottomNavigationBarItem(
                icon: Icon(Icons.badge_outlined),
                activeIcon: Icon(Icons.badge_rounded),
                label: 'Applied'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_rounded),
                activeIcon: Icon(Icons.person_rounded),
                label: 'Account'),
          ],
        ),
      ),
    );
  }

  // ── CareHome layout ────────────────────────────────────────────────────────
  Widget _buildCareHome() {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _index,
          children: const [
            OfferScreen(),
            ApplictionScreen(),
            PswAccountScreen(),
          ],
        ),
      ),
      bottomNavigationBar: _navBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.work_outline_rounded),
              activeIcon: Icon(Icons.work_rounded),
              label: 'Offers'),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_outline_rounded),
              activeIcon: Icon(Icons.people_rounded),
              label: 'Requests'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Account'),
        ],
      ),
    );
  }

  // ── Shared nav bar ─────────────────────────────────────────────────────────
  Widget _navBar({required List<BottomNavigationBarItem> items}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -4)),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        backgroundColor: Colors.white,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: TColors.primarIconColor,
        unselectedItemColor: TColors.secondryIconColor,
        selectedLabelStyle:
        const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle:
        const TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: items,
      ),
    );
  }
}