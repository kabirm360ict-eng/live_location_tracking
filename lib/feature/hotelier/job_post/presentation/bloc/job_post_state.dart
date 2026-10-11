part of 'job_post_bloc.dart';

@immutable
sealed class JobPostState {}

final class JobPostInitial extends JobPostState {}

final class CreateJobPostLoadingState extends JobPostState {}

final class CreateJobPostSuccessState extends JobPostState {
  final JobPostResponseEntity response;

  CreateJobPostSuccessState({required this.response});
}

final class CreateJobPostFailedState extends JobPostState {
  final String message;

  CreateJobPostFailedState({required this.message});
}
