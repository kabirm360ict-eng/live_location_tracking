import 'package:flutter/material.dart';
import 'package:location_tracking/app/route/app_routes.dart';
import 'package:location_tracking/feature/job_seeker/auth/presentation/page/login_page_job_seeker.dart';
import 'package:location_tracking/feature/splash_screen/splash_screen.dart';
import 'package:page_transition/page_transition.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings){
    switch (settings.name){
      case AppRoutes.splashScreen:
       return PageTransition(
        type: PageTransitionType.fade,
        child: SplashScreen(),
        settings: settings
        );
      case AppRoutes.jobSeekerLogin:
       return PageTransition(
        type: PageTransitionType.fade,
        child: LoginPageJobSeeker(),
        settings: settings
        );
      

      default:
       return MaterialPageRoute(builder: (_) => Scaffold(
        body: Center(
          child: Text('Route not found'),
          ),
      ));
    }
  }
}