import '../../domain/entities/psw_profile_entity.dart';
import 'address_model.dart';
import 'document_file_model.dart';

class PswProfileModel extends PswProfileEntity {
  const PswProfileModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.phoneNumber,
    required super.dateOfBirth,
    required super.gender,
    required super.address,
    super.proofIdentityType,
    super.workStatus,
    super.isProfileCompleted,
    super.isVerified,
    super.role,
    super.proofIdentityFile,
    super.insuranceFile,
    super.pswCertificateFile,
    super.cvFile,
    super.immunizationRecordFile,
    super.criminalRecordFile,
    super.firstAidOrCPRFile,
  });

  factory PswProfileModel.fromMap(Map<String, dynamic> map) {
    DocumentFileModel? _doc(String key) {
      if (map[key] == null) return null;
      return DocumentFileModel.fromMap(map[key] as Map<String, dynamic>);
    }

    return PswProfileModel(
      id: map['id'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      dateOfBirth: map['dateOfBirth'] ?? '',
      gender: map['gender'] ?? '',
      address: map['address'] != null
          ? AddressModel.fromMap(map['address'] as Map<String, dynamic>)
          : const AddressModel(),
      proofIdentityType: map['proofIdentityType'] ?? '',
      workStatus: map['workStatus'] ?? false,
      isProfileCompleted: map['isProfileCompleted'] ?? false,
      isVerified: map['isVerified'] ?? false,
      role: map['role'],
      proofIdentityFile: _doc('proofIdentityFile'),
      insuranceFile: _doc('insuranceFile'),
      pswCertificateFile: _doc('pswCertificateFile'),
      cvFile: _doc('cvFile'),
      immunizationRecordFile: _doc('immunizationRecordFile'),
      criminalRecordFile: _doc('criminalRecordFile'),
      firstAidOrCPRFile: _doc('firstAidOrCPRFile'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'address': (address as AddressModel).toMap(),
    };
  }
}
