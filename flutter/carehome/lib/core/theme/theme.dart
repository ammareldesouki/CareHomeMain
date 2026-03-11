import 'package:flutter/material.dart';

import '../constants/colors.dart';
import 'widget_themes/bottom_sheet_theme.dart';
import 'widget_themes/elevated_button_theme.dart';
import 'widget_themes/text_field_theme.dart';
import 'widget_themes/text_theme.dart';

class TAppTheme {
  TAppTheme._();

  static ThemeData darkAppTheme = ThemeData(
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    scaffoldBackgroundColor: TColors.darkBackground,
    fontFamily: 'Inter',
    primaryColor: TColors.primary,
    textTheme: TTextTheme.darkTextTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
    bottomNavigationBarTheme: BottomNavTheme.dark,

    inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme,
  );
  static ThemeData lightAppTheme = ThemeData(
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    ),
    scaffoldBackgroundColor: TColors.lightBackground,
    fontFamily: 'Inter',
    primaryColor: TColors.primary,
    textTheme: TTextTheme.lightTextTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    bottomNavigationBarTheme: BottomNavTheme.dark,

    inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme,
  );
}
