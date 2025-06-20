import 'package:bidding_bazar/app/service_locator/service_locator.dart';
import 'package:bidding_bazar/features/auth/presentation/view/login_view.dart';
import 'package:bidding_bazar/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SplashViewModel extends Cubit<void> {
  SplashViewModel() : super(null);

  Future<void> init(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => BlocProvider.value(
                value: serviceLocator<LoginViewModel>(),
                child: LoginView(),
              ),
        ),
      );
    }
  }
}