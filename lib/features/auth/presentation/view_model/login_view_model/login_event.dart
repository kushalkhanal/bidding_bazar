import 'package:flutter/material.dart';

@immutable
sealed class LoginEvent {}

// Renamed for clarity: This event is triggered when the button is pressed.
class LoginButtonPressedEvent extends LoginEvent {
  final String email;
  final String password;

  LoginButtonPressedEvent({
    required this.email,
    required this.password,
  });
}

class TogglePasswordVisibility extends LoginEvent {}

// Navigation events are an anti-pattern in BLoC.
// We will handle navigation in the View using BlocListener.