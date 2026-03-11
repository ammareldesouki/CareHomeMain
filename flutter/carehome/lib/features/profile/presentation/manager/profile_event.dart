part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

class LoadProfileEvent extends ProfileEvent {}

class UpdatePswProfileEvent extends ProfileEvent {
  final Map<String, dynamic> data;

  UpdatePswProfileEvent(this.data);
}

class UpdateCareHomeProfileEvent extends ProfileEvent {
  final Map<String, dynamic> data;

  UpdateCareHomeProfileEvent(this.data);
}

class UpdatePswDocumentEvent extends ProfileEvent {
  final String documentType;
  final String filePath;

  UpdatePswDocumentEvent({required this.documentType, required this.filePath});
}
