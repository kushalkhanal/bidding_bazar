import 'package:bidding_bazar/core/error/failure.dart';
import 'package:bidding_bazar/features/auction/domain/entity/paginated_bid_history_entity.dart';
import 'package:dartz/dartz.dart';

abstract class IBidHistoryRepository {
  Future<Either<Failure, PaginatedBidHistoryEntity>> getUserBidHistory({
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, PaginatedBidHistoryEntity>> getAuctionBidHistory({
    required String auctionId,
    int page = 1,
    int limit = 10,
  });
} 