
import 'package:bidding_bazar/features/auth/domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.number,
    required super.role,
    required super.wallet,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? json['_id'], // Backend uses _id
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      number: json['number'],
      role: json['role'],
      wallet: json['wallet'],
    );
  }

  // Method to convert the model to a JSON map (useful for sending data)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'number': number,
      'role': role,
      'wallet': wallet,
    };
  }
}

// A model for the entire login response, including the token
class LoginResponseModel {
  final String token;
  final UserModel user;

  LoginResponseModel({required this.token, required this.user});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json['token'],
      user: UserModel.fromJson(json['user']),
    );
  }
}