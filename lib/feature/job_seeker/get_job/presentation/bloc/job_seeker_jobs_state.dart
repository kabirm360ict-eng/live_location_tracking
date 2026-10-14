part of 'job_seeker_jobs_bloc.dart';

@immutable
sealed class JobSeekerJobsState extends Equatable {
  const JobSeekerJobsState();

  @override
  List<Object?> get props => [];
}

final class JobSeekerJobsInitial extends JobSeekerJobsState {}

final class JobSeekerJobsLoadingState extends JobSeekerJobsState {}

final class JobSeekerJobsLoadedState extends JobSeekerJobsState {
  final JobSeekerJobsResponseEntity response;
  final List<JobSeekerJobItemEntity> jobs;

  const JobSeekerJobsLoadedState({
    required this.response,
    required this.jobs,
  });

  @override
  List<Object?> get props => [response, jobs];
}

final class JobSeekerJobsFailedState extends JobSeekerJobsState {
  final String message;

  const JobSeekerJobsFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}
