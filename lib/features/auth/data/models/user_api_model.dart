import 'package:bidding_bazar/features/auth/domain/entity/user_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_api_model.g.dart';

@JsonSerializable()
class UserApiModel extends Equatable{
  @JsonKey(name:'_id')
  final String? userId;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String password;

  const UserApiModel( {
    this.userId,
    required this.username,
    required this.email, 
    required this.firstName,
    required this.lastName,
    required this.password,
  });
  const UserApiModel.empty()
    : userId='',
      email='',
      username='',
      firstName='',
      lastName='',
      password='';


  factory UserApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserApiModelToJson(this);


  UserEntity toEntity(){
    return UserEntity(userId: userId,username: username, email: email, firstName: firstName, lastName: lastName, password: password);
  }

  static UserApiModel fromEntity(UserEntity entity)=>UserApiModel(username: entity.username, email: entity.email, firstName: entity.firstName, lastName: entity.lastName, password: entity.password);

  static List<UserEntity> toEntityList(List<UserApiModel>model)=>
    model.map((model)=>model.toEntity()).toList();

  
  @override
  List<Object?> get props => [
    userId,
    username,
    email,
    firstName,
    lastName,
    password
  ];
}