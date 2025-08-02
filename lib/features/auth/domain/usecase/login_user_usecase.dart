// lib/features/user/domain/usecases/login_user.dart

import 'package:bidding_bazar/app/usecase/usecase.dart';
import 'package:bidding_bazar/core/error/failure.dart';
import 'package:bidding_bazar/features/auth/domain/entity/login_response_entity.dart';
import 'package:bidding_bazar/features/auth/domain/repository/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class LoginUserUsecase
    implements UseCaseWithParams<LoginResponseEntity, LoginParams> {
  final IUserRepository repository;

  LoginUserUsecase(this.repository);

  @override
  Future<Either<Failure, LoginResponseEntity>> call(LoginParams params) async {
    return await repository.login(
      email: params.email,
      password: params.password,
    );
  }
}

// Class to hold the parameters for the LoginUser use case.
class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
