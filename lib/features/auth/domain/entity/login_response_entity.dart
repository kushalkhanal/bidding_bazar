import 'package:equatable/equatable.dart';
import 'package:bidding_bazar/features/auth/domain/entity/user_entity.dart';

class LoginResponseEntity extends Equatable {
  final UserEntity user;
  final String token;

  const LoginResponseEntity({required this.user, required this.token});

  @override
  List<Object?> get props => [user, token];
}
