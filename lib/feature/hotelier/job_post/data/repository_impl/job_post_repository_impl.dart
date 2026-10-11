import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failures.dart';
import '../../domain/entity/hotelier_job_posts_response_entity.dart';
import '../../domain/entity/job_post_request_entity.dart';
import '../../domain/entity/job_post_response_entity.dart';
import '../../domain/repository/job_post_repository.dart';
import '../data_source/job_post_remote_data_source.dart';
import '../model/job_post_request_model.dart';

@LazySingleton(as: JobPostRepository)
class JobPostRepositoryImpl implements JobPostRepository {
  final JobPostRemoteDataSource remoteDataSource;

  JobPostRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, JobPostResponseEntity>> createJobPost(
    JobPostRequestEntity request,
  ) async {
    try {
      final response = await remoteDataSource.createJobPost(
        payload: JobPostRequestModel.fromEntity(request),
      );
      return Right(response.toEntity());
    } catch (e, stackTrace) {
      return Left(handleException(e, stackTrace));
    }
  }

  @override
  Future<Either<Failure, HotelierJobPostsResponseEntity>>
      getHotelierJobPosts() async {
    try {
      final response = await remoteDataSource.getHotelierJobPosts();
      return Right(response.toEntity());
    } catch (e, stackTrace) {
      return Left(handleException(e, stackTrace));
    }
  }
}
