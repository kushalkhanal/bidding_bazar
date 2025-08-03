import 'package:bidding_bazar/core/error/failure.dart';
import 'package:bidding_bazar/features/create_listing/data/datasources/create_listing_remote_data_source.dart';
import 'package:bidding_bazar/features/create_listing/domain/repositories/create_listing_repository.dart';
import 'package:bidding_bazar/features/create_listing/domain/usecases/create_bidding_room.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class CreateListingRepositoryImpl implements CreateListingRepository {
  final CreateListingRemoteDataSource remoteDataSource;

  CreateListingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> createBiddingRoom(CreateBiddingRoomParams params) async {
    try {
      await remoteDataSource.createBiddingRoom(params);
      return const Right(null);
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? 'Failed to create listing.';
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}