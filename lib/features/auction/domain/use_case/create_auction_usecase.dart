import 'dart:io';
import 'package:bidding_bazar/core/error/failure.dart';
import 'package:bidding_bazar/features/auction/domain/entity/auction_entity.dart';
import 'package:bidding_bazar/features/auction/domain/repository/auction_repository.dart';
import 'package:dartz/dartz.dart';

class CreateAuctionUseCase {
  final IAuctionRepository _auctionRepository;

  CreateAuctionUseCase({required IAuctionRepository auctionRepository})
      : _auctionRepository = auctionRepository;

  Future<Either<Failure, AuctionEntity>> call({
    required String name,
    required String description,
    required double startingPrice,
    required DateTime endTime,
    required List<File> images,
  }) async {
    return await _auctionRepository.createAuction(
      name: name,
      description: description,
      startingPrice: startingPrice,
      endTime: endTime,
      images: images,
    );
  }
} 