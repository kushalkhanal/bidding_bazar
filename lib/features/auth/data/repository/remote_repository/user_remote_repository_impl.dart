// lib/features/user/data/repositories/user_repository_impl.dart

import 'package:bidding_bazar/core/error/exceptions.dart';
import 'package:bidding_bazar/core/error/failure.dart';
import 'package:bidding_bazar/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:bidding_bazar/features/auth/domain/entity/login_response_entity.dart';
import 'package:bidding_bazar/features/auth/domain/entity/user_entity.dart';
import 'package:bidding_bazar/features/auth/domain/repository/user_repository.dart';
import 'package:dartz/dartz.dart';

// You would also inject a NetworkInfo class to check for internet connection
// and a local data source for caching the token.

class UserRemoteRepository implements IUserRepository {
  final IUserRemoteDataSource remoteDataSource;
  // final NetworkInfo networkInfo; // Example of another dependency

  UserRemoteRepository({
    required this.remoteDataSource,
    // required this.networkInfo,
  });

  @override
  Future<Either<Failure, void>> register({
    required String email,
    required String firstName,
    required String lastName,
    required String password,
    required String number,
  }) async {
    // if (await networkInfo.isConnected) { // Check for internet connection
    try {
      await remoteDataSource.registerUser(
        email: email,
        firstName: firstName,
        lastName: lastName,
        password: password,
        number: number,
      );
      return const Right(null); // 'null' represents 'void' success
    } on ServerException catch (e) {
      return Left(RemoteDatabaseFailure(message: e.message));
    }
    // } else {
    //   return Left(ServerFailure('No Internet Connection'));
    // }
  }

  @override
  Future<Either<Failure, LoginResponseEntity>> login({
    required String email,
    required String password,
  }) async {
    // if (await networkInfo.isConnected) {
    try {
      final loginResponse = await remoteDataSource.loginUser(
        email: email,
        password: password,
      );

      // Create LoginResponseEntity with user data and token
      final loginResponseEntity = LoginResponseEntity(
        user: loginResponse.user,
        token: loginResponse.token,
      );

      // The repository's job is to return the business object (Entity)
      return Right(loginResponseEntity);
    } on ServerException catch (e) {
      return Left(RemoteDatabaseFailure(message: e.message));
    }
    // } else {
    //   return Left(ServerFailure('No Internet Connection'));
    // }
  }

  @override
  Future<Either<Failure, UserEntity>> getMe() async {
    // if (await networkInfo.isConnected) {
    try {
      final userResponse = await remoteDataSource.getMe();
      return Right(userResponse);
    } on ServerException catch (e) {
      return Left(RemoteDatabaseFailure(message: e.message));
    }
    // } else {
    //   return Left(ServerFailure('No Internet Connection'));
    // }
  }
}
