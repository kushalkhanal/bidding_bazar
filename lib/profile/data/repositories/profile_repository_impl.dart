import 'package:bidding_bazar/core/error/exceptions.dart';
import 'package:bidding_bazar/core/error/failure.dart';
import 'package:bidding_bazar/profile/data/datasources/profile_remote_data_source.dart';
import 'package:bidding_bazar/profile/domain/entities/profile_data_entity.dart';
import 'package:bidding_bazar/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ProfileDataEntity>> getProfileData() async {
    try {
      final profileData = await remoteDataSource.getProfileData();
      return Right(profileData);
    } on ServerException {
      return const Left(ServerFailure('Failed to load profile data.'));
    } on DioException {
      return const Left(ServerFailure('Network error. Failed to load profile data.'));
    }
  }
}