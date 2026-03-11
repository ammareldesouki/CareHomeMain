import '../../domain/entities/carehome_profile_entity.dart';
import 'address_model.dart';

class CareHomeProfileModel extends CareHomeProfileEntity {
  const CareHomeProfileModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.phoneNumber,
    required super.dateOfBirth,
    required super.gender,
    required super.address,
    super.businessLicense,
    super.legalName,
    super.vaccinationPolicy,
  });

  factory CareHomeProfileModel.fromMap(Map<String, dynamic> map) {
    return CareHomeProfileModel(
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
      businessLicense: map['businessLicense'] ?? 'Pending',
      legalName: map['legalName'] ?? 'Pending',
      vaccinationPolicy: map['vaccinationPolicy'] ?? 'Pending',
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
