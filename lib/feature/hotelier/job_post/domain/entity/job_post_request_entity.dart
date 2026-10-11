import 'package:equatable/equatable.dart';

class JobPostRequestEntity extends Equatable {
  final int? jobId;
  final String? startTime;
  final String? endTime;
  final int? vacancy;
  final String? timezone;

  const JobPostRequestEntity({
    this.jobId,
    this.startTime,
    this.endTime,
    this.vacancy,
    this.timezone,
  });

  @override
  List<Object?> get props => [
        jobId,
        startTime,
        endTime,
        vacancy,
        timezone,
      ];
}
