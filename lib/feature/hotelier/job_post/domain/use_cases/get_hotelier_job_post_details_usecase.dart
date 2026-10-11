import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/errors/failures.dart';
import '../entity/hotelier_single_job_post_response_entity.dart';
import '../repository/job_post_repository.dart';

@injectable
class GetHotelierJobPostDetailsUseCase {
  final JobPostRepository repository;

  GetHotelierJobPostDetailsUseCase(this.repository);

  Future<Either<Failure, HotelierSingleJobPostResponseEntity>> call(int id) {
    return repository.getHotelierJobPostDetails(id);
  }
}
