import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String number;
  final String role;
  final double wallet;

  const UserEntity({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.number,
    required this.role,
    required this.wallet,
  });

  @override
  List<Object?> get props => [id, email, firstName, lastName, number, role, wallet];
}