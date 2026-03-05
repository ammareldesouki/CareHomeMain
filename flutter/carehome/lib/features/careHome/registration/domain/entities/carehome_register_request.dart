// POST /api/auth/register/carehome  (Multiple / Organisation)
import 'package:carehome/features/careHome/registration/domain/entities/address_dto.dart';

class CareHomeRegisterRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String phoneNumber;
  final String dateOfBirth;
  final String gender;
  final AddressDto address;

  const CareHomeRegisterRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
  });

  Map<String, dynamic> toMap() => {
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'password': password,
    'phoneNumber': phoneNumber,
    'dateOfBirth': dateOfBirth,
    'gender': gender,
    'address': address.toMap(),
  };
}

// POST /api/auth/register/individual  (Independent / Individual)
class IndividualRegisterRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String phoneNumber;
  final String dateOfBirth;
  final String gender;
  final AddressDto address;

  const IndividualRegisterRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
  });

  Map<String, dynamic> toMap() => {
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'password': password,
    'phoneNumber': phoneNumber,
    'dateOfBirth': dateOfBirth,
    'gender': gender,
    'address': address.toMap(),
  };
}
