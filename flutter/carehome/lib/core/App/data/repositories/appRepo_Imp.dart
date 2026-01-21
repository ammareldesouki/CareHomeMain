import 'package:carehome/core/App/data/data_sources/applocal_datasource.dart';

import '../../../theme/enum_theme.dart';
import '../../domain/repositories/appRepo.dart';

class ApprepoImpl implements ApprepoInterFace {
  final AppLocalDataSource local;

  ApprepoImpl(this.local);

  @override
  Future<AppTheme> getTheme() => local.getTheme();

  @override
  Future<void> saveTheme(AppTheme theme) =>
      local.saveTheme(theme);
}
