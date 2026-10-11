import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../entity/hotelier_job_posts_response_entity.dart';
import '../entity/hotelier_single_job_post_response_entity.dart';
import '../entity/job_post_request_entity.dart';
import '../entity/job_post_response_entity.dart';

abstract class JobPostRepository {
  Future<Either<Failure, JobPostResponseEntity>> createJobPost(JobPostRequestEntity request,);

  Future<Either<Failure, HotelierJobPostsResponseEntity>> getHotelierJobPosts();

  Future<Either<Failure, HotelierSingleJobPostResponseEntity>>getHotelierJobPostDetails(int id);
}
