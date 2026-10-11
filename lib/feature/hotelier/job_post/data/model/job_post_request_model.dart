import '../../domain/entity/job_post_request_entity.dart';

class JobPostRequestModel {
  final int? jobId;
  final String? startTime;
  final String? endTime;
  final int? vacancy;
  final String? timezone;

  JobPostRequestModel({
    this.jobId,
    this.startTime,
    this.endTime,
    this.vacancy,
    this.timezone,
  });

  factory JobPostRequestModel.fromEntity(JobPostRequestEntity entity) {
    return JobPostRequestModel(
      jobId: entity.jobId,
      startTime: entity.startTime,
      endTime: entity.endTime,
      vacancy: entity.vacancy,
      timezone: entity.timezone,
    );
  }

  factory JobPostRequestModel.fromJson(Map<String, dynamic> json) {
    return JobPostRequestModel(
      jobId: json['job_id'] as int?,
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
      vacancy: json['vacancy'] as int?,
      timezone: json['timezone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (jobId != null) 'job_id': jobId,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (vacancy != null) 'vacancy': vacancy,
      if (timezone != null) 'timezone': timezone,
    };
  }
}
