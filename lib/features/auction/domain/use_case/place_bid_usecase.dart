import 'package:bidding_bazar/core/error/failure.dart';
import 'package:bidding_bazar/features/auction/domain/entity/auction_entity.dart';
import 'package:bidding_bazar/features/auction/domain/repository/auction_repository.dart';
import 'package:dartz/dartz.dart';

class PlaceBidUseCase {
  final IAuctionRepository _auctionRepository;

  PlaceBidUseCase({required IAuctionRepository auctionRepository})
      : _auctionRepository = auctionRepository;

  Future<Either<Failure, AuctionEntity>> call({
    required String auctionId,
    required double amount,
  }) async {
    return await _auctionRepository.placeBid(
      auctionId: auctionId,
      amount: amount,
    );
  }
} 