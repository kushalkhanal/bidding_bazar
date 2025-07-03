// lib/features/auth/presentation/view_model/signup_view_model/signup_event.dart


import 'package:flutter/widgets.dart';

@immutable
sealed class SignupEvent {}

class NavigateToLoginView extends SignupEvent {
  final BuildContext context;
  final Widget destination;

  NavigateToLoginView({required this.context, required this.destination});
}

class RegisterUserEvent extends SignupEvent {
  final BuildContext context;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String password;
  final VoidCallback onSuccess;

  RegisterUserEvent({
    required this.context,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.onSuccess,
  });
}

class ShowHidePassword extends SignupEvent {
  final BuildContext context;
  final bool isVisible;

  ShowHidePassword({required this.context, required this.isVisible});
}

class ShowHideConfirmPassword extends SignupEvent {
  final BuildContext context;
  final bool isVisible;

  ShowHideConfirmPassword({required this.context, required this.isVisible});
}