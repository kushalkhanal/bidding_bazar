import 'package:bidding_bazar/app/constant/hive_table_constant.dart';
import 'package:bidding_bazar/features/auth/domain/entity/user_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.userTableId)
class UserHiveModel extends Equatable {
  @HiveField(0)
  final String? userId;
  @HiveField(1)
  final String username;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String firstName;
  @HiveField(4)
  final String lastName;
  @HiveField(5)
  final String password;
  

  UserHiveModel({
    String? userId,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
    
  }) : userId = userId ?? const Uuid().v4();

  // Initial Constructor
  const UserHiveModel.initial()
    : userId = '',
      username = '',
      email = '',
      firstName='',
      lastName='',
      password = '';

  // From Entity
  factory UserHiveModel.fromEntity(UserEntity entity) {
    return UserHiveModel(
      userId: entity.userId,
      username: entity.username,
      email: entity.email,
      firstName: entity.firstName,
      lastName: entity.lastName,
      password: entity.password,
    );
  }

  // To Entity
  UserEntity toEntity() {
    return UserEntity(userId: userId, username: username, email: email, firstName: firstName, lastName: lastName, password: password);
  }

  @override
  List<Object?> get props => [
    userId,
    username,
    email,
    firstName,
    lastName,
    password,
  ];
}