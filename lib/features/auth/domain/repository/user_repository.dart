// lib/features/user/domain/repositories/user_repository.dart

import 'package:bidding_bazar/core/error/failure.dart';
import 'package:bidding_bazar/features/auth/domain/entity/login_response_entity.dart';
import 'package:bidding_bazar/features/auth/domain/entity/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IUserRepository {
  /// Registers a new user.
  /// Returns Right(void) on success.
  Future<Either<Failure, void>> register({
    required String email,
    required String firstName,
    required String lastName,
    required String password,
    required String number,
  });

  /// Logs in a user.
  /// Returns Right(LoginResponseEntity) on success, which includes user data and token.
  Future<Either<Failure, LoginResponseEntity>> login({
    required String email,
    required String password,
  });

  /// Gets current user data.
  /// Returns Right(UserEntity) on success.
  Future<Either<Failure, UserEntity>> getMe();
}
