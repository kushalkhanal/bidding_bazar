
import 'package:bidding_bazar/core/error/failure.dart';
import 'package:bidding_bazar/core/usecase/usecase.dart';
import 'package:bidding_bazar/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class RegisterUser implements UseCase<void, RegisterParams> {
  final AuthRepository repository;
  RegisterUser(this.repository);

  @override
  Future<Either<Failure, void>> call(RegisterParams params) async {
    return await repository.register(
      email: params.email,
      password: params.password,
      firstName: params.firstName,
      lastName: params.lastName,
      number: params.number,
    );
  }
}

class RegisterParams extends Equatable {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String number;

  const RegisterParams(
      {required this.email,
      required this.password,
      required this.firstName,
      required this.lastName,
      required this.number});
      
  @override
  List<Object?> get props => [email, password, firstName, lastName, number];
}