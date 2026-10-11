import 'package:flutter/material.dart';
import 'package:location_tracking/app/route/app_routes.dart';
import 'package:location_tracking/core/constants/app_colors.dart';
import 'package:location_tracking/core/constants/app_size.dart';
import 'package:location_tracking/core/dio/injection_container.dart';
import 'package:location_tracking/core/local_database/auth_db.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // 2 second delay for splash
    await Future.delayed(const Duration(seconds: 2));
    
    final token = await getIt<AuthLocalDB>().getToken();
    final userType = await getIt<AuthLocalDB>().getUserType();
    final normalizedRole = userType?.toUpperCase().trim();

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      if (normalizedRole == 'JOB_SEEKER') {
        Navigator.pushReplacementNamed(context, AppRoutes.jobSeekerHome);
      } else if (normalizedRole == 'HOTELIER' || normalizedRole == 'HIRING') {
        Navigator.pushReplacementNamed(context, AppRoutes.hotelierHome);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.roleSelectionPage);
      }
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.roleSelectionPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.location_on,
              size: 80,
              color: AppColors.primary,
            ),
            AppSize.gapH16,
            Text(
              'Location Tracker',
              style: context.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
