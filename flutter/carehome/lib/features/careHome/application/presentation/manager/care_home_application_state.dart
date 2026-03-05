part of 'care_home_application_bloc.dart';

@immutable
sealed class CareHomeApplicationState {}

class CareHomeApplicationInitial extends CareHomeApplicationState {}

class CareHomeApplicationsLoading extends CareHomeApplicationState {}

class CareHomeApplicationsLoaded extends CareHomeApplicationState {
  final List<CareHomeApplicationEntity> applications;

  CareHomeApplicationsLoaded(this.applications);
}

class CareHomeApplicationsError extends CareHomeApplicationState {
  final String message;

  CareHomeApplicationsError(this.message);
}

class CareHomeApplicationMutationLoading extends CareHomeApplicationState {}

class CareHomeApplicationMutationSuccess extends CareHomeApplicationState {
  final String message;

  CareHomeApplicationMutationSuccess(this.message);
}

class CareHomeApplicationMutationError extends CareHomeApplicationState {
  final String message;

  CareHomeApplicationMutationError(this.message);
}
