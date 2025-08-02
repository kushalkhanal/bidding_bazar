import 'package:bidding_bazar/features/auction/domain/entity/auction_entity.dart';
import 'package:bidding_bazar/features/auction/domain/entity/bid_entity.dart';
import 'package:equatable/equatable.dart';

class BidHistoryEntity extends Equatable {
  final String id;
  final AuctionEntity auction;
  final BidEntity bid;
  final bool isWinningBid;
  final bool isAuctionEnded;

  const BidHistoryEntity({
    required this.id,
    required this.auction,
    required this.bid,
    required this.isWinningBid,
    required this.isAuctionEnded,
  });

  @override
  List<Object?> get props => [id, auction, bid, isWinningBid, isAuctionEnded];
} 