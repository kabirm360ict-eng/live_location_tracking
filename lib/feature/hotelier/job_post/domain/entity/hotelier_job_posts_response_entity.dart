import 'package:equatable/equatable.dart';

class HotelierJobPostsResponseEntity extends Equatable {
  final bool? success;
  final String? message;
  final List<HotelierJobPostItemEntity>? data;
  final int? total;

  const HotelierJobPostsResponseEntity({
    this.success,
    this.message,
    this.data,
    this.total,
  });

  @override
  List<Object?> get props => [success, message, data, total];
}

class HotelierJobPostItemEntity extends Equatable {
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
  final HotelierJobSeekerDetailsEntity? jobSeekerDetails;

  const HotelierJobPostItemEntity({
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

  @override
  List<Object?> get props => [
        id,
        jobNo,
        jobPostId,
        jobPostDetailsStatus,
        startTime,
        endTime,
        timezone,
        hotelierId,
        organizationId,
        title,
        jobImage,
        hourlyRate,
        createdTime,
        selfSuppliedInstrument,
        instrumentCharge,
        vacancy,
        jobSeekerDetails,
      ];
}

class HotelierJobSeekerDetailsEntity extends Equatable {
  final int? jobSeekerId;
  final String? applicationStatus;
  final String? jobSeekerName;
  final String? jobSeekerImage;
  final dynamic longitude;
  final dynamic latitude;

  const HotelierJobSeekerDetailsEntity({
    this.jobSeekerId,
    this.applicationStatus,
    this.jobSeekerName,
    this.jobSeekerImage,
    this.longitude,
    this.latitude,
  });

  @override
  List<Object?> get props => [
        jobSeekerId,
        applicationStatus,
        jobSeekerName,
        jobSeekerImage,
        longitude,
        latitude,
      ];
}
