import 'package:flutter/material.dart';
import 'package:location_tracking/app/route/app_routes.dart';
import 'package:location_tracking/feature/hotelier/auth/presentation/pages/hotelier_home_page.dart';
import 'package:location_tracking/feature/hotelier/auth/presentation/pages/hotelier_login_page.dart';
import 'package:location_tracking/feature/hotelier/profile/data/model/profile_response_model_hiring.dart';
import 'package:location_tracking/feature/hotelier/profile/presentation/pages/hotelier_edit_address_page.dart';
import 'package:location_tracking/feature/hotelier/profile/presentation/pages/hotelier_saved_address_page.dart';
import 'package:location_tracking/feature/job_seeker/auth/presentation/page/login_page_job_seeker.dart';
import 'package:location_tracking/feature/job_seeker/location/presentation/page/custom_address_page.dart';
import 'package:location_tracking/feature/job_seeker/profile/presentation/pages/edit_address_page.dart';
import 'package:location_tracking/feature/job_seeker/profile/presentation/pages/saved_address_pages.dart';
import 'package:location_tracking/feature/job_seeker/profile/data/model/profile_get_job_seeker_model.dart';
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
      case AppRoutes.hotelierLogin:
       return PageTransition(
        type: PageTransitionType.fade,
        child: const HotelierLoginPage(),
        settings: settings
        );
      case AppRoutes.hotelierHome:
       return PageTransition(
        type: PageTransitionType.fade,
        child: const HotelierHomePage(),
        settings: settings
        );
      case AppRoutes.hotelierSavedAddress:
       return PageTransition(
        type: PageTransitionType.fade,
        child: const HotelierSavedAddressPage(),
        settings: settings
        );
      case AppRoutes.hotelierEditAddress:
       final profile = settings.arguments as ProfileResponseModelHiring?;
       return PageTransition(
        type: PageTransitionType.fade,
        child: HotelierEditAddressPage(initialProfile: profile),
        settings: settings
        );
      case AppRoutes.jobSeekerSavedAddress:
       return PageTransition(
        type: PageTransitionType.fade,
        child: SavedAddressPage(),
        settings: settings
        );
      case AppRoutes.editAddressPage:
       final profile = settings.arguments as ProfileGetJobSeekerModel?;
       return PageTransition(
        type: PageTransitionType.fade,
        settings: settings,
        child: EditAddressPage(initialProfile: profile)
        );
      case AppRoutes.customAddressPage:
       return PageTransition(
        type: PageTransitionType.fade,
        settings: settings,
        child: CustomAddressPage()
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