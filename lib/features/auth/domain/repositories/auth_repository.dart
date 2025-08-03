
import 'package:bidding_bazar/core/error/failure.dart';
import 'package:bidding_bazar/features/auth/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(
      {required String email, required String password});

  Future<Either<Failure, void>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String number,
  });

  Future<Either<Failure, UserEntity>> checkAuthStatus();
  
  Future<Either<Failure, void>> logout();
}