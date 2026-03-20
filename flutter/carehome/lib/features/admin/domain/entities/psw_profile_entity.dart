import 'package:equatable/equatable.dart';

class FileEntity extends Equatable {
  final String id;
  final String fileName;
  final String url;

  const FileEntity({
    required this.id,
    required this.fileName,
    required this.url,
  });

  @override
  List<Object?> get props => [id, fileName, url];
}

class AddressEntity extends Equatable {
  final int? apartmentNumber;
  final String street;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  const AddressEntity({
    this.apartmentNumber,
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
  });

  @override
  List<Object?> get props => [
    apartmentNumber,
    street,
    city,
    state,
    postalCode,
    country,
  ];
}

class PswProfileEntity extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String dateOfBirth;
  final String gender;
  final AddressEntity address;
  final String? profilePhoto;
  final String proofIdentityType;
  final String verificationStatus;
  final String? rejectionReason;
  final bool isProfileCompleted;
  final String? role;
  final FileEntity? proofIdentityFile;
  final FileEntity? insuranceFile;
  final FileEntity? pswCertificateFile;
  final FileEntity? cvFile;
  final FileEntity? immunizationRecordFile;
  final FileEntity? criminalRecordFile;
  final FileEntity? firstAidOrCPRFile;

  const PswProfileEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
    this.profilePhoto,
    required this.proofIdentityType,
    required this.verificationStatus,
    this.rejectionReason,
    required this.isProfileCompleted,
    this.role,
    this.proofIdentityFile,
    this.insuranceFile,
    this.pswCertificateFile,
    this.cvFile,
    this.immunizationRecordFile,
    this.criminalRecordFile,
    this.firstAidOrCPRFile,
  });

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    fullName,
    email,
    phoneNumber,
    dateOfBirth,
    gender,
    address,
    profilePhoto,
    proofIdentityType,
    verificationStatus,
    rejectionReason,
    isProfileCompleted,
    role,
    proofIdentityFile,
    insuranceFile,
    pswCertificateFile,
    cvFile,
    immunizationRecordFile,
    criminalRecordFile,
    firstAidOrCPRFile,
  ];
}
