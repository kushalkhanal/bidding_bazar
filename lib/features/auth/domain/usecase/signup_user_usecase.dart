import 'package:bidding_bazar/app/usecase/usecase.dart';
import 'package:bidding_bazar/core/error/failure.dart';
import 'package:bidding_bazar/features/auth/data/repository/user_repository.dart';
import 'package:bidding_bazar/features/auth/domain/entity/user_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';


class RegisterUserParams extends Equatable {
  final String name;
  final String email;
  final String password;

  const RegisterUserParams({
    required this.name,
    required this.email,
    required this.password,
  });

  const RegisterUserParams.initial({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
}

class UserRegisterUsecase
    implements UseCaseWithParams<void, RegisterUserParams> {
  final IUserRepository repository;

  UserRegisterUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(RegisterUserParams params) async {
    var user = UserEntity(
      name: params.name,
      email: params.email,
      password: params.password,
    );
    return await repository.registerUser(user);
  }
}