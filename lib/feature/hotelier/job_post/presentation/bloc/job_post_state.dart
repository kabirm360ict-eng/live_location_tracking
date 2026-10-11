part of 'job_post_bloc.dart';

@immutable
sealed class JobPostState {}

final class JobPostInitial extends JobPostState {}

// Create Job Post States
final class CreateJobPostLoadingState extends JobPostState {}

final class CreateJobPostSuccessState extends JobPostState {
  final JobPostResponseEntity response;

  CreateJobPostSuccessState({required this.response});
}

final class CreateJobPostFailedState extends JobPostState {
  final String message;

  CreateJobPostFailedState({required this.message});
}

// Get Hotelier Job Posts States
final class GetHotelierJobPostsLoadingState extends JobPostState {}

final class GetHotelierJobPostsSuccessState extends JobPostState {
  final HotelierJobPostsResponseEntity response;

  GetHotelierJobPostsSuccessState({required this.response});
}

final class GetHotelierJobPostsFailedState extends JobPostState {
  final String message;

  GetHotelierJobPostsFailedState({required this.message});
}

// Get Hotelier Job Post Details States
final class GetHotelierJobPostDetailsLoadingState extends JobPostState {}

final class GetHotelierJobPostDetailsSuccessState extends JobPostState {
  final HotelierSingleJobPostResponseEntity response;

  GetHotelierJobPostDetailsSuccessState({required this.response});
}

final class GetHotelierJobPostDetailsFailedState extends JobPostState {
  final String message;

  GetHotelierJobPostDetailsFailedState({required this.message});
}
