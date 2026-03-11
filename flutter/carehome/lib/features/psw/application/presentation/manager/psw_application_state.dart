part of 'psw_application_bloc.dart';

@immutable
sealed class PswApplicationState {}

class PswApplicationInitial extends PswApplicationState {}

// ── List states ───────────────────────────────────────────────────────────────
class PswApplicationsLoading extends PswApplicationState {}

class PswApplicationsLoaded extends PswApplicationState {
  final List<PswApplicationEntity> applications;

  PswApplicationsLoaded(this.applications);
}

class PswApplicationsError extends PswApplicationState {
  final String message;

  PswApplicationsError(this.message);
}

// ── Mutation states (apply / cancel) ─────────────────────────────────────────
class PswApplicationMutationLoading extends PswApplicationState {}

class PswApplicationMutationSuccess extends PswApplicationState {
  final String message;

  PswApplicationMutationSuccess(this.message);
}

class PswApplicationMutationError extends PswApplicationState {
  final String message;

  PswApplicationMutationError(this.message);
}
