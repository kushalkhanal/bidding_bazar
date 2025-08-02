import 'package:bidding_bazar/core/error/failure.dart';
import 'package:bidding_bazar/features/auction/domain/entity/auction_entity.dart';
import 'package:bidding_bazar/features/auction/domain/repository/auction_repository.dart';
import 'package:dartz/dartz.dart';

class GetAuctionByIdUseCase {
  final IAuctionRepository _auctionRepository;

  GetAuctionByIdUseCase({required IAuctionRepository auctionRepository})
      : _auctionRepository = auctionRepository;

  Future<Either<Failure, AuctionEntity>> call(String auctionId) async {
    return await _auctionRepository.getAuctionById(auctionId);
  }
} 