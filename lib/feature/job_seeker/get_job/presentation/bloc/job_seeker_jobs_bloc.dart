import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/job_seeker_job_item_entity.dart';
import '../../domain/entities/job_seeker_jobs_response_entity.dart';
import '../../domain/usecases/get_job_seeker_jobs_usecase.dart';

part 'job_seeker_jobs_event.dart';
part 'job_seeker_jobs_state.dart';

@lazySingleton
class JobSeekerJobsBloc extends Bloc<JobSeekerJobsEvent, JobSeekerJobsState> {
  final GetJobSeekerJobsUseCase _getJobSeekerJobsUseCase;

  JobSeekerJobsBloc(this._getJobSeekerJobsUseCase) : super(JobSeekerJobsInitial()) {
    on<GetJobSeekerJobsEvent>(_onGetJobSeekerJobs);
  }

  Future<void> _onGetJobSeekerJobs(
    GetJobSeekerJobsEvent event,
    Emitter<JobSeekerJobsState> emit,
  ) async {
    emit(JobSeekerJobsLoadingState());

    final result = await _getJobSeekerJobsUseCase(
      preferredJob: event.preferredJob,
    );

    result.fold(
      (failure) => emit(JobSeekerJobsFailedState(message: failure.message)),
      (response) => emit(
        JobSeekerJobsLoadedState(
          response: response,
          jobs: response.data ?? [],
        ),
      ),
    );
  }
}
