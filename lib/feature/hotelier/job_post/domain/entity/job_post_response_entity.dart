import 'package:equatable/equatable.dart';

class JobPostResponseEntity extends Equatable {
  final bool? success;
  final String? message;
  final JobPostDataEntity? data;

  const JobPostResponseEntity({
    this.success,
    this.message,
    this.data,
  });

  @override
  List<Object?> get props => [success, message, data];
}

class JobPostDataEntity extends Equatable {
  final int? id;
  final List<JobPostDetailIdEntity>? jobPostDetailsId;

  const JobPostDataEntity({
    this.id,
    this.jobPostDetailsId,
  });

  @override
  List<Object?> get props => [id, jobPostDetailsId];
}

class JobPostDetailIdEntity extends Equatable {
  final int? id;

  const JobPostDetailIdEntity({
    this.id,
  });

  @override
  List<Object?> get props => [id];
}
