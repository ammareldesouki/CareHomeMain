import 'package:flutter/material.dart';


import '../../features/auth/presentation/pages/forget_password.dart';
import '../../features/auth/presentation/pages/login.dart';
import '../../features/auth/presentation/pages/register.dart';
import '../../features/layout/bottom_navegation_bar.dart';
import '../../features/on_boarding/presentation/pages/on_boarding.dart';
import '../../features/splash/splash.dart';
import 'route_name.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case RouteNames.splash:
        return MaterialPageRoute(
          builder: (_) => SplashScreen(),
          settings: settings,
        );
      case RouteNames.onBoarding:
        return MaterialPageRoute(
          builder: (_) => OnboardingScreen(),
          settings: settings,
        );

      // case RouteNames.layout:
      //   return MaterialPageRoute(
      //     builder: (_) => CBottomNavigationBar(role: 2,),
      //     settings: settings,
      //   );
      case RouteNames.login:
        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
          settings: settings,
        );
      case RouteNames.register:
        return MaterialPageRoute(
          builder: (_) => SignUpScreen(),
          settings: settings,
        );
      // case RouteNames.courses:
      //   return MaterialPageRoute(
      //     builder: (_) => CoursesScreen(),
      //     settings: settings,
      //   );
      // case RouteNames.forgetPassword:
      //   return MaterialPageRoute(
      //     builder: (_) => ForgetPasswordScreen(),
      //     settings: settings,
      //   );
      // case RouteNames.Mycourses:
      //   return MaterialPageRoute(
      //     builder: (_) => MyCoursesScreen(),
      //     settings: settings,
      //   );
      //
      // case RouteNames.profile:
      //   return MaterialPageRoute(builder:
      //       (_) => AccountScreen(),
      //       settings: settings
      //   );
      default:
        return MaterialPageRoute(
          builder: (_) =>
              Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              ),
        );
    }
  }
}
