import 'package:flutter/material.dart';

@immutable
sealed class LoginEvent {}

class NavigateToSignupView extends LoginEvent {
  final BuildContext context;
  final Widget destination;

  NavigateToSignupView({required this.context, required this.destination});
}

// class NavigateToForgotPasswordView extends LoginEvent {
//   final BuildContext context;
//   final Widget destination;

//   NavigateToForgotPasswordView({
//     required this.context,
//     required this.destination,
//   });
// }

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

class ShowHidePassword extends LoginEvent {
  final BuildContext context;
  final bool isVisible;

  ShowHidePassword({required this.context, required this.isVisible});
}