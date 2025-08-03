import 'package:bidding_bazar/core/error/failure.dart';
import 'package:bidding_bazar/core/usecase/usecase.dart';
import 'package:bidding_bazar/profile/domain/entities/profile_data_entity.dart';
import 'package:bidding_bazar/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';

class GetProfileData implements UseCase<ProfileDataEntity, NoParams> {
  final ProfileRepository repository;
  GetProfileData(this.repository);

  @override
  Future<Either<Failure, ProfileDataEntity>> call(NoParams params) async {
    return await repository.getProfileData();
  }
}