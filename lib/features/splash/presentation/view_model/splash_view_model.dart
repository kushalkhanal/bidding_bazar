import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashViewModel extends Cubit<void> {
  SplashViewModel() : super(null);

  Future<void> init(BuildContext context) async {
    // Just show splash for a short time
    // Navigation will be handled by AuthWrapper based on auth state
    await Future.delayed(const Duration(seconds: 2));
  }
}
