import 'package:bidding_bazar/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import '../entity/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> signUp({
    required String name,
    required String email,
    required String password,
  });
}