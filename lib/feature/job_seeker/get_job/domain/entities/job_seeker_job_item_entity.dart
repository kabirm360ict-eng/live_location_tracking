import 'package:equatable/equatable.dart';
import '../../../../../core/constants/app_urls.dart';

class JobSeekerJobItemEntity extends Equatable {
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

  const JobSeekerJobItemEntity({
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

  double? get latitudeDouble => double.tryParse(latitude ?? '');
  double? get longitudeDouble => double.tryParse(longitude ?? '');

  String? get fullJobImageUrl {
    if (jobImage == null || jobImage!.trim().isEmpty) return null;
    if (jobImage!.startsWith('http://') || jobImage!.startsWith('https://')) {
      return jobImage;
    }
    return '${AppUrls.imageUrl}/$jobImage';
  }

  String? get fullOrganizationPhotoUrl {
    if (organizationPhoto == null || organizationPhoto!.trim().isEmpty) return null;
    if (organizationPhoto!.startsWith('http://') || organizationPhoto!.startsWith('https://')) {
      return organizationPhoto;
    }
    return '${AppUrls.imageUrl}/$organizationPhoto';
  }

  @override
  List<Object?> get props => [
        id,
        jobPostDetailId,
        jobNo,
        jobType,
        startTime,
        endTime,
        timezone,
        status,
        organizationId,
        jobTitle,
        jobDetails,
        jobImage,
        jobSeekerPay,
        createdTime,
        selfSuppliedInstrument,
        instrumentCharge,
        organizationName,
        organizationPhoto,
        locationAddress,
        cityName,
        longitude,
        latitude,
      ];
}
