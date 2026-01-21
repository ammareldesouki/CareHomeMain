

import 'package:carehome/core/App/domain/repositories/appRepo.dart';

import '../../../theme/enum_theme.dart';

class GetThemeUseCase {
  final ApprepoInterFace repo;
  GetThemeUseCase(this.repo);

  Future<AppTheme> call() => repo.getTheme();
}

class SaveThemeUseCase {
  final ApprepoInterFace repo;
  SaveThemeUseCase(this.repo);

  Future<void> call(AppTheme theme) => repo.saveTheme(theme);
}
