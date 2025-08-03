
import 'package:bidding_bazar/core/error/failure.dart';
import 'package:bidding_bazar/core/usecase/usecase.dart';
import 'package:bidding_bazar/features/auth/domain/entities/user_entity.dart';
import 'package:bidding_bazar/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class CheckAuthStatus implements UseCase<UserEntity, NoParams> {
  final AuthRepository repository;
  CheckAuthStatus(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return await repository.checkAuthStatus();
  }
}