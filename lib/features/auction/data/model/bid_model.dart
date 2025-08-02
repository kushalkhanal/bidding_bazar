// lib/features/auction/data/model/bid_model.dart

import 'package:bidding_bazar/features/auction/data/model/partial_user_model.dart';
import 'package:bidding_bazar/features/auction/domain/entity/bid_entity.dart';

class BidModel extends BidEntity {
  const BidModel({
    required super.bidder,
    required super.amount,
    required super.timestamp,
  });

  factory BidModel.fromJson(Map<String, dynamic> json) {
    return BidModel(
      // --- MODIFICATION START ---
      // Use the new robust factory for the 'bidder' field.
      // It can now handle both a String ID and a populated Map.
      bidder: PartialUserModel.fromJson(json['bidder']),
      // --- MODIFICATION END ---
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      timestamp: DateTime.parse(
        json['timestamp'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
