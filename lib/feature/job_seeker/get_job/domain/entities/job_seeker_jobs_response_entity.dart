import 'package:equatable/equatable.dart';
import 'job_seeker_job_item_entity.dart';

class JobSeekerJobsResponseEntity extends Equatable {
  final bool? success;
  final String? message;
  final List<JobSeekerJobItemEntity>? data;
  final int? total;

  const JobSeekerJobsResponseEntity({
    this.success,
    this.message,
    this.data,
    this.total,
  });

  @override
  List<Object?> get props => [success, message, data, total];
}
