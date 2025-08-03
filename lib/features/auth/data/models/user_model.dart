
import 'package:bidding_bazar/features/auth/domain/entities/user_entity.dart';

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

  /// A factory constructor to manually create a UserModel instance from a JSON map.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'] ?? json['_id'],
      
      // We cast each value to its expected type for type safety.
      email: json['email'] as String,
      firstName: json['firstName'] as String,
lastName: json['lastName'] as String,
      number: json['number'] as String,
      role: json['role'] as String,
      
      // Safely parse the 'wallet' field, providing a default value of 0.0 if it's null.
      wallet: (json['wallet'] as num? ?? 0).toDouble(),
    );
  }
}