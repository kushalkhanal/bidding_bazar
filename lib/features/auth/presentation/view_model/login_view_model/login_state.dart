import 'package:bidding_bazar/features/auth/domain/entity/login_response_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class LoginState extends Equatable {
  final bool isLoading;
  final bool isPasswordVisible;
  final String? errorMessage; // To hold the error message
  final LoginResponseEntity? loginResponse; // To hold the user on success

  const LoginState({
    this.isLoading = false,
    this.isPasswordVisible = false,
    this.errorMessage,
    this.loginResponse,
  });

  const LoginState.initial() : this();

  LoginState copyWith({
    bool? isLoading,
    bool? isPasswordVisible,
    String? errorMessage,
    LoginResponseEntity? loginResponse,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      // Allow setting error/user to null to clear them
      errorMessage: errorMessage,
      loginResponse: loginResponse,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isPasswordVisible,
    errorMessage,
    loginResponse,
  ];
}
