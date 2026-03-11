class AddressEntity {
  final int apartmentNumber;
  final String street;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  const AddressEntity({
    this.apartmentNumber = 0,
    this.street = '',
    this.city = '',
    this.state = '',
    this.postalCode = '',
    this.country = '',
  });

  String get fullAddress {
    final parts = <String>[];
    if (apartmentNumber > 0) parts.add('Apt $apartmentNumber');
    if (street.isNotEmpty) parts.add(street);
    if (city.isNotEmpty) parts.add(city);
    if (state.isNotEmpty) parts.add(state);
    if (country.isNotEmpty) parts.add(country);
    return parts.join(', ');
  }
}
