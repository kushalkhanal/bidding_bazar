import 'package:bidding_bazar/features/auction/domain/entity/partial_user_entity.dart';
import 'package:equatable/equatable.dart';

class BidEntity extends Equatable {
  final PartialUserEntity bidder;
  final double amount;
  final DateTime timestamp;

  const BidEntity({
    required this.bidder,
    required this.amount,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [bidder, amount, timestamp];
}