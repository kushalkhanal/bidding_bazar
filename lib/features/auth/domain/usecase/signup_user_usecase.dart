// lib/features/user/domain/usecases/register_user.dart

import 'package:bidding_bazar/app/usecase/usecase.dart';
import 'package:bidding_bazar/core/error/failure.dart';
import 'package:bidding_bazar/features/auth/domain/repository/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';


class SignupUserUsecase implements UseCaseWithParams<void, RegisterParams> {
  final IUserRepository repository;

  SignupUserUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(RegisterParams params) async {
    return await repository.register(
      email: params.email,
      firstName: params.firstName,
      lastName: params.lastName,
      password: params.password,
      number: params.number,
    );
  }
}

// Class to hold the parameters for the RegisterUser use case.
// This is cleaner than passing multiple arguments to the call method.
class RegisterParams extends Equatable {
  final String email;
  final String firstName;
  final String lastName;
  final String password;
  final String number;

  const RegisterParams({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.number,
  });

  @override
  List<Object?> get props => [email, firstName, lastName, password, number];
}