import '../../domain/entity/hotelier_single_job_post_response_entity.dart';

class HotelierSingleJobPostResponseModel {
  final bool? success;
  final String? message;
  final HotelierSingleJobPostDataModel? data;

  HotelierSingleJobPostResponseModel({
    this.success,
    this.message,
    this.data,
  });

  factory HotelierSingleJobPostResponseModel.fromJson(Map<String, dynamic> json) {
    return HotelierSingleJobPostResponseModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? HotelierSingleJobPostDataModel.fromJson(
              json['data'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }

  HotelierSingleJobPostResponseEntity toEntity() {
    return HotelierSingleJobPostResponseEntity(
      success: success,
      message: message,
      data: data?.toEntity(),
    );
  }
}

class HotelierSingleJobPostDataModel {
  final int? id;
  final String? jobNo;
  final int? jobId;
  final int? jobPostId;
  final String? jobPostDetailsStatus;
  final int? jobApplicationId;
  final String? title;
  final String? jobDetails;
  final String? startTime;
  final String? endTime;
  final String? timezone;
  final String? hourlyRate;
  final int? vacancy;
  final dynamic selfSuppliedInstrument;
  final dynamic instrumentCharge;
  final dynamic buildingType;
  final dynamic bedroom;
  final dynamic bathroom;
  final dynamic kitchen;
  final dynamic balcony;
  final dynamic dining;
  final SingleJobSeekerDetailsModel? jobSeekerDetails;

  HotelierSingleJobPostDataModel({
    this.id,
    this.jobNo,
    this.jobId,
    this.jobPostId,
    this.jobPostDetailsStatus,
    this.jobApplicationId,
    this.title,
    this.jobDetails,
    this.startTime,
    this.endTime,
    this.timezone,
    this.hourlyRate,
    this.vacancy,
    this.selfSuppliedInstrument,
    this.instrumentCharge,
    this.buildingType,
    this.bedroom,
    this.bathroom,
    this.kitchen,
    this.balcony,
    this.dining,
    this.jobSeekerDetails,
  });

  factory HotelierSingleJobPostDataModel.fromJson(Map<String, dynamic> json) {
    return HotelierSingleJobPostDataModel(
      id: json['id'] as int?,
      jobNo: json['job_no'] as String?,
      jobId: json['job_id'] as int?,
      jobPostId: json['job_post_id'] as int?,
      jobPostDetailsStatus: json['job_post_details_status'] as String?,
      jobApplicationId: json['job_application_id'] as int?,
      title: json['title'] as String?,
      jobDetails: json['job_details'] as String?,
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
      timezone: json['timezone'] as String?,
      hourlyRate: json['hourly_rate'] as String?,
      vacancy: json['vacancy'] as int?,
      selfSuppliedInstrument: json['self_supplied_instrument'],
      instrumentCharge: json['instrument_charge'],
      buildingType: json['building_type'],
      bedroom: json['bedroom'],
      bathroom: json['bathroom'],
      kitchen: json['kitchen'],
      balcony: json['balcony'],
      dining: json['dining'],
      jobSeekerDetails: json['job_seeker_details'] != null
          ? SingleJobSeekerDetailsModel.fromJson(
              json['job_seeker_details'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'job_no': jobNo,
      'job_id': jobId,
      'job_post_id': jobPostId,
      'job_post_details_status': jobPostDetailsStatus,
      'job_application_id': jobApplicationId,
      'title': title,
      'job_details': jobDetails,
      'start_time': startTime,
      'end_time': endTime,
      'timezone': timezone,
      'hourly_rate': hourlyRate,
      'vacancy': vacancy,
      'self_supplied_instrument': selfSuppliedInstrument,
      'instrument_charge': instrumentCharge,
      'building_type': buildingType,
      'bedroom': bedroom,
      'bathroom': bathroom,
      'kitchen': kitchen,
      'balcony': balcony,
      'dining': dining,
      'job_seeker_details': jobSeekerDetails?.toJson(),
    };
  }

  HotelierSingleJobPostDataEntity toEntity() {
    return HotelierSingleJobPostDataEntity(
      id: id,
      jobNo: jobNo,
      jobId: jobId,
      jobPostId: jobPostId,
      jobPostDetailsStatus: jobPostDetailsStatus,
      jobApplicationId: jobApplicationId,
      title: title,
      jobDetails: jobDetails,
      startTime: startTime,
      endTime: endTime,
      timezone: timezone,
      hourlyRate: hourlyRate,
      vacancy: vacancy,
      selfSuppliedInstrument: selfSuppliedInstrument,
      instrumentCharge: instrumentCharge,
      buildingType: buildingType,
      bedroom: bedroom,
      bathroom: bathroom,
      kitchen: kitchen,
      balcony: balcony,
      dining: dining,
      jobSeekerDetails: jobSeekerDetails?.toEntity(),
    );
  }
}

class SingleJobSeekerDetailsModel {
  final int? applicationId;
  final String? applicationStatus;
  final int? jobSeekerId;
  final String? jobSeekerName;
  final String? jobSeekerImage;
  final String? locationAddress;
  final String? city;
  final dynamic longitude;
  final dynamic latitude;
  final dynamic paymentId;
  final int? chatSessionId;

  SingleJobSeekerDetailsModel({
    this.applicationId,
    this.applicationStatus,
    this.jobSeekerId,
    this.jobSeekerName,
    this.jobSeekerImage,
    this.locationAddress,
    this.city,
    this.longitude,
    this.latitude,
    this.paymentId,
    this.chatSessionId,
  });

  factory SingleJobSeekerDetailsModel.fromJson(Map<String, dynamic> json) {
    return SingleJobSeekerDetailsModel(
      applicationId: json['application_id'] as int?,
      applicationStatus: json['application_status'] as String?,
      jobSeekerId: json['job_seeker_id'] as int?,
      jobSeekerName: json['job_seeker_name'] as String?,
      jobSeekerImage: json['job_seeker_image'] as String?,
      locationAddress: json['location_address'] as String?,
      city: json['city'] as String?,
      longitude: json['longitude'],
      latitude: json['latitude'],
      paymentId: json['payment_id'],
      chatSessionId: json['chat_session_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'application_id': applicationId,
      'application_status': applicationStatus,
      'job_seeker_id': jobSeekerId,
      'job_seeker_name': jobSeekerName,
      'job_seeker_image': jobSeekerImage,
      'location_address': locationAddress,
      'city': city,
      'longitude': longitude,
      'latitude': latitude,
      'payment_id': paymentId,
      'chat_session_id': chatSessionId,
    };
  }

  SingleJobSeekerDetailsEntity toEntity() {
    return SingleJobSeekerDetailsEntity(
      applicationId: applicationId,
      applicationStatus: applicationStatus,
      jobSeekerId: jobSeekerId,
      jobSeekerName: jobSeekerName,
      jobSeekerImage: jobSeekerImage,
      locationAddress: locationAddress,
      city: city,
      longitude: longitude,
      latitude: latitude,
      paymentId: paymentId,
      chatSessionId: chatSessionId,
    );
  }
}
