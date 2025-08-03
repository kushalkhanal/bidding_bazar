import 'package:bidding_bazar/core/error/failure.dart';
import 'package:bidding_bazar/profile/domain/entities/profile_data_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileDataEntity>> getProfileData();
}