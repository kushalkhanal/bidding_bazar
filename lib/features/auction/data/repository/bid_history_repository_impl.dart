import 'package:bidding_bazar/core/error/exceptions.dart';
import 'package:bidding_bazar/core/error/failure.dart';
import 'package:bidding_bazar/features/auction/data/data_source/remote_datasource/bid_history_remote_data_source.dart';
import 'package:bidding_bazar/features/auction/domain/entity/paginated_bid_history_entity.dart';
import 'package:bidding_bazar/features/auction/domain/repository/bid_history_repository.dart';
import 'package:dartz/dartz.dart';

class BidHistoryRepositoryImpl implements IBidHistoryRepository {
  final BidHistoryRemoteDataSource _remoteDataSource;

  BidHistoryRepositoryImpl({required BidHistoryRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, PaginatedBidHistoryEntity>> getUserBidHistory({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final result = await _remoteDataSource.getUserBidHistory(
        page: page,
        limit: limit,
      );
      return Right(result);
    } on ServerException {
      return const Left(RemoteDatabaseFailure(message: 'Server error occurred'));
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaginatedBidHistoryEntity>> getAuctionBidHistory({
    required String auctionId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final result = await _remoteDataSource.getAuctionBidHistory(
        auctionId: auctionId,
        page: page,
        limit: limit,
      );
      return Right(result);
    } on ServerException {
      return const Left(RemoteDatabaseFailure(message: 'Server error occurred'));
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
} 