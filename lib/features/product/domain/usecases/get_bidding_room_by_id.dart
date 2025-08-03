import 'package:bidding_bazar/core/error/failure.dart';
import 'package:bidding_bazar/core/usecase/usecase.dart';
import 'package:bidding_bazar/features/product/domain/entities/bidding_room_entity.dart';
import 'package:bidding_bazar/features/product/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class GetBiddingRoomById implements UseCase<BiddingRoomEntity, IdParams> {
  final ProductRepository repository;
  GetBiddingRoomById(this.repository);

  @override
  Future<Either<Failure, BiddingRoomEntity>> call(IdParams params) async {
    return await repository.getBiddingRoomById(id: params.id);
  }
}

class IdParams extends Equatable {
  final String id;
  const IdParams({required this.id});
  
  @override
  List<Object?> get props => [id];
}