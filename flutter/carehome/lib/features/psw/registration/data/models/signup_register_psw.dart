class PswRegisterRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String phoneNumber;
  final String dateOfBirth;
  final String gender;
  final AddressRequest address;

  const PswRegisterRequest({
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

class AddressRequest {
  final int apartmentNumber;
  final String street;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  const AddressRequest({
    this.apartmentNumber = 0,
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
  });

  Map<String, dynamic> toMap() => {
    'apartmentNumber': apartmentNumber,
    'street': street,
    'city': city,
    'state': state,
    'postalCode': postalCode,
    'country': country,
  };
}
