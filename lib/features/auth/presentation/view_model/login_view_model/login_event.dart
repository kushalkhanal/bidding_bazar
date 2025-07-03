// lib/features/auth/presentation/view_model/login_view_model/login_event.dart

import 'package:flutter/material.dart';

@immutable
sealed class LoginEvent {}

class NavigateToSignupView extends LoginEvent {
  final BuildContext context;
  final Widget destination;

  NavigateToSignupView({required this.context, required this.destination});
}

class NavigateToHomeView extends LoginEvent {
  final BuildContext context;
  final Widget destination;

  NavigateToHomeView({required this.context, required this.destination});
}

class LoginIntoSystemEvent extends LoginEvent {
  final BuildContext context;
  final String email;
  final String password;

  LoginIntoSystemEvent({
    required this.context,
    required this.email,
    required this.password,
  });
}

// Simplified event for toggling password visibility
class TogglePasswordVisibility extends LoginEvent {}