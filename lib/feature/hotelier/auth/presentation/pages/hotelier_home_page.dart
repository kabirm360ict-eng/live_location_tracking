import 'package:flutter/material.dart';
import 'package:location_tracking/app/route/app_routes.dart';
import 'package:location_tracking/core/constants/app_size.dart';

class HotelierHomePage extends StatefulWidget {
  const HotelierHomePage({super.key});

  @override
  State<HotelierHomePage> createState() => _HotelierHomePageState();
}

class _HotelierHomePageState extends State<HotelierHomePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotelier Home'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.roleSelectionPage,
                (route) => false,
              );
            },
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
              Icons.hotel,
              size: 100,
              color: theme.colorScheme.primary,
            ),
            AppSize.gapH24,
            Text(
              'Welcome Back, Hotelier!',
              textAlign: TextAlign.center,
              style: context.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSize.gapH8,
            const Text(
              'You have successfully logged in as Hotelier.',
              textAlign: TextAlign.center,
            ),
            AppSize.gapH24,
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.hotelierSavedAddress);
              },
              icon: const Icon(Icons.location_on),
              label: const Text('Saved Address'),
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
