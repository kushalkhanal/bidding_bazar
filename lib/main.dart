// lib/main.dart

import 'package:bidding_bazar/app/service_locator.dart' as di;
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart'; // Import your new App widget


void main() async {
  // 1. Ensure Flutter engine is ready
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Initialize Hive for local storage
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());

  // 3. Initialize our dependencies using the Service Locator
  await di.init();
  
  // 4. Run the main App widget
  runApp(const App());
}