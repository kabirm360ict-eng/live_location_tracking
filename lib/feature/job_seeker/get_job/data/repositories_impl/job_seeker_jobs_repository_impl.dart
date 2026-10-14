import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failures.dart';
import '../../domain/entities/job_seeker_jobs_response_entity.dart';
import '../../domain/repositories/job_seeker_jobs_repository.dart';
import '../data_source/job_seeker_jobs_remote_data_source.dart';

@LazySingleton(as: JobSeekerJobsRepository)
class JobSeekerJobsRepositoryImpl implements JobSeekerJobsRepository {
  final JobSeekerJobsRemoteDataSource remoteDataSource;

  JobSeekerJobsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, JobSeekerJobsResponseEntity>> getJobSeekerJobs({
    String preferredJob = 'ALL',
  }) async {
    try {
      final responseModel = await remoteDataSource.getJobs(
        preferredJob: preferredJob,
      );
      return Right(responseModel.toEntity());
    } catch (e, stackTrace) {
      return Left(handleException(e, stackTrace));
    }
  }
}
