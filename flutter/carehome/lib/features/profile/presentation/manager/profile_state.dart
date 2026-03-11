part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class PswProfileLoaded extends ProfileState {
  final PswProfileEntity profile;

  PswProfileLoaded(this.profile);
}

final class AdminProfileLoading extends ProfileState {}

final class AdminProfileLoaded extends ProfileState {
  final AdminProfileEntity profile;

  AdminProfileLoaded(this.profile);
}

final class CareHomeProfileLoaded extends ProfileState {
  final CareHomeProfileEntity profile;

  CareHomeProfileLoaded(this.profile);
}

final class ProfileUpdating extends ProfileState {
  final dynamic currentProfile;

  ProfileUpdating(this.currentProfile);
}

final class ProfileUpdateSuccess extends ProfileState {
  final dynamic updatedProfile;
  final String message;

  ProfileUpdateSuccess({
    required this.updatedProfile,
    this.message = 'Profile updated successfully',
  });
}

final class ProfileDocumentUpdateSuccess extends ProfileState {
  final String documentType;

  ProfileDocumentUpdateSuccess(this.documentType);
}

final class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}

final class ProfileUpdateError extends ProfileState {
  final String message;
  final dynamic currentProfile;

  ProfileUpdateError({required this.message, this.currentProfile});
}
