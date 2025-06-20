import 'package:bidding_bazar/app/service_locator/service_locator.dart';
import 'package:bidding_bazar/features/splash/presentation/view/splash_view.dart';
import 'package:bidding_bazar/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Bidding Bazar",
      debugShowCheckedModeBanner: false,
      home: BlocProvider.value(
        value: serviceLocator<SplashViewModel>(),
        child: SplashView(),
      ),
    );
  }
}