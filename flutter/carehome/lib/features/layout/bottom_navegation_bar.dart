import 'package:carehome/features/auth/presentation/pages/forget_password.dart';
import 'package:carehome/features/auth/presentation/pages/login.dart';
import 'package:carehome/features/auth/presentation/pages/register.dart';
import 'package:carehome/features/home/presentation/pages/home.dart';
import 'package:carehome/features/splash/splash.dart';
import 'package:flutter/material.dart';


import '../../core/constants/colors.dart';
import '../../core/constants/image_strings.dart';

class CBottomNavigationBar extends StatefulWidget {
  const CBottomNavigationBar({super.key});

  @override
  State<CBottomNavigationBar> createState() => _CBottomNavigationBarState();
}

class _CBottomNavigationBarState extends State<CBottomNavigationBar> {
  int _screenIndex = 0;

  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return HomeScreen();
      case 1:
        return SignUpScreen();
      case 2:
        return ForgetPasswordScreen();
      case 3 :
        return SplashScreen();
      case 4:
        return LoginScreen();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(bottom: 70.0),
          child: _getScreen(_screenIndex),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BottomNavigationBar(
                currentIndex: _screenIndex,
                onTap: (index) => setState(() => _screenIndex = index),
                backgroundColor: TColors.lightBackground,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: TColors.primarIconColor,
                unselectedItemColor: TColors.secondryIconColor,
                selectedLabelStyle: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
                // unselectedLabelStyle: TextStyle(
                //   fontSize: 14,
                //   fontWeight: FontWeight.w500,
                // ),
                items: [
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.search),
                    label:"Search",
                    activeIcon: const Icon(Icons.search),
                  ),
                  BottomNavigationBarItem(
                    icon:  Icon(Icons.watch_later_outlined),

                    label:"Appoitments",
                    activeIcon: Icon(Icons.watch_later_outlined),

          ),

                  BottomNavigationBarItem(
                    icon: const Icon(Icons.bookmark,),
                    label:"home",
                    activeIcon: const Icon(Icons.bookmark),
                  ),

                  BottomNavigationBarItem(
                    icon: const Icon(Icons.shopping_cart),
                    label:"home",
                    activeIcon: const Icon(Icons.shopping_cart),
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.account_circle),
                    label:"home",
                    activeIcon: const Icon(Icons.account_circle),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
