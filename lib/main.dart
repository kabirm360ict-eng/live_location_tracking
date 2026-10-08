import 'package:flutter/material.dart';
import 'package:location_tracking/app/app.dart';
import 'package:location_tracking/core/dio/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(); // Firebase is not configured yet
  await configureDependencies();
  runApp(const MyApp());
}
