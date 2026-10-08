// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_seeker_login_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobSeekerLoginResponseModel _$JobSeekerLoginResponseModelFromJson(
  Map<String, dynamic> json,
) => JobSeekerLoginResponseModel(
  userId: json['user_id'],
  name: json['name'],
  email: json['email'],
  phoneNumber: json['phone_number'],
  photo: json['photo'],
  status: json['status'] as bool?,
  isDeleted: json['is_deleted'] as bool?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  dateOfBirth: json['date_of_birth'] == null
      ? null
      : DateTime.parse(json['date_of_birth'] as String),
  gender: json['gender'],
  nationality: json['nationality'],
  workPermit: json['work_permit'],
  accountStatus: json['account_status'],
  is2FaOn: json['is_2fa_on'] as bool?,
  isCompleted: json['is_completed'] as bool?,
  completedAt: json['completed_at'] == null
      ? null
      : DateTime.parse(json['completed_at'] as String),
  finalCompleted: json['final_completed'] as bool?,
  finalCompletedAt: json['final_completed_at'] == null
      ? null
      : DateTime.parse(json['final_completed_at'] as String),
  preferredJob: json['preferred_job'],
);

Map<String, dynamic> _$JobSeekerLoginResponseModelToJson(
  JobSeekerLoginResponseModel instance,
) => <String, dynamic>{
  'user_id': ?instance.userId,
  'name': ?instance.name,
  'email': ?instance.email,
  'phone_number': ?instance.phoneNumber,
  'photo': ?instance.photo,
  'status': ?instance.status,
  'is_deleted': ?instance.isDeleted,
  'created_at': ?instance.createdAt?.toIso8601String(),
  'date_of_birth': ?instance.dateOfBirth?.toIso8601String(),
  'gender': ?instance.gender,
  'nationality': ?instance.nationality,
  'work_permit': ?instance.workPermit,
  'account_status': ?instance.accountStatus,
  'is_2fa_on': ?instance.is2FaOn,
  'is_completed': ?instance.isCompleted,
  'completed_at': ?instance.completedAt?.toIso8601String(),
  'final_completed': ?instance.finalCompleted,
  'final_completed_at': ?instance.finalCompletedAt?.toIso8601String(),
  'preferred_job': ?instance.preferredJob,
};
