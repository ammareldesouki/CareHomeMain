
import 'package:shared_preferences/shared_preferences.dart';

import '../../../theme/enum_theme.dart';



class AppLocalDataSource {
  static const _key = 'app_theme';

  Future<void> saveTheme(AppTheme theme) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_key, theme.name);
  }

  Future<AppTheme> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString(_key);
    return AppTheme.values.firstWhere(
          (e) => e.name == theme,
      orElse: () => AppTheme.system,
    );
  }
}
