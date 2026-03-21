part of 'pswrigster_bloc.dart';

abstract class PswRegistrationEvent {}

// ── Step 1: register account ─────────────────────────────────────────────────
class RegisterPswEvent extends PswRegistrationEvent {
  final PswRegisterRequest request;

  RegisterPswEvent(this.request);
}

// ── Step 2: document upload ──────────────────────────────────────────────────
class SelectIdTypeEvent extends PswRegistrationEvent {
  final IdType idType;
  SelectIdTypeEvent(this.idType);
}

class SetWorkStatusEvent extends PswRegistrationEvent {
  final bool workStatus;

  SetWorkStatusEvent(this.workStatus);
}

class UploadDocumentEvent extends PswRegistrationEvent {
  final PswDocumentType documentType;
  final String filePath;
  final bool isFront;

  UploadDocumentEvent({
    required this.documentType,
    required this.filePath,
    this.isFront = true,
  });
}

class RemoveDocumentEvent extends PswRegistrationEvent {
  final PswDocumentType documentType;
  final bool isFront;
  RemoveDocumentEvent({required this.documentType, this.isFront = true});
}

class SubmitDocumentsEvent extends PswRegistrationEvent {}