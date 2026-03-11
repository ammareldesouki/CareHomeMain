import '../../domain/entities/admin_profile_entity.dart';
import '../../domain/entities/psw_profile_entity.dart';
import 'address_model.dart';
import 'document_file_model.dart';

class AdminProfileModel extends AdminProfileEntity {
  const AdminProfileModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.phoneNumber,
    required super.dateOfBirth,
    required super.gender,
    required super.address,
  });

  factory AdminProfileModel.fromMap(Map<String, dynamic> map) {
    DocumentFileModel? _doc(String key) {
      if (map[key] == null) return null;
      return DocumentFileModel.fromMap(map[key] as Map<String, dynamic>);
    }

    return AdminProfileModel(
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
