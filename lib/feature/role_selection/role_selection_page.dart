import 'package:flutter/material.dart';
import 'package:location_tracking/app/route/app_routes.dart';
import 'package:location_tracking/core/constants/app_colors.dart';
import 'package:location_tracking/core/constants/app_size.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Role'), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSize.p24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Who are you?',
                textAlign: TextAlign.center,
                style: context.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppSize.gapH32,
              _buildRoleCard(
                context,
                title: 'Hotelier',
                icon: Icons.hotel,
                color: AppColors.primary,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.hotelierLogin);
                },
              ),
              AppSize.gapH24,
              _buildRoleCard(
                context,
                title: 'Residentail',
                icon: Icons.home,
                color: AppColors.primary,
                onTap: () {
                  // TODO: Navigate to User Auth
                  debugPrint("User selected");
                },
              ),
              AppSize.gapH24,
              _buildRoleCard(
                context,
                title: 'Worker',
                icon: Icons.person,
                color: AppColors.primary,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.jobSeekerLogin);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    Color? color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSize.radiusLg),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSize.p16),
        decoration: BoxDecoration(
          color: color?.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSize.radiusLg),
          // border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
        ),
        child: Column(
          children: [
            Icon(icon, size: AppSize.iconXl, color: color),
            AppSize.gapH16,
            Text(
              title,
              style: context.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
