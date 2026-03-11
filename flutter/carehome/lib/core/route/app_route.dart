import 'package:carehome/features/psw/registration/presentation/pages/register_form.dart'
    hide PswVerificationScreen;
import 'package:flutter/material.dart';

import '../../features/admin/presentation/pages/admin_dashboard.dart';
import '../../features/careHome/registration/presentation/pages/organization_register_screen.dart';
import '../../features/careHome/registration/presentation/pages/psw_preference_screen.dart';
import '../../features/auth/presentation/pages/login.dart';
import '../../features/auth/presentation/pages/choose-account-type.dart';
import '../../features/on_boarding/presentation/pages/on_boarding.dart';
import '../../features/psw/registration/presentation/pages/psw_verification_screen.dart';
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
      case RouteNames.login:
        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
          settings: settings,
        );
      case RouteNames.PSWregister:
        return MaterialPageRoute(
          builder: (_) => PSWSignUpScreen(),
          settings: settings,
        );
      case RouteNames.swithchRule:
        return MaterialPageRoute(
          builder: (_) => ChooseAccountTypeScreen(),
          settings: settings,
        );
      case RouteNames.registerOrganization:
        return MaterialPageRoute(
          builder: (_) => OrganizationRegisterScreen(),
          settings: settings,
        );
      case RouteNames.pswVerification:
        return MaterialPageRoute(
          builder: (_) => const PswVerificationScreen(),
          settings: settings,
        );
      case RouteNames.pswPreference:
        return MaterialPageRoute(
          builder: (_) => const PswPreferenceScreen(),
          settings: settings,
        );
      case RouteNames.adminDashboard:
        return MaterialPageRoute(
          builder: (_) => const AdminDashboard(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
