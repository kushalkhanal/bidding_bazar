// lib/app.dart

import 'package:flutter/material.dart';
import 'features/auth/presentation/view/login_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bidding Bazar',
      debugShowCheckedModeBanner: false, // Optional: hides the debug banner
      theme: ThemeData(
        // Define your app's theme here
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // The first screen the user will see is the LoginPage.
      // We will add logic here later to check if the user is already logged in.
      home: LoginPage(),
    );
  }
}