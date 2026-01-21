// import 'package:bloc/bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:meta/meta.dart';
//
// import '../../../theme/enum_theme.dart';
// import '../../domain/use_cases/theme_uescase.dart';
//
// part 'app_event.dart';
// part 'app_state.dart';
//
// class AppBloc extends Bloc<AppEvent, AppState> {
//   AppBloc() : super(AppInitial()) {
//     on<AppEvent>((event, emit) {
//       // TODO: implement event handler
//     });
//   }
// }
//
//
// class ThemeBloc extends Bloc<AppEvent, AppState> {
//   final GetThemeUseCase getTheme;
//   final SaveThemeUseCase saveTheme;
//
//   ThemeBloc(this.getTheme, this.saveTheme)
//       : super(ThemeState(
//     mode: ThemeMode.system,
//     selected: AppTheme.system,
//   )) {
//     on<LoadTheme>(_onLoadTheme);
//     on<ChangeTheme>(_onChangeTheme);
//   }
//
//   Future<void> _onLoadTheme(
//       LoadTheme event, Emitter<ThemeState> emit) async {
//     final theme = await getTheme();
//     emit(_mapTheme(theme));
//   }
//
//   Future<void> _onChangeTheme(
//       ChangeTheme event, Emitter<ThemeState> emit) async {
//     await saveTheme(event.theme);
//     emit(_mapTheme(event.theme));
//   }
//
//   ThemeState _mapTheme(AppTheme theme) {
//     switch (theme) {
//       case AppTheme.light:
//         return ThemeState(mode: ThemeMode.light, selected: theme);
//       case AppTheme.dark:
//         return ThemeState(mode: ThemeMode.dark, selected: theme);
//       default:
//         return ThemeState(mode: ThemeMode.system, selected: theme);
//     }
//   }
// }
