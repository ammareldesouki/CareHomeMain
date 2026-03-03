part of 'pswrigster_bloc.dart';

abstract class PswRegistrationEvent {}

class SelectIdTypeEvent extends PswRegistrationEvent {
  final IdType idType;

  SelectIdTypeEvent(this.idType);
}

class SubmitDocumentsEvent extends PswRegistrationEvent {}

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
