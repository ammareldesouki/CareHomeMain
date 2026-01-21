
import '../../../theme/enum_theme.dart';

abstract class ApprepoInterFace {
  Future<AppTheme> getTheme();
  Future<void> saveTheme(AppTheme theme);
}


