import 'package:bidding_bazar/app/shared_pref/token_shared_preference.dart';
import 'package:bidding_bazar/app/usecase/usecase.dart';
import 'package:bidding_bazar/core/error/failure.dart';
import 'package:bidding_bazar/features/auth/domain/repository/user_repository.dart';
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
  final TokenSharedPrefs tokenSharedPrefs;

  UserLoginUsecase({required this.repository, required this.tokenSharedPrefs});



  @override
 Future<Either<Failure, String>> call(LoginUserParams params) async {
    final result = await repository.loginUser(
      params.email,
      params.password,
    );

    return result.fold((failure) => Left(failure), (token) async {
      await tokenSharedPrefs.saveToken(token);
      return Right(token);
    });
  }

}