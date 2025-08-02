import 'package:bidding_bazar/features/auth/domain/entity/user_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

// State when the app is initializing
class AuthInitial extends AuthState {}

// State when the user is logged in
class Authenticated extends AuthState {
  final UserEntity user;

  const Authenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

// State when the user is not logged in
class Unauthenticated extends AuthState {}