import 'package:bidding_bazar/features/auth/domain/entity/user_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class LoginState extends Equatable {
  final bool isLoading;
  final bool isPasswordVisible;
  final String? errorMessage; // To hold the error message
  final UserEntity? loggedInUser; // To hold the user on success

  const LoginState({
    required this.isLoading,
    required this.isPasswordVisible,
    this.errorMessage,
    this.loggedInUser,
  });

  const LoginState.initial()
      : isLoading = false,
        isPasswordVisible = false,
        errorMessage = null,
        loggedInUser = null;

  LoginState copyWith({
    bool? isLoading,
    bool? isPasswordVisible,
    String? errorMessage,
    UserEntity? loggedInUser,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      // Allow setting error/user to null to clear them
      errorMessage: errorMessage,
      loggedInUser: loggedInUser,
    );
  }

  @override
  List<Object?> get props => [isLoading, isPasswordVisible, errorMessage, loggedInUser];
}