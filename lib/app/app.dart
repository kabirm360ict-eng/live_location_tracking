import 'package:flutter/material.dart';
import 'package:location_tracking/app/route/app_router.dart';
import 'package:location_tracking/app/route/app_routes.dart';
import '../feature/splash_screen/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splashScreen,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}