import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:location_tracking/feature/hotelier/job_post/domain/use_cases/create_job_post_usecase.dart';
import '../../domain/entity/hotelier_job_posts_response_entity.dart';
import '../../domain/entity/job_post_request_entity.dart';
import '../../domain/entity/job_post_response_entity.dart';
import '../../domain/use_cases/get_hotelier_job_posts_usecase.dart';

part 'job_post_event.dart';
part 'job_post_state.dart';

@lazySingleton
class JobPostBloc extends Bloc<JobPostEvent, JobPostState> {
  final CreateJobPostUseCase _createJobPostUseCase;
  final GetHotelierJobPostsUseCase _getHotelierJobPostsUseCase;

  JobPostBloc(
    this._createJobPostUseCase,
    this._getHotelierJobPostsUseCase,
  ) : super(JobPostInitial()) {
    on<CreateJobPostEvent>(_onCreateJobPost);
    on<GetHotelierJobPostsEvent>(_onGetHotelierJobPosts);
  }

  Future<void> _onCreateJobPost(
    CreateJobPostEvent event,
    Emitter<JobPostState> emit,
  ) async {
    emit(CreateJobPostLoadingState());

    final result = await _createJobPostUseCase(event.request);

    result.fold(
      (failure) => emit(CreateJobPostFailedState(message: failure.message)),
      (response) {
        emit(CreateJobPostSuccessState(response: response));
        add(GetHotelierJobPostsEvent());
      },
    );
  }

  Future<void> _onGetHotelierJobPosts(
    GetHotelierJobPostsEvent event,
    Emitter<JobPostState> emit,
  ) async {
    emit(GetHotelierJobPostsLoadingState());

    final result = await _getHotelierJobPostsUseCase();

    result.fold(
      (failure) =>
          emit(GetHotelierJobPostsFailedState(message: failure.message)),
      (response) => emit(GetHotelierJobPostsSuccessState(response: response)),
    );
  }
}
