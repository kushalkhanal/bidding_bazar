import 'package:bidding_bazar/core/error/failure.dart';
import 'package:bidding_bazar/features/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:bidding_bazar/features/auth/domain/entity/user_entity.dart';
import 'package:bidding_bazar/features/auth/domain/repository/user_repository.dart';
import 'package:dartz/dartz.dart';


class UserLocalRepository implements IUserRepository {
  final UserLocalDataSource _userLocalDataSource;

  UserLocalRepository({required UserLocalDataSource userLocalDataSource})
    : _userLocalDataSource = userLocalDataSource;
  @override
  Future<Either<Failure, String>> loginUser(
    String email,
    String password,
  ) async {
    try {
      final result = await _userLocalDataSource.loginUser(email, password);
      return Right(result);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: "Login Failed: $e"));
    }
  }

  @override
  Future<Either<Failure, void>> registerUser(UserEntity user) async {
    try {
      await _userLocalDataSource.registerUser(user);
      return Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: "Registration Failed: $e"));
    }
  }
}