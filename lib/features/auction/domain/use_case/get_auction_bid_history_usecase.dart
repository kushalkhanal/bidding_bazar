import 'package:bidding_bazar/core/error/failure.dart';
import 'package:bidding_bazar/features/auction/domain/entity/paginated_bid_history_entity.dart';
import 'package:bidding_bazar/features/auction/domain/repository/bid_history_repository.dart';
import 'package:dartz/dartz.dart';

class GetAuctionBidHistoryUseCase {
  final IBidHistoryRepository _bidHistoryRepository;

  GetAuctionBidHistoryUseCase({required IBidHistoryRepository bidHistoryRepository})
      : _bidHistoryRepository = bidHistoryRepository;

  Future<Either<Failure, PaginatedBidHistoryEntity>> call({
    required String auctionId,
    int page = 1,
    int limit = 10,
  }) async {
    return await _bidHistoryRepository.getAuctionBidHistory(
      auctionId: auctionId,
      page: page,
      limit: limit,
    );
  }
} 