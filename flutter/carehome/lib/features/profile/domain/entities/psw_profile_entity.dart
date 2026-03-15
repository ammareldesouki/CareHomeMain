import 'address_entity.dart';
import 'document_file_entity.dart';

class PswProfileEntity {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String dateOfBirth;
  final String gender;
  final AddressEntity address;
  final String proofIdentityType;
  final bool isProfileCompleted;
  final String verificationStatus;
  final String? role;
  final DocumentFileEntity? proofIdentityFile;
  final DocumentFileEntity? insuranceFile;
  final DocumentFileEntity? pswCertificateFile;
  final DocumentFileEntity? cvFile;
  final DocumentFileEntity? immunizationRecordFile;
  final DocumentFileEntity? criminalRecordFile;
  final DocumentFileEntity? firstAidOrCPRFile;

  const PswProfileEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
    this.proofIdentityType = '',
    this.isProfileCompleted = false,
    this.role,
    this.proofIdentityFile,
    this.insuranceFile,
    this.pswCertificateFile,
    this.cvFile,
    this.immunizationRecordFile,
    this.criminalRecordFile,
    this.firstAidOrCPRFile,
    this.verificationStatus = 'None',
  });

  String get fullName => '$firstName $lastName';
}
