import '../../domain/entity/job_post_response_entity.dart';

class JobPostResponseModel {
  final bool? success;
  final String? message;
  final JobPostDataModel? data;

  JobPostResponseModel({
    this.success,
    this.message,
    this.data,
  });

  factory JobPostResponseModel.fromJson(Map<String, dynamic> json) {
    return JobPostResponseModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null ? JobPostDataModel.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }

  JobPostResponseEntity toEntity() {
    return JobPostResponseEntity(
      success: success,
      message: message,
      data: data?.toEntity(),
    );
  }
}

class JobPostDataModel {
  final int? id;
  final List<JobPostDetailIdModel>? jobPostDetailsId;

  JobPostDataModel({
    this.id,
    this.jobPostDetailsId,
  });

  factory JobPostDataModel.fromJson(Map<String, dynamic> json) {
    return JobPostDataModel(
      id: json['id'] as int?,
      jobPostDetailsId: json['job_post_details_id'] != null
          ? (json['job_post_details_id'] as List)
              .map((e) => JobPostDetailIdModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'job_post_details_id': jobPostDetailsId?.map((e) => e.toJson()).toList(),
    };
  }

  JobPostDataEntity toEntity() {
    return JobPostDataEntity(
      id: id,
      jobPostDetailsId: jobPostDetailsId?.map((e) => e.toEntity()).toList(),
    );
  }
}

class JobPostDetailIdModel {
  final int? id;

  JobPostDetailIdModel({this.id});

  factory JobPostDetailIdModel.fromJson(Map<String, dynamic> json) {
    return JobPostDetailIdModel(
      id: json['id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }

  JobPostDetailIdEntity toEntity() {
    return JobPostDetailIdEntity(
      id: id,
    );
  }
}
