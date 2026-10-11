part of 'job_post_bloc.dart';

@immutable
sealed class JobPostEvent {}

final class CreateJobPostEvent extends JobPostEvent {
  final JobPostRequestEntity request;

  CreateJobPostEvent(this.request);
}

final class GetHotelierJobPostsEvent extends JobPostEvent {}
