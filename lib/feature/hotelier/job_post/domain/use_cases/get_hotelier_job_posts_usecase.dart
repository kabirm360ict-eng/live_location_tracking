import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/errors/failures.dart';
import '../entity/hotelier_job_posts_response_entity.dart';
import '../repository/job_post_repository.dart';

@injectable
class GetHotelierJobPostsUseCase {
  final JobPostRepository repository;

  GetHotelierJobPostsUseCase(this.repository);

  Future<Either<Failure, HotelierJobPostsResponseEntity>> call() {
    return repository.getHotelierJobPosts();
  }
}
