import 'package:flutter/material.dart';
import 'package:location_tracking/app/app_theme.dart';
import 'package:location_tracking/app/route/app_router.dart';
import 'package:location_tracking/app/route/app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_tracking/core/dio/injection_container.dart';
import 'package:location_tracking/feature/job_seeker/auth/presentation/bloc/auth_job_bloc.dart';

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AuthJobBloc>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.splashScreen,
        navigatorKey: navigatorKey,
        onGenerateRoute: AppRouter.onGenerateRoute,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
      ),
    );
  }
}