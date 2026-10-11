import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/errors/failures.dart';
import '../entity/job_post_request_entity.dart';
import '../entity/job_post_response_entity.dart';
import '../repository/job_post_repository.dart';

@injectable
class CreateJobPostUseCase {
  final JobPostRepository repository;

  CreateJobPostUseCase(this.repository);

  Future<Either<Failure, JobPostResponseEntity>> call(
    JobPostRequestEntity request,
  ) {
    return repository.createJobPost(request);
  }
}
