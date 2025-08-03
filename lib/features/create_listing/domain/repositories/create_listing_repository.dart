import 'package:bidding_bazar/core/error/failure.dart';
import 'package:bidding_bazar/features/create_listing/domain/usecases/create_bidding_room.dart';
import 'package:dartz/dartz.dart';

abstract class CreateListingRepository {
  Future<Either<Failure, void>> createBiddingRoom(CreateBiddingRoomParams params);
}