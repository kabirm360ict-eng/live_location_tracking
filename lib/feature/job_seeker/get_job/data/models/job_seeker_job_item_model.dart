import '../../domain/entities/job_seeker_job_item_entity.dart';

class JobSeekerJobItemModel {
  final int? id;
  final int? jobPostDetailId;
  final String? jobNo;
  final String? jobType;
  final String? startTime;
  final String? endTime;
  final String? timezone;
  final String? status;
  final int? organizationId;
  final String? jobTitle;
  final String? jobDetails;
  final String? jobImage;
  final String? jobSeekerPay;
  final String? createdTime;
  final dynamic selfSuppliedInstrument;
  final dynamic instrumentCharge;
  final String? organizationName;
  final String? organizationPhoto;
  final String? locationAddress;
  final String? cityName;
  final String? longitude;
  final String? latitude;

  JobSeekerJobItemModel({
    this.id,
    this.jobPostDetailId,
    this.jobNo,
    this.jobType,
    this.startTime,
    this.endTime,
    this.timezone,
    this.status,
    this.organizationId,
    this.jobTitle,
    this.jobDetails,
    this.jobImage,
    this.jobSeekerPay,
    this.createdTime,
    this.selfSuppliedInstrument,
    this.instrumentCharge,
    this.organizationName,
    this.organizationPhoto,
    this.locationAddress,
    this.cityName,
    this.longitude,
    this.latitude,
  });

  factory JobSeekerJobItemModel.fromJson(Map<String, dynamic> json) {
    return JobSeekerJobItemModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? ''),
      jobPostDetailId: json['job_post_detail_id'] is int
          ? json['job_post_detail_id'] as int
          : int.tryParse(json['job_post_detail_id']?.toString() ?? ''),
      jobNo: json['job_no']?.toString(),
      jobType: json['job_type']?.toString(),
      startTime: json['start_time']?.toString(),
      endTime: json['end_time']?.toString(),
      timezone: json['timezone']?.toString(),
      status: json['status']?.toString(),
      organizationId: json['organization_id'] is int
          ? json['organization_id'] as int
          : int.tryParse(json['organization_id']?.toString() ?? ''),
      jobTitle: json['job_title']?.toString(),
      jobDetails: json['job_details']?.toString(),
      jobImage: json['job_image']?.toString(),
      jobSeekerPay: json['job_seeker_pay']?.toString(),
      createdTime: json['created_time']?.toString(),
      selfSuppliedInstrument: json['self_supplied_instrument'],
      instrumentCharge: json['instrument_charge'],
      organizationName: json['organization_name']?.toString(),
      organizationPhoto: json['organization_photo']?.toString(),
      locationAddress: json['location_address']?.toString(),
      cityName: json['city_name']?.toString(),
      longitude: json['longitude']?.toString(),
      latitude: json['latitude']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'job_post_detail_id': jobPostDetailId,
      'job_no': jobNo,
      'job_type': jobType,
      'start_time': startTime,
      'end_time': endTime,
      'timezone': timezone,
      'status': status,
      'organization_id': organizationId,
      'job_title': jobTitle,
      'job_details': jobDetails,
      'job_image': jobImage,
      'job_seeker_pay': jobSeekerPay,
      'created_time': createdTime,
      'self_supplied_instrument': selfSuppliedInstrument,
      'instrument_charge': instrumentCharge,
      'organization_name': organizationName,
      'organization_photo': organizationPhoto,
      'location_address': locationAddress,
      'city_name': cityName,
      'longitude': longitude,
      'latitude': latitude,
    };
  }

  JobSeekerJobItemEntity toEntity() {
    return JobSeekerJobItemEntity(
      id: id,
      jobPostDetailId: jobPostDetailId,
      jobNo: jobNo,
      jobType: jobType,
      startTime: startTime,
      endTime: endTime,
      timezone: timezone,
      status: status,
      organizationId: organizationId,
      jobTitle: jobTitle,
      jobDetails: jobDetails,
      jobImage: jobImage,
      jobSeekerPay: jobSeekerPay,
      createdTime: createdTime,
      selfSuppliedInstrument: selfSuppliedInstrument,
      instrumentCharge: instrumentCharge,
      organizationName: organizationName,
      organizationPhoto: organizationPhoto,
      locationAddress: locationAddress,
      cityName: cityName,
      longitude: longitude,
      latitude: latitude,
    );
  }
}
