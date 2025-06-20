import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../../../../features/auth/domain/entities/user_entity.dart';
import '../../../../../features/auth/domain/repositories/auth_repository.dart';

class LoginUser implements UseCase<UserEntity, LoginParams> {
  final AuthRepository repository;
  LoginUser(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) async {
    return await repository.login(email: params.email, password: params.password);
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;
  const LoginParams({required this.email, required this.password});
  @override
  List<Object> get props => [email, password];
}