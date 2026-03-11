import 'address_entity.dart';

class CareHomeProfileEntity {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String dateOfBirth;
  final String gender;
  final AddressEntity address;
  final String businessLicense;
  final String legalName;
  final String vaccinationPolicy;

  const CareHomeProfileEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
    this.businessLicense = 'Pending',
    this.legalName = 'Pending',
    this.vaccinationPolicy = 'Pending',
  });

  String get fullName => '$firstName $lastName';
}
