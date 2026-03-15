class AdminPswVerificationEntity {
  final String pswId;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String proofIdentityType;
  final String submittedAt;
  final String proofIdentityFileId;
  final String pswCertificateFileId;
  final String cvFileId;
  final String immunizationRecordFileId;
  final String criminalRecordFileId;
  final String firstAidOrCprFileId;
  final String verificationStatus;

  const AdminPswVerificationEntity({
    required this.pswId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.proofIdentityType,
    required this.submittedAt,
    required this.proofIdentityFileId,
    required this.pswCertificateFileId,
    required this.cvFileId,
    required this.immunizationRecordFileId,
    required this.criminalRecordFileId,
    required this.firstAidOrCprFileId,
    required this.verificationStatus,
  });
}
