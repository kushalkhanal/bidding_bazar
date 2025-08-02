import 'dart:io';
import 'package:bidding_bazar/core/error/failure.dart';
import 'package:bidding_bazar/features/auction/domain/entity/auction_entity.dart';
import 'package:bidding_bazar/features/auction/domain/entity/paginated_auctions_entity.dart';
import 'package:dartz/dartz.dart';

abstract class IAuctionRepository {
  Future<Either<Failure, PaginatedAuctionsEntity>> getAllAuctions({
    int page = 1,
    int limit = 8,
    String? searchQuery,
  });

  Future<Either<Failure, AuctionEntity>> getAuctionById(String id);

  Future<Either<Failure, AuctionEntity>> createAuction({
    required String name,
    required String description,
    required double startingPrice,
    required DateTime endTime,
    required List<File> images,
  });

  Future<Either<Failure, AuctionEntity>> placeBid({
    required String auctionId,
    required double amount,
  });
}