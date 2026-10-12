import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_tracking/app/route/app_routes.dart';
import 'package:location_tracking/core/constants/app_size.dart';
import 'package:location_tracking/feature/job_seeker/auth/presentation/bloc/auth_job_bloc.dart';
import 'package:location_tracking/core/service/job_seeker_tracking_service.dart';

class JobSeekerHomePage extends StatefulWidget {
  const JobSeekerHomePage({super.key});

  @override
  State<JobSeekerHomePage> createState() => _JobSeekerHomePageState();
}

class _JobSeekerHomePageState extends State<JobSeekerHomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      JobSeekerTrackingService().initSocket();
      JobSeekerTrackingService().checkGpsStatus();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      JobSeekerTrackingService().checkGpsStatus();
    }
  }

  void _logout() {
    JobSeekerTrackingService().disconnect();
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
        child: SingleChildScrollView(
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
              AppSize.gapH16,
              AnimatedBuilder(
                animation: Listenable.merge([
                  JobSeekerTrackingService().isConnectedNotifier,
                  JobSeekerTrackingService().isTrackingActiveNotifier,
                  JobSeekerTrackingService().isGpsEnabledNotifier,
                  JobSeekerTrackingService().lastSentPositionNotifier,
                  JobSeekerTrackingService().lastSentTimeNotifier,
                ]),
                builder: (context, _) {
                  final service = JobSeekerTrackingService();
                  final isConnected = service.isConnected;
                  final isTracking = service.isTrackingActive;
                  final isGpsOn = service.isGpsEnabledNotifier.value;
                  final lastPos = service.lastSentPositionNotifier.value;
                  final lastTime = service.lastSentTimeNotifier.value;

                  Widget statusWidget;
          
                  if (!isConnected) {
                    statusWidget = Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Disconnected from Server',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Offline. Cannot receive live tracking requests.',
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 10),
                          OutlinedButton.icon(
                            onPressed: () => service.reconnect(),
                            icon: const Icon(Icons.refresh, size: 16),
                            label: const Text('Reconnect Now'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: BorderSide(color: Colors.red.shade300),
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (isTracking) {
                    statusWidget = Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.green.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.greenAccent.shade700,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Live Location Sharing Active',
                                style: TextStyle(
                                  color: Colors.green.shade800,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Hotelier is currently viewing your live movement.',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontSize: 12,
                            ),
                          ),
                          if (lastPos != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Last sent: ${lastPos.latitude.toStringAsFixed(4)}, ${lastPos.longitude.toStringAsFixed(4)}${lastTime != null ? ' (${lastTime.hour.toString().padLeft(2, '0')}:${lastTime.minute.toString().padLeft(2, '0')}:${lastTime.second.toString().padLeft(2, '0')})' : ''}',
                              style: TextStyle(
                                color: Colors.green.shade900,
                                fontSize: 11,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'ID: ${service.currentUserId ?? "?"} | Sock: ${service.socketId ?? "?"}',
                                style: TextStyle(fontSize: 10, color: Colors.green.shade800),
                              ),
                            ],
                          ),
                          OutlinedButton.icon(
                            onPressed: () => service.stopTracking(),
                            icon: const Icon(Icons.stop, size: 14, color: Colors.red),
                            label: const Text('Stop Sharing', style: TextStyle(color: Colors.red, fontSize: 11)),
                            style: OutlinedButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              side: const BorderSide(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    statusWidget = Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.blueGrey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blueGrey.shade400,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Online - Standby',
                                      style: TextStyle(
                                        color: Colors.blueGrey.shade800,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Ready to share GPS when Hotelier opens tracking.',
                                      style: TextStyle(
                                        color: Colors.blueGrey.shade600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'ID: ${service.currentUserId ?? "?"} | Sock: ${service.socketId ?? "?"}',
                                style: TextStyle(fontSize: 10, color: Colors.blueGrey.shade700),
                              ),
                            ],
                          ),
                          OutlinedButton.icon(
                            onPressed: () => service.startTracking(),
                            icon: const Icon(Icons.play_arrow, size: 14),
                            label: const Text('Test Send GPS', style: TextStyle(fontSize: 11)),
                            style: OutlinedButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: [
                      if (!isGpsOn)
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.amber.shade400),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.location_off, color: Colors.amber.shade800, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Phone GPS / Location is turned OFF!',
                                  style: TextStyle(
                                    color: Colors.amber.shade900,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await Geolocator.openLocationSettings();
                                  await service.checkGpsStatus();
                                },
                                child: const Text('Turn ON'),
                              ),
                            ],
                          ),
                        ),
                      statusWidget,
                    ],
                  );
                },
              ),
              AppSize.gapH24,
              // ElevatedButton.icon(
              //   onPressed: () {
              //     Navigator.pushNamed(context, AppRoutes.jobSeekerSavedAddress);
              //   },
              //   icon: const Icon(Icons.edit),
              //   label: const Text('Edit Profile'),
              //   style: ElevatedButton.styleFrom(
              //     padding: const EdgeInsets.symmetric(vertical: AppSize.p16),
              //   ),
              // ),
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
      ),
    );
  }
}