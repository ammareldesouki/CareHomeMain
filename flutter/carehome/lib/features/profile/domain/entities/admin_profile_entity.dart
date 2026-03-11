import 'address_entity.dart';
import 'document_file_entity.dart';

class AdminProfileEntity {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String dateOfBirth;
  final String gender;
  final AddressEntity address;

  const AdminProfileEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
  });

  String get fullName => '$firstName $lastName';
}
