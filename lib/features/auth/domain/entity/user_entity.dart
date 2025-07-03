import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? userId;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String password;

  const UserEntity({
    this.userId,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,

  });

  @override
  List<Object?> get props => [userId, username, email,firstName, lastName, password];
}