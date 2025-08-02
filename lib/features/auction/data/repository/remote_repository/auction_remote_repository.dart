import 'dart:io';
import 'package:bidding_bazar/core/error/failure.dart';
import 'package:bidding_bazar/features/auction/data/data_source/auction_data_source.dart';
import 'package:bidding_bazar/features/auction/domain/entity/auction_entity.dart';
import 'package:bidding_bazar/features/auction/domain/entity/paginated_auctions_entity.dart';
import 'package:bidding_bazar/features/auction/domain/repository/auction_repository.dart';
import 'package:dartz/dartz.dart';

class AuctionRemoteRepositoryImpl implements IAuctionRepository {
  final IAuctionDataSource _dataSource;

  AuctionRemoteRepositoryImpl({required IAuctionDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<Either<Failure, PaginatedAuctionsEntity>> getAllAuctions({
    int page = 1,
    int limit = 8,
    String? searchQuery,
  }) async {
    try {
      final result = await _dataSource.getAllAuctions(
        page: page,
        limit: limit,
        searchQuery: searchQuery,
      );
      return Right(result);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuctionEntity>> getAuctionById(String id) async {
    try {
      final result = await _dataSource.getAuctionById(id);
      return Right(result);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, AuctionEntity>> createAuction({
    required String name,
    required String description,
    required double startingPrice,
    required DateTime endTime,
    required List<File> images,
  }) async {
    try {
      final result = await _dataSource.createAuction(
        name: name,
        description: description,
        startingPrice: startingPrice,
        endTime: endTime,
        images: images,
      );
      return Right(result);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuctionEntity>> placeBid({
    required String auctionId,
    required double amount,
  }) async {
    try {
      final result = await _dataSource.placeBid(
        auctionId: auctionId,
        amount: amount,
      );
      return Right(result);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}