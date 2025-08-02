import 'package:equatable/equatable.dart';

class PartialUserEntity extends Equatable {
  final String id;
  final String firstName;
  final String lastName;

  const PartialUserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [id, firstName, lastName];
}