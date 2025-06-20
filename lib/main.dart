import 'package:bidding_bazar/app/app.dart';
import 'package:bidding_bazar/app/service_locator/service_locator.dart';
import 'package:bidding_bazar/core/network/hive_service.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  await HiveService().init();
 

  runApp(App());
}