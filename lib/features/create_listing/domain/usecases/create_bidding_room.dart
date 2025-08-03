
import 'package:bidding_bazar/core/error/failure.dart';
import 'package:bidding_bazar/core/usecase/usecase.dart';
import 'package:bidding_bazar/features/create_listing/domain/repositories/create_listing_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

class CreateBiddingRoom implements UseCase<void, CreateBiddingRoomParams> {
  final CreateListingRepository repository;
  CreateBiddingRoom(this.repository);

  @override
  Future<Either<Failure, void>> call(CreateBiddingRoomParams params) async {
    return await repository.createBiddingRoom(params);
  }
}

class CreateBiddingRoomParams extends Equatable {
  final String name;
  final String description;
  final double startingPrice;
  final DateTime endTime;
  final List<XFile> images;

  const CreateBiddingRoomParams({
    required this.name,
    required this.description,
    required this.startingPrice,
    required this.endTime,
    required this.images,
  });

  @override
  List<Object?> get props => [name, description, startingPrice, endTime, images];
}