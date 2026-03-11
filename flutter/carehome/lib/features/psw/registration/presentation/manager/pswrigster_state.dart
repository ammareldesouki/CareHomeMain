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
  final Map<String, String> documents; // key → filePath
  final IdType selectedIdType;
  final bool isLoading;
  final bool isSubmitted;
  final String? error;

  const PswRegistrationState({
    this.documents = const {},
    this.selectedIdType = IdType.nationalId,
    this.isLoading = false,
    this.isSubmitted = false,
    this.error,
  });

  PswRegistrationState copyWith({
    Map<String, String>? documents,
    IdType? selectedIdType,
    bool? isLoading,
    bool? isSubmitted,
    String? error,
    bool clearError = false,
  }) {
    return PswRegistrationState(
      documents: documents ?? this.documents,
      selectedIdType: selectedIdType ?? this.selectedIdType,
      isLoading: isLoading ?? this.isLoading,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      error: clearError ? null : (error ?? this.error),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────

  String? getDocumentPath(PswDocumentType type, {bool isFront = true}) {
    final key = _key(type, isFront: isFront);
    print(key);
    return documents[key];
  }

  bool isDocumentUploaded(PswDocumentType type, {bool isFront = true}) {
    print(getDocumentPath(type, isFront: isFront));
    return getDocumentPath(type, isFront: isFront) != null;
  }

  static String _key(PswDocumentType type, {bool isFront = true}) {
    if (type == PswDocumentType.proofOfId) {
      return isFront ? 'proofOfId_front' : 'proofOfId_back';
    }
    return type.name;
  }
}
