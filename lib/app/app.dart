import 'package:bidding_bazar/app/auth_wrapper.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Bidding Bazar",
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
    );
  }
}
