part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

class LoginButtonPressed extends AuthEvent {
  final String email;
  final String password;

  const LoginButtonPressed({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class RegisterButtonPressed extends AuthEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String number;

  const RegisterButtonPressed({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.number,
  });

  @override
  List<Object> get props => [email, password, firstName, lastName, number];
}

class LogoutButtonPressed extends AuthEvent {}