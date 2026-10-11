import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_tracking/app/route/app_routes.dart';
import 'package:location_tracking/core/constants/app_size.dart';
import 'package:location_tracking/feature/job_seeker/auth/presentation/bloc/auth_job_bloc.dart';

class JobSeekerHomePage extends StatefulWidget {
  const JobSeekerHomePage({super.key});

  @override
  State<JobSeekerHomePage> createState() => _JobSeekerHomePageState();
}

class _JobSeekerHomePageState extends State<JobSeekerHomePage> {
  void _logout() {
    context.read<AuthJobBloc>().add(LogOutEvent());
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.roleSelectionPage,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSize.p24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.account_circle,
              size: 100,
              color: theme.colorScheme.primary,
            ),
            AppSize.gapH24,
            Text(
              'Welcome Back!',
              textAlign: TextAlign.center,
              style: context.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSize.gapH8,
            const Text(
              'You have successfully logged in.',
              textAlign: TextAlign.center,
            ),
            AppSize.gapH24,
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.jobSeekerSavedAddress);
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: AppSize.p16),
              ),
            ),
            AppSize.gapH16,
            // OutlinedButton.icon(
            //   onPressed: _logout,
            //   icon: const Icon(Icons.logout, color: Colors.red),
            //   label: const Text(
            //     'Log Out',
            //     style: TextStyle(color: Colors.red),
            //   ),
            //   style: OutlinedButton.styleFrom(
            //     padding: const EdgeInsets.symmetric(vertical: AppSize.p16),
            //     side: const BorderSide(color: Colors.red),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}