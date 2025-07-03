import 'package:bidding_bazar/app/usecase/usecase.dart';
import 'package:bidding_bazar/core/error/failure.dart';
import 'package:bidding_bazar/features/auth/domain/repository/user_repository.dart';
import 'package:bidding_bazar/features/auth/domain/entity/user_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';


class RegisterUserParams extends Equatable {
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String password;

  const RegisterUserParams({
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
  });

  const RegisterUserParams.initial({
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
  });

  @override
  List<Object?> get props => [username, email,firstName,lastName ,password];
}

class UserRegisterUsecase
    implements UseCaseWithParams<void, RegisterUserParams> {
  final IUserRepository repository;

  UserRegisterUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(RegisterUserParams params) async {
    var user = UserEntity(
      username: params.username,
      email: params.email,
      firstName: params.firstName,
      lastName: params.lastName,
      password: params.password,
    );
    return await repository.registerUser(user);
  }
}