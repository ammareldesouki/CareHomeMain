part of 'care_home_registration_bloc.dart';

class CareHomeRegistrationState {
  // ── Form data ──────────────────────────────────────────────────────────────
  final Map<String, String> fields;
  final Map<String, String> uploadedDocuments;
  final Map<String, bool> vaccinationPolicy;
  final EmployerType? employerType;

  // ── Wizard steps ───────────────────────────────────────────────────────────
  final bool isTermsAccepted; // TermsAndConditionsScreen checkbox
  final bool isContractSigned; // RegistrationContractScreen checkbox

  // ── API status ─────────────────────────────────────────────────────────────
  final bool isLoading;
  final bool isSuccess;
  final String? error; // used by TermsScreen  (state.error)
  final String? errorMessage; // used by OrganizationScreen snackbar
  final UserEntity? registeredUser;

  const CareHomeRegistrationState({
    this.fields = const {},
    this.uploadedDocuments = const {},
    this.vaccinationPolicy = const {'covid': false, 'flu': false},
    this.employerType,
    this.isTermsAccepted = false,
    this.isContractSigned = false,
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
    this.errorMessage,
    this.registeredUser,
  });

  CareHomeRegistrationState copyWith({
    Map<String, String>? fields,
    Map<String, String>? uploadedDocuments,
    Map<String, bool>? vaccinationPolicy,
    EmployerType? employerType,
    bool? isTermsAccepted,
    bool? isContractSigned,
    bool? isLoading,
    bool? isSuccess,
    String? error,
    String? errorMessage,
    UserEntity? registeredUser,
    bool clearError = false,
  }) {
    return CareHomeRegistrationState(
      fields: fields ?? this.fields,
      uploadedDocuments: uploadedDocuments ?? this.uploadedDocuments,
      vaccinationPolicy: vaccinationPolicy ?? this.vaccinationPolicy,
      employerType: employerType ?? this.employerType,
      isTermsAccepted: isTermsAccepted ?? this.isTermsAccepted,
      isContractSigned: isContractSigned ?? this.isContractSigned,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: clearError ? null : (error ?? this.error),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      registeredUser: registeredUser ?? this.registeredUser,
    );
  }
}
