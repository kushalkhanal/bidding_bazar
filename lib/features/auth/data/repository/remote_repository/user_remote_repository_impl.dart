import 'package:bidding_bazar/core/error/failure.dart';
import 'package:bidding_bazar/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:bidding_bazar/features/auth/domain/entity/user_entity.dart';
import 'package:bidding_bazar/features/auth/domain/repository/user_repository.dart';
import 'package:dartz/dartz.dart';

class UserRemoteRepositoryImpl implements IUserRepository {
  final UserRemoteDatasource _userRemoteDatasource;

  UserRemoteRepositoryImpl({
    required UserRemoteDatasource userRemoteDatasource,
  }) : _userRemoteDatasource = userRemoteDatasource;

  @override
  Future<Either<Failure, String>> loginUser(
    String email,
    String password,
  ) async {
    try {
      final token = await _userRemoteDatasource.loginUser(email, password);
      return Right(token);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  // in UserRemoteRepositoryImpl

@override
Future<Either<Failure, void>> registerUser(UserEntity user) async {
  try {
    await _userRemoteDatasource.registerUser(user);
    return const Right(null);
  } catch (e) {
    // e.toString() often includes "Exception: ". We can clean it up.
    final errorMessage = e.toString().replaceFirst('Exception: ', '');
    return Left(RemoteDatabaseFailure(message: errorMessage));
  }
}
}