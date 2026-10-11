import 'package:equatable/equatable.dart';

class HotelierSingleJobPostResponseEntity extends Equatable {
  final bool? success;
  final String? message;
  final HotelierSingleJobPostDataEntity? data;

  const HotelierSingleJobPostResponseEntity({
    this.success,
    this.message,
    this.data,
  });

  @override
  List<Object?> get props => [success, message, data];
}

class HotelierSingleJobPostDataEntity extends Equatable {
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
  final SingleJobSeekerDetailsEntity? jobSeekerDetails;

  const HotelierSingleJobPostDataEntity({
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

  @override
  List<Object?> get props => [
        id,
        jobNo,
        jobId,
        jobPostId,
        jobPostDetailsStatus,
        jobApplicationId,
        title,
        jobDetails,
        startTime,
        endTime,
        timezone,
        hourlyRate,
        vacancy,
        selfSuppliedInstrument,
        instrumentCharge,
        buildingType,
        bedroom,
        bathroom,
        kitchen,
        balcony,
        dining,
        jobSeekerDetails,
      ];
}

class SingleJobSeekerDetailsEntity extends Equatable {
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

  const SingleJobSeekerDetailsEntity({
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

  @override
  List<Object?> get props => [
        applicationId,
        applicationStatus,
        jobSeekerId,
        jobSeekerName,
        jobSeekerImage,
        locationAddress,
        city,
        longitude,
        latitude,
        paymentId,
        chatSessionId,
      ];
}
