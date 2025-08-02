import 'package:bidding_bazar/features/auth/domain/entity/user_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// Event triggered when the app starts to check auth status
class AppStarted extends AuthEvent {}

// Event triggered after a successful login
class LoggedIn extends AuthEvent {
  final UserEntity user;
  final String token;

  const LoggedIn({required this.user, required this.token});

  @override
  List<Object?> get props => [user, token];
}

// Event triggered on logout
class LoggedOut extends AuthEvent {}