// lib/features/auction/data/model/partial_user_model.dart

import 'package:bidding_bazar/features/auction/domain/entity/partial_user_entity.dart';

class PartialUserModel extends PartialUserEntity {
  const PartialUserModel({
    required super.id,
    required super.firstName,
    required super.lastName,
  });

  // --- MODIFICATION START ---
  // Change the input from Map<String, dynamic> to dynamic
  factory PartialUserModel.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      // If the API sends a populated object
      return PartialUserModel(
        id: (json['_id'] ?? json['id'] ?? '').toString(),
        firstName: (json['firstName'] ?? 'User').toString(),
        lastName: (json['lastName'] ?? '').toString(),
      );
    } else if (json is String) {
      // If the API just sends an ID string
      return PartialUserModel(
        id: json,
        firstName: 'User', // Provide a default name
        lastName: '',
      );
    } else {
      // Handle null or other unexpected types gracefully
      return const PartialUserModel(id: '', firstName: 'Unknown', lastName: '');
    }
  }
  // --- MODIFICATION END ---

  PartialUserEntity toEntity() => this;
}
