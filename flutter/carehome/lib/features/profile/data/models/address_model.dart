import '../../domain/entities/address_entity.dart';

class AddressModel extends AddressEntity {
  const AddressModel({
    super.apartmentNumber,
    super.street,
    super.city,
    super.state,
    super.postalCode,
    super.country,
  });

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      apartmentNumber: (map['apartmentNumber'] as num?)?.toInt() ?? 0,
      street: map['street'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      postalCode: map['postalCode'] ?? '',
      country: map['country'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'apartmentNumber': apartmentNumber,
      'street': street,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
    };
  }
}
