import 'package:flutter/material.dart';
import 'package:location_tracking/core/constants/app_colors.dart';
import 'package:location_tracking/core/constants/app_size.dart';
import '../role_selection/role_selection_page.dart';
import 'package:location_tracking/core/dio/injection_container.dart';
import 'package:location_tracking/core/local_database/auth_db.dart';
import 'package:location_tracking/feature/job_seeker/auth/presentation/page/job_seeker_home_page.dart';

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
    
    if (mounted) {
      final token = await getIt<AuthLocalDB>().getToken();
      final userType = await getIt<AuthLocalDB>().getUserType();
      
      if (token != null && token.isNotEmpty && userType == 'JOB_SEEKER') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const JobSeekerHomePage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RoleSelectionPage()),
        );
      }
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
