// Shared address
class AddressDto {
  final int apartmentNumber;
  final String street;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  const AddressDto({
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
