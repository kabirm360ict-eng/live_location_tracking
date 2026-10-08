import 'package:flutter/material.dart';
import 'package:location_tracking/app/route/app_routes.dart';
import 'package:location_tracking/core/constants/app_size.dart';

class JobSeekerHomePage extends StatefulWidget {
  const JobSeekerHomePage({super.key});

  @override
  State<JobSeekerHomePage> createState() => _JobSeekerHomePageState();
}

class _JobSeekerHomePageState extends State<JobSeekerHomePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Implement Logout
            },
            icon: const Icon(Icons.logout),
          )
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
              color:theme.colorScheme.primary,
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
            Text(
              'You have successfully logged in.',
              textAlign: TextAlign.center,
            ),
            AppSize.gapH24,
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Navigate to Edit Profile Page
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(content: Text('Edit Profile Clicked')),
                // );
                // Navigator.pushNamed(context, Approutes)
                Navigator.pushNamed(context, AppRoutes.jobSeekerSavedAddress);
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: AppSize.p16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}