import 'package:bidding_bazar/features/auction/data/model/bid_history_model.dart';
import 'package:bidding_bazar/features/auction/domain/entity/paginated_bid_history_entity.dart';
import 'package:flutter/foundation.dart';

class PaginatedBidHistoryModel extends PaginatedBidHistoryEntity {
  const PaginatedBidHistoryModel({
    required super.bidHistory,
    required super.page,
    required super.totalPages,
  });

  factory PaginatedBidHistoryModel.fromJson(Map<String, dynamic> json) {
    try {
      final bidHistoryList = json['bidHistory'] as List?;
      final bidHistory =
          bidHistoryList
              ?.map(
                (bidHistoryJson) => BidHistoryModel.fromJson(bidHistoryJson),
              )
              .toList() ??
          [];

      return PaginatedBidHistoryModel(
        bidHistory: bidHistory,
        page: json['page'] ?? 1,
        totalPages: json['totalPages'] ?? 1,
      );
    } catch (e) {
      print('Error parsing paginated bid history: $e');
      rethrow;
    }
  }

  // Optimized parsing using compute for heavy operations
  static Future<PaginatedBidHistoryModel> fromJsonAsync(
    Map<String, dynamic> json,
  ) async {
    return await compute(_parseBidHistoryInIsolate, json);
  }

  static PaginatedBidHistoryModel _parseBidHistoryInIsolate(
    Map<String, dynamic> json,
  ) {
    try {
      final bidHistoryList = json['bidHistory'] as List?;
      final bidHistory =
          bidHistoryList
              ?.map(
                (bidHistoryJson) => BidHistoryModel.fromJson(bidHistoryJson),
              )
              .toList() ??
          [];

      return PaginatedBidHistoryModel(
        bidHistory: bidHistory,
        page: json['page'] ?? 1,
        totalPages: json['totalPages'] ?? 1,
      );
    } catch (e) {
      print('Error parsing paginated bid history in isolate: $e');
      rethrow;
    }
  }
}
