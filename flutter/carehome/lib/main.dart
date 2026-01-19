import 'package:flutter/material.dart';

import 'core/route/app_route.dart';
import 'core/route/route_name.dart';
import 'core/theme/theme.dart';
import 'features/splash/splash.dart';

void main() async {



  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,


      initialRoute: RouteNames.splash,
      onGenerateRoute: AppRouter.generateRoute,
      home:SplashScreen(),
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightAppTheme,
      darkTheme: TAppTheme.darkAppTheme,
    );
  }
}
