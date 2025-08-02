import 'package:bidding_bazar/features/auction/domain/entity/bid_entity.dart';
import 'package:bidding_bazar/features/auction/domain/entity/partial_user_entity.dart';
import 'package:equatable/equatable.dart';

class AuctionEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final double startingPrice;
  final double currentPrice;
  final DateTime endTime;
  final PartialUserEntity seller;
  final List<String> imageUrls;
  final List<BidEntity> bids;
  final String status;

  const AuctionEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.startingPrice,
    required this.currentPrice,
    required this.endTime,
    required this.seller,
    required this.imageUrls,
    required this.bids,
    required this.status,
  });

  @override
  List<Object?> get props => [id, name, description, endTime, currentPrice, status];
}