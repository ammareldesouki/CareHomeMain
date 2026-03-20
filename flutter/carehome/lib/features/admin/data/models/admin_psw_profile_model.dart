import '../../domain/entities/psw_profile_entity.dart';

class AdminPswProfileModel extends PswProfileEntity {
  const AdminPswProfileModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.fullName,
    required super.email,
    required super.phoneNumber,
    required super.dateOfBirth,
    required super.gender,
    required super.address,
    super.profilePhoto,
    required super.proofIdentityType,
    required super.verificationStatus,
    super.rejectionReason,
    required super.isProfileCompleted,
    super.role,
    super.proofIdentityFile,
    super.insuranceFile,
    super.pswCertificateFile,
    super.cvFile,
    super.immunizationRecordFile,
    super.criminalRecordFile,
    super.firstAidOrCPRFile,
  });

  factory AdminPswProfileModel.fromMap(Map<String, dynamic> map) {
    // Parse from API data['data']
    final data = map['data'] ?? map;

    final proofIdentityFile = data['proofIdentityFile'] != null
        ? FileEntity(
            id: data['proofIdentityFile']['id'] ?? '',
            fileName: data['proofIdentityFile']['fileName'] ?? '',
            url: data['proofIdentityFile']['url'] ?? '',
          )
        : null;

    final insuranceFile = data['insuranceFile'] != null
        ? FileEntity(
            id: data['insuranceFile']['id'] ?? '',
            fileName: data['insuranceFile']['fileName'] ?? '',
            url: data['insuranceFile']['url'] ?? '',
          )
        : null;

    final pswCertificateFile = data['pswCertificateFile'] != null
        ? FileEntity(
            id: data['pswCertificateFile']['id'] ?? '',
            fileName: data['pswCertificateFile']['fileName'] ?? '',
            url: data['pswCertificateFile']['url'] ?? '',
          )
        : null;

    final cvFile = data['cvFile'] != null
        ? FileEntity(
            id: data['cvFile']['id'] ?? '',
            fileName: data['cvFile']['fileName'] ?? '',
            url: data['cvFile']['url'] ?? '',
          )
        : null;

    final immunizationRecordFile = data['immunizationRecordFile'] != null
        ? FileEntity(
            id: data['immunizationRecordFile']['id'] ?? '',
            fileName: data['immunizationRecordFile']['fileName'] ?? '',
            url: data['immunizationRecordFile']['url'] ?? '',
          )
        : null;

    final criminalRecordFile = data['criminalRecordFile'] != null
        ? FileEntity(
            id: data['criminalRecordFile']['id'] ?? '',
            fileName: data['criminalRecordFile']['fileName'] ?? '',
            url: data['criminalRecordFile']['url'] ?? '',
          )
        : null;

    final firstAidOrCPRFile = data['firstAidOrCPRFile'] != null
        ? FileEntity(
            id: data['firstAidOrCPRFile']['id'] ?? '',
            fileName: data['firstAidOrCPRFile']['fileName'] ?? '',
            url: data['firstAidOrCPRFile']['url'] ?? '',
          )
        : null;

    final addressData = data['address'] ?? {};
    final address = AddressEntity(
      apartmentNumber: addressData['apartmentNumber'],
      street: addressData['street'] ?? '',
      city: addressData['city'] ?? '',
      state: addressData['state'] ?? '',
      postalCode: addressData['postalCode'] ?? '',
      country: addressData['country'] ?? '',
    );

    return AdminPswProfileModel(
      id: data['id'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      fullName: '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}'.trim(),
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      dateOfBirth: data['dateOfBirth'] ?? '',
      gender: data['gender'] ?? '',
      address: address,
      profilePhoto: data['profilePhoto'],
      proofIdentityType: data['proofIdentityType'] ?? '',
      verificationStatus: data['verificationStatus'] ?? '',
      rejectionReason: data['rejectionReason'],
      isProfileCompleted: data['isProfileCompleted'] ?? false,
      role: data['role'],
      proofIdentityFile: proofIdentityFile,
      insuranceFile: insuranceFile,
      pswCertificateFile: pswCertificateFile,
      cvFile: cvFile,
      immunizationRecordFile: immunizationRecordFile,
      criminalRecordFile: criminalRecordFile,
      firstAidOrCPRFile: firstAidOrCPRFile,
    );
  }
}
