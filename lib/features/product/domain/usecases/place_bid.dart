import 'package:bidding_bazar/core/error/failure.dart';
import 'package:bidding_bazar/core/usecase/usecase.dart';
import 'package:bidding_bazar/features/product/domain/entities/bidding_room_entity.dart';
import 'package:bidding_bazar/features/product/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class PlaceBid implements UseCase<BiddingRoomEntity, PlaceBidParams> {
  final ProductRepository repository;
  PlaceBid(this.repository);

  @override
  Future<Either<Failure, BiddingRoomEntity>> call(PlaceBidParams params) async {
    return await repository.placeBid(productId: params.productId, amount: params.amount);
  }
}

class PlaceBidParams extends Equatable {
  final String productId;
  final double amount;

  const PlaceBidParams({required this.productId, required this.amount});

  @override
  List<Object?> get props => [productId, amount];
}