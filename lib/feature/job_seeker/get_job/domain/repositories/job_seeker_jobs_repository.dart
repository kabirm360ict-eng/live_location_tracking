import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/job_seeker_jobs_response_entity.dart';

abstract class JobSeekerJobsRepository {
  Future<Either<Failure, JobSeekerJobsResponseEntity>> getJobSeekerJobs({
    String preferredJob = 'ALL',
  });
}
