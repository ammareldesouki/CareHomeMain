part of 'pswrigster_bloc.dart';

enum IdType { nationalId, passport, driversLicense }

extension IdTypeExt on IdType {
  String get label {
    switch (this) {
      case IdType.nationalId:
        return 'National ID';
      case IdType.passport:
        return 'Passport';
      case IdType.driversLicense:
        return "Driver's License";
    }
  }

  String get apiValue {
    switch (this) {
      case IdType.nationalId:
        return 'NationalId';
      case IdType.passport:
        return 'Passport';
      case IdType.driversLicense:
        return 'DriversLicense';
    }
  }
}

class PswRegistrationState {
  final Map<String, String> documents;
  final IdType selectedIdType;
  final bool workStatus; // ✅ actual work status from UI
  final bool isLoading;
  final bool isRegistered; // ✅ true after registerPsw succeeds
  final bool isSubmitted; // true after completeProfile succeeds
  final String? error;

  const PswRegistrationState({
    this.documents = const {},
    this.selectedIdType = IdType.nationalId,
    this.workStatus = false,
    this.isLoading = false,
    this.isRegistered = false,
    this.isSubmitted = false,
    this.error,
  });

  PswRegistrationState copyWith({
    Map<String, String>? documents,
    IdType? selectedIdType,
    bool? workStatus,
    bool? isLoading,
    bool? isRegistered,
    bool? isSubmitted,
    String? error,
    bool clearError = false,
  }) {
    return PswRegistrationState(
      documents: documents ?? this.documents,
      selectedIdType: selectedIdType ?? this.selectedIdType,
      workStatus: workStatus ?? this.workStatus,
      isLoading: isLoading ?? this.isLoading,
      isRegistered: isRegistered ?? this.isRegistered,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      error: clearError ? null : (error ?? this.error),
    );
  }

  String? getDocumentPath(PswDocumentType type, {bool isFront = true}) {
    return documents[_key(type, isFront: isFront)];
  }

  bool isDocumentUploaded(PswDocumentType type, {bool isFront = true}) {
    return getDocumentPath(type, isFront: isFront) != null;
  }

  static String _key(PswDocumentType type, {bool isFront = true}) {
    if (type == PswDocumentType.proofOfId) {
      return isFront ? 'proofOfId_front' : 'proofOfId_back';
    }
    return type.name;
  }
}