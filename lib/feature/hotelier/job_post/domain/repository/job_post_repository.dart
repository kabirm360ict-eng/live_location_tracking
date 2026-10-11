import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../entity/job_post_request_entity.dart';
import '../entity/job_post_response_entity.dart';

abstract class JobPostRepository {
  Future<Either<Failure, JobPostResponseEntity>> createJobPost(
    JobPostRequestEntity request,
  );
}
