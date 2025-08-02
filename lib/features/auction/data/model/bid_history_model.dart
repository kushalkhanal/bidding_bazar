import 'package:bidding_bazar/features/auction/data/model/auction_model.dart';
import 'package:bidding_bazar/features/auction/data/model/bid_model.dart';
import 'package:bidding_bazar/features/auction/domain/entity/bid_history_entity.dart';

class BidHistoryModel extends BidHistoryEntity {
  const BidHistoryModel({
    required super.id,
    required super.auction,
    required super.bid,
    required super.isWinningBid,
    required super.isAuctionEnded,
  });

  factory BidHistoryModel.fromJson(Map<String, dynamic> json) {
    try {
      return BidHistoryModel(
        id: json['_id']?.toString() ?? '',
        auction: AuctionModel.fromJson(json['auction']),
        bid: BidModel.fromJson(json['bid']),
        isWinningBid: json['isWinningBid'] ?? false,
        isAuctionEnded: json['isAuctionEnded'] ?? false,
      );
    } catch (e) {
      print('Error parsing bid history: $e');
      rethrow;
    }
  }
} 