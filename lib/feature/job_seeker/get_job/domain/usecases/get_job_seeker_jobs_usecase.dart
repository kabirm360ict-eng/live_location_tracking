import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/job_seeker_jobs_response_entity.dart';
import '../repositories/job_seeker_jobs_repository.dart';

@injectable
class GetJobSeekerJobsUseCase {
  final JobSeekerJobsRepository repository;

  GetJobSeekerJobsUseCase(this.repository);

  Future<Either<Failure, JobSeekerJobsResponseEntity>> call({
    String preferredJob = 'ALL',
  }) {
    return repository.getJobSeekerJobs(preferredJob: preferredJob);
  }
}
