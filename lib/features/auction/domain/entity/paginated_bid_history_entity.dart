import 'package:bidding_bazar/features/auction/domain/entity/bid_history_entity.dart';
import 'package:equatable/equatable.dart';

class PaginatedBidHistoryEntity extends Equatable {
  final List<BidHistoryEntity> bidHistory;
  final int page;
  final int totalPages;

  const PaginatedBidHistoryEntity({
    required this.bidHistory,
    required this.page,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [bidHistory, page, totalPages];
} 