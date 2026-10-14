part of 'job_seeker_jobs_bloc.dart';

@immutable
sealed class JobSeekerJobsEvent extends Equatable {
  const JobSeekerJobsEvent();

  @override
  List<Object?> get props => [];
}

final class GetJobSeekerJobsEvent extends JobSeekerJobsEvent {
  final String preferredJob;

  const GetJobSeekerJobsEvent({this.preferredJob = 'ALL'});

  @override
  List<Object?> get props => [preferredJob];
}
