import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:location_tracking/feature/hotelier/job_post/domain/entity/create_job_post_usecase.dart';
import '../../domain/entity/job_post_request_entity.dart';
import '../../domain/entity/job_post_response_entity.dart';

part 'job_post_event.dart';
part 'job_post_state.dart';

@lazySingleton
class JobPostBloc extends Bloc<JobPostEvent, JobPostState> {
  final CreateJobPostUseCase _createJobPostUseCase;

  JobPostBloc(this._createJobPostUseCase) : super(JobPostInitial()) {
    on<CreateJobPostEvent>(_onCreateJobPost);
  }

  Future<void> _onCreateJobPost(
    CreateJobPostEvent event,
    Emitter<JobPostState> emit,
  ) async {
    emit(CreateJobPostLoadingState());

    final result = await _createJobPostUseCase(event.request);

    result.fold(
      (failure) => emit(CreateJobPostFailedState(message: failure.message)),
      (response) => emit(CreateJobPostSuccessState(response: response)),
    );
  }
}
