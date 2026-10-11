import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_tracking/core/constants/app_size.dart';
import '../../domain/entity/hotelier_single_job_post_response_entity.dart';
import '../bloc/job_post_bloc.dart';

class HotelierJobPostDetailsPage extends StatefulWidget {
  final int jobPostDetailId;

  const HotelierJobPostDetailsPage({
    super.key,
    required this.jobPostDetailId,
  });

  @override
  State<HotelierJobPostDetailsPage> createState() =>
      _HotelierJobPostDetailsPageState();
}

class _HotelierJobPostDetailsPageState
    extends State<HotelierJobPostDetailsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JobPostBloc>().add(
            GetHotelierJobPostDetailsEvent(widget.jobPostDetailId),
          );
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
        title: const Text('Job Post Details'),
        centerTitle: true,
      ),
      body: BlocBuilder<JobPostBloc, JobPostState>(
        builder: (context, state) {
          if (state is GetHotelierJobPostDetailsLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GetHotelierJobPostDetailsFailedState) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSize.p24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    AppSize.gapH16,
                    Text(
                      state.message,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    AppSize.gapH16,
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<JobPostBloc>().add(
                              GetHotelierJobPostDetailsEvent(
                                widget.jobPostDetailId,
                              ),
                            );
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is GetHotelierJobPostDetailsSuccessState) {
            final data = state.response.data;
            if (data == null) {
              return const Center(child: Text('No details available.'));
            }

            final statusColor = _getStatusColor(data.jobPostDetailsStatus);

            return RefreshIndicator(
              onRefresh: () async {
                context.read<JobPostBloc>().add(
                      GetHotelierJobPostDetailsEvent(
                        widget.jobPostDetailId,
                      ),
                    );
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppSize.p16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Card
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSize.radiusMd),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSize.p16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data.title ?? 'Job Post',
                                        style: theme.textTheme.titleLarge
                                            ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        data.jobNo ?? '',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: statusColor),
                                  ),
                                  child: Text(
                                    data.jobPostDetailsStatus ?? '',
                                    style: TextStyle(
                                      color: statusColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            Row(
                              children: [
                                if (data.jobId != null) ...[
                                  Text(
                                    'Job ID: ${data.jobId}',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                ],
                                if (data.jobPostId != null) ...[
                                  Text(
                                    'Post ID: ${data.jobPostId}',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    AppSize.gapH16,

                    // Applicant / Job Seeker Details Card
                    if (data.jobSeekerDetails != null) ...[
                      _buildApplicantCard(data.jobSeekerDetails!, theme),
                      AppSize.gapH16,
                    ],

                    // Key Information Card
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSize.radiusMd),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSize.p16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Schedule & Payment',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            AppSize.gapH16,
                            _buildInfoRow(
                              icon: Icons.attach_money,
                              iconColor: Colors.green,
                              label: 'Hourly Rate',
                              value: '\$${data.hourlyRate ?? '0'}/hr',
                            ),
                            const Divider(height: 20),
                            _buildInfoRow(
                              icon: Icons.people_outline,
                              iconColor: Colors.blue,
                              label: 'Vacancy',
                              value: '${data.vacancy ?? 1} Person',
                            ),
                            const Divider(height: 20),
                            _buildInfoRow(
                              icon: Icons.access_time,
                              iconColor: Colors.orange,
                              label: 'Start Time',
                              value: data.startTime ?? 'N/A',
                            ),
                            const Divider(height: 20),
                            _buildInfoRow(
                              icon: Icons.timer_off_outlined,
                              iconColor: Colors.deepOrange,
                              label: 'End Time',
                              value: data.endTime ?? 'N/A',
                            ),
                            const Divider(height: 20),
                            _buildInfoRow(
                              icon: Icons.public,
                              iconColor: Colors.indigo,
                              label: 'Timezone',
                              value: data.timezone ?? 'Asia/Dhaka',
                            ),
                          ],
                        ),
                      ),
                    ),
                    AppSize.gapH16,

                    // Job Description Card
                    if (data.jobDetails != null && data.jobDetails!.isNotEmpty) ...[
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppSize.radiusMd),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSize.p16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Job Description',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              AppSize.gapH8,
                              Text(
                                data.jobDetails!,
                                style: TextStyle(
                                  color: Colors.grey.shade800,
                                  height: 1.5,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      AppSize.gapH16,
                    ],

                    
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 14,
          ),
        ),
        const Spacer(),
        Expanded(
          flex: 2,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildApplicantCard(
    SingleJobSeekerDetailsEntity applicant,
    ThemeData theme,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.radiusMd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSize.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Applicant Details',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    applicant.applicationStatus ?? '',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            AppSize.gapH16,
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.blue.shade100,
                  child: const Icon(Icons.person, size: 30, color: Colors.blue),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        applicant.jobSeekerName ?? 'Applicant',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (applicant.city != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          applicant.city!,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            if (applicant.locationAddress != null) ...[
              _buildInfoRow(
                icon: Icons.location_on_outlined,
                iconColor: Colors.red,
                label: 'Address',
                value: applicant.locationAddress!,
              ),
              const Divider(height: 20),
            ],
            if (applicant.chatSessionId != null) ...[
              _buildInfoRow(
                icon: Icons.chat_bubble_outline,
                iconColor: Colors.teal,
                label: 'Chat Session ID',
                value: '${applicant.chatSessionId}',
              ),
              const Divider(height: 20),
            ],
            if (applicant.latitude != null &&
                applicant.longitude != null) ...[
              _buildInfoRow(
                icon: Icons.map_outlined,
                iconColor: Colors.deepPurple,
                label: 'Coordinates',
                value: '${applicant.latitude}, ${applicant.longitude}',
              ),
            ],
          ],
        ),
      ),
    );
  }
}
