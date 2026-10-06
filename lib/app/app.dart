import 'package:flutter/material.dart';
import 'package:location_tracking/app/app_theme.dart';
import 'package:location_tracking/app/route/app_router.dart';
import 'package:location_tracking/app/route/app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splashScreen,
      onGenerateRoute: AppRouter.onGenerateRoute,
      theme: AppTheme.lightTheme,
    );
  }
}