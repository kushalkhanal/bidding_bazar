
import 'package:bidding_bazar/app.dart';
import 'package:bidding_bazar/core/di/service_locator.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(const App());
}