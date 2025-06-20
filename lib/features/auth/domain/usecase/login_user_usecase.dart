import 'package:bidding_bazar/app/usecase/usecase.dart';
import 'package:bidding_bazar/core/error/failure.dart';
import 'package:bidding_bazar/features/auth/data/repository/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';


class LoginUserParams extends Equatable {
  final String email;
  final String password;

  const LoginUserParams({required this.email, required this.password});

  const LoginUserParams.initial() : email = '', password = '';

  @override
  List<Object?> get props => [email, password];
}

class UserLoginUsecase implements UseCaseWithParams<String, LoginUserParams> {
  final IUserRepository repository;

  UserLoginUsecase({required this.repository});

  @override
  Future<Either<Failure, String>> call(LoginUserParams params) async {
    return await repository.loginUser(params.email, params.password);
  }
}