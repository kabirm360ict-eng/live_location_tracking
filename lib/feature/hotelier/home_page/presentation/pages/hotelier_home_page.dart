import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_tracking/app/route/app_routes.dart';
import 'package:location_tracking/core/constants/app_size.dart';
import '../../../job_post/domain/entity/hotelier_job_posts_response_entity.dart';
import '../../../job_post/presentation/bloc/job_post_bloc.dart';

class HotelierHomePage extends StatefulWidget {
  const HotelierHomePage({super.key});

  @override
  State<HotelierHomePage> createState() => _HotelierHomePageState();
}

class _HotelierHomePageState extends State<HotelierHomePage> {
  List<HotelierJobPostItemEntity> _jobPosts = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JobPostBloc>().add(GetHotelierJobPostsEvent());
    });
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'applied':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'work finished':
        return Colors.purple;
      case 'expired':
        return Colors.grey;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotelier Home'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context,AppRoutes.roleSelectionPage,(route) => false,);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<JobPostBloc>().add(GetHotelierJobPostsEvent());
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSize.p24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.hotel,
                size: 80,
                color: theme.colorScheme.primary,
              ),
              AppSize.gapH16,
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
            // ElevatedButton.icon(
            //   onPressed: () {
            //     Navigator.pushNamed(context, AppRoutes.hotelierSavedAddress);
            //   },
            //   icon: const Icon(Icons.location_on),
            //   label: const Text('Saved Address'),
            //   style: ElevatedButton.styleFrom(
            //     padding: const EdgeInsets.symmetric(vertical: AppSize.p16),
            //   ),
            // ),
              ElevatedButton.icon(
                onPressed: () async {
                  await Navigator.pushNamed(
                    context,
                    AppRoutes.createJobPostPage,
                  );
                  if (context.mounted) {
                    context.read<JobPostBloc>().add(GetHotelierJobPostsEvent());
                  }
                },
                icon: const Icon(Icons.post_add),
                label: const Text('Create Job Post'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppSize.p16),
                ),
              ),
              AppSize.gapH24,

              // Section Header: Job Posts
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Job Posts (${_jobPosts.length})',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Refresh',
                    onPressed: () {
                      context.read<JobPostBloc>().add(GetHotelierJobPostsEvent());
                    },
                  ),
                ],
              ),
              AppSize.gapH8,

              // Job Posts List / State Builder
              BlocConsumer<JobPostBloc, JobPostState>(
                listener: (context, state) {
                  if (state is GetHotelierJobPostsSuccessState) {
                    setState(() {
                      _jobPosts = state.response.data ?? [];
                    });
                  } else if (state is GetHotelierJobPostsFailedState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(state.message),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is GetHotelierJobPostsLoadingState &&_jobPosts.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(AppSize.p32),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (state is GetHotelierJobPostsFailedState &&_jobPosts.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(AppSize.p24),
                      child: Column(
                        children: [
                          Text(
                            state.message,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          AppSize.gapH16,
                          OutlinedButton.icon(
                            onPressed: () {
                              context.read<JobPostBloc>().add(GetHotelierJobPostsEvent());
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Try Again'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (_jobPosts.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(AppSize.p32),
                      child: Center(
                        child: Text(
                          'No job posts found yet.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _jobPosts.length,
                    separatorBuilder: (context, index) => AppSize.gapH16,
                    itemBuilder: (context, index) {
                      final item = _jobPosts[index];
                      final statusColor =_getStatusColor(item.jobPostDetailsStatus);

                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(AppSize.radiusMd),),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(AppSize.radiusMd),
                          onTap: () {
                            if (item.id != null) {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.hotelierJobPostDetails,
                                arguments: item.id,
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(AppSize.p16),
                            child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Row with Title & Status Badge
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.title ?? 'Job Post',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          item.jobNo ?? '',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusColor.withValues(
                                        alpha: 0.12,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(6),
                                      border:
                                          Border.all(color: statusColor),
                                    ),
                                    child: Text(
                                      item.jobPostDetailsStatus ?? '',
                                      style: TextStyle(
                                        color: statusColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 24),

                              // Details: Hourly rate, Vacancy
                              Row(
                                children: [
                                  const Icon(
                                    Icons.attach_money,
                                    size: 18,
                                    color: Colors.green,
                                  ),
                                  Text(
                                    '\$${item.hourlyRate ?? '0'}/hr',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.people_outline,
                                    size: 18,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(width: 4),
                                  Text('Vacancy: ${item.vacancy ?? 1}'),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Time Range
                              Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      '${item.startTime ?? ''} - ${item.endTime ?? ''}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade700,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),

                              // Job Seeker Applicant Section (if applied)
                              if (item.jobSeekerDetails != null) ...[
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withValues(
                                      alpha: 0.06,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    children: [
                                      const CircleAvatar(
                                        radius: 14,
                                        child: Icon(Icons.person, size: 16),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Applicant: ${item.jobSeekerDetails?.jobSeekerName ?? ''}',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        item.jobSeekerDetails
                                                ?.applicationStatus ??
                                            '',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
