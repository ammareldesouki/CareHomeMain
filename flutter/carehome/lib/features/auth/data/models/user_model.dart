import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({

    required super.token, required super.email, required super.role, required super.userId, required super.workStatus});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json["token"],
      email: json["email"],
      role: json["role"],
      userId: json["Id"],
      workStatus: json["verficationStatus"],




    );
  }

  Map<String, dynamic> toJson() {
    return {"id": userId, "email": email, "role": role};
  }
}
