part of 'care_home_registration_bloc.dart';

abstract class CareHomeRegistrationEvent {}

/// IndividualForm / MultipleCareHomeForm — every field change
class UpdateFormFieldEvent extends CareHomeRegistrationEvent {
  final String fieldName;
  final String value;

  UpdateFormFieldEvent({required this.fieldName, required this.value});
}

/// MultipleCareHomeForm — document file upload
class UploadOrgDocumentEvent extends CareHomeRegistrationEvent {
  final String documentKey;
  final String filePath;

  UploadOrgDocumentEvent({required this.documentKey, required this.filePath});
}

/// MultipleCareHomeForm — vaccination toggle switches
class ToggleVaccinationPolicyEvent extends CareHomeRegistrationEvent {
  final String policyType;
  final bool value;

  ToggleVaccinationPolicyEvent({required this.policyType, required this.value});
}

/// TermsAndConditionsScreen — checkbox
class AcceptTermsEvent extends CareHomeRegistrationEvent {
  final bool accepted;

  AcceptTermsEvent(this.accepted);
}

/// TermsAndConditionsScreen — Continue button
class NextRegistrationStepEvent extends CareHomeRegistrationEvent {}

/// RegistrationContractScreen — Sign & Continue button
class SignContractEvent extends CareHomeRegistrationEvent {}

/// Called after contract is signed — fires the real API call
class SubmitRegistrationEvent extends CareHomeRegistrationEvent {
  final EmployerType employerType;

  SubmitRegistrationEvent(this.employerType);
}
