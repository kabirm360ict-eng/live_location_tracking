import '../../domain/entity/hotelier_job_posts_response_entity.dart';

class HotelierJobPostsResponseModel {
  final bool? success;
  final String? message;
  final List<HotelierJobPostItemModel>? data;
  final int? total;

  HotelierJobPostsResponseModel({
    this.success,
    this.message,
    this.data,
    this.total,
  });

  factory HotelierJobPostsResponseModel.fromJson(Map<String, dynamic> json) {
    return HotelierJobPostsResponseModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? (json['data'] as List)
              .map((e) =>
                  HotelierJobPostItemModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      total: json['total'] as int?,
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

  HotelierJobPostsResponseEntity toEntity() {
    return HotelierJobPostsResponseEntity(
      success: success,
      message: message,
      data: data?.map((e) => e.toEntity()).toList(),
      total: total,
    );
  }
}

class HotelierJobPostItemModel {
  final int? id;
  final String? jobNo;
  final int? jobPostId;
  final String? jobPostDetailsStatus;
  final String? startTime;
  final String? endTime;
  final String? timezone;
  final int? hotelierId;
  final int? organizationId;
  final String? title;
  final String? jobImage;
  final String? hourlyRate;
  final String? createdTime;
  final dynamic selfSuppliedInstrument;
  final dynamic instrumentCharge;
  final int? vacancy;
  final HotelierJobSeekerDetailsModel? jobSeekerDetails;

  HotelierJobPostItemModel({
    this.id,
    this.jobNo,
    this.jobPostId,
    this.jobPostDetailsStatus,
    this.startTime,
    this.endTime,
    this.timezone,
    this.hotelierId,
    this.organizationId,
    this.title,
    this.jobImage,
    this.hourlyRate,
    this.createdTime,
    this.selfSuppliedInstrument,
    this.instrumentCharge,
    this.vacancy,
    this.jobSeekerDetails,
  });

  factory HotelierJobPostItemModel.fromJson(Map<String, dynamic> json) {
    return HotelierJobPostItemModel(
      id: json['id'] as int?,
      jobNo: json['job_no'] as String?,
      jobPostId: json['job_post_id'] as int?,
      jobPostDetailsStatus: json['job_post_details_status'] as String?,
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
      timezone: json['timezone'] as String?,
      hotelierId: json['hotelier_id'] as int?,
      organizationId: json['organization_id'] as int?,
      title: json['title'] as String?,
      jobImage: json['job_image'] as String?,
      hourlyRate: json['hourly_rate'] as String?,
      createdTime: json['created_time'] as String?,
      selfSuppliedInstrument: json['self_supplied_instrument'],
      instrumentCharge: json['instrument_charge'],
      vacancy: json['vacancy'] as int?,
      jobSeekerDetails: json['job_seeker_details'] != null
          ? HotelierJobSeekerDetailsModel.fromJson(
              json['job_seeker_details'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'job_no': jobNo,
      'job_post_id': jobPostId,
      'job_post_details_status': jobPostDetailsStatus,
      'start_time': startTime,
      'end_time': endTime,
      'timezone': timezone,
      'hotelier_id': hotelierId,
      'organization_id': organizationId,
      'title': title,
      'job_image': jobImage,
      'hourly_rate': hourlyRate,
      'created_time': createdTime,
      'self_supplied_instrument': selfSuppliedInstrument,
      'instrument_charge': instrumentCharge,
      'vacancy': vacancy,
      'job_seeker_details': jobSeekerDetails?.toJson(),
    };
  }

  HotelierJobPostItemEntity toEntity() {
    return HotelierJobPostItemEntity(
      id: id,
      jobNo: jobNo,
      jobPostId: jobPostId,
      jobPostDetailsStatus: jobPostDetailsStatus,
      startTime: startTime,
      endTime: endTime,
      timezone: timezone,
      hotelierId: hotelierId,
      organizationId: organizationId,
      title: title,
      jobImage: jobImage,
      hourlyRate: hourlyRate,
      createdTime: createdTime,
      selfSuppliedInstrument: selfSuppliedInstrument,
      instrumentCharge: instrumentCharge,
      vacancy: vacancy,
      jobSeekerDetails: jobSeekerDetails?.toEntity(),
    );
  }
}

class HotelierJobSeekerDetailsModel {
  final int? jobSeekerId;
  final String? applicationStatus;
  final String? jobSeekerName;
  final String? jobSeekerImage;
  final dynamic longitude;
  final dynamic latitude;

  HotelierJobSeekerDetailsModel({
    this.jobSeekerId,
    this.applicationStatus,
    this.jobSeekerName,
    this.jobSeekerImage,
    this.longitude,
    this.latitude,
  });

  factory HotelierJobSeekerDetailsModel.fromJson(Map<String, dynamic> json) {
    return HotelierJobSeekerDetailsModel(
      jobSeekerId: json['job_seeker_id'] as int?,
      applicationStatus: json['application_status'] as String?,
      jobSeekerName: json['job_seeker_name'] as String?,
      jobSeekerImage: json['job_seeker_image'] as String?,
      longitude: json['longitude'],
      latitude: json['latitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'job_seeker_id': jobSeekerId,
      'application_status': applicationStatus,
      'job_seeker_name': jobSeekerName,
      'job_seeker_image': jobSeekerImage,
      'longitude': longitude,
      'latitude': latitude,
    };
  }

  HotelierJobSeekerDetailsEntity toEntity() {
    return HotelierJobSeekerDetailsEntity(
      jobSeekerId: jobSeekerId,
      applicationStatus: applicationStatus,
      jobSeekerName: jobSeekerName,
      jobSeekerImage: jobSeekerImage,
      longitude: longitude,
      latitude: latitude,
    );
  }
}
