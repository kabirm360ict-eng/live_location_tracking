import '../../domain/entities/job_seeker_jobs_response_entity.dart';
import 'job_seeker_job_item_model.dart';

class JobSeekerJobsResponseModel {
  final bool? success;
  final String? message;
  final List<JobSeekerJobItemModel>? data;
  final int? total;

  JobSeekerJobsResponseModel({
    this.success,
    this.message,
    this.data,
    this.total,
  });

  factory JobSeekerJobsResponseModel.fromJson(Map<String, dynamic> json) {
    return JobSeekerJobsResponseModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null && json['data'] is List
          ? (json['data'] as List)
              .whereType<Map<String, dynamic>>()
              .map((e) => JobSeekerJobItemModel.fromJson(e))
              .toList()
          : null,
      total: json['total'] is int
          ? json['total'] as int
          : int.tryParse(json['total']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.map((e) => e.toJson()).toList(),
      'total': total,
    };
  }

  JobSeekerJobsResponseEntity toEntity() {
    return JobSeekerJobsResponseEntity(
      success: success,
      message: message,
      data: data?.map((e) => e.toEntity()).toList(),
      total: total,
    );
  }
}
