import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/job_seeker_login_response_entity.dart';
part 'job_seeker_login_response_model.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class JobSeekerLoginResponseModel {
  @JsonKey(name: "user_id")
  final dynamic userId;
  @JsonKey(name: "name")
  final dynamic name;
  @JsonKey(name: "email")
  final dynamic email;
  @JsonKey(name: "phone_number")
  final dynamic phoneNumber;
  @JsonKey(name: "photo")
  final dynamic photo;
  @JsonKey(name: "status")
  final bool? status;
  @JsonKey(name: "is_deleted")
  final bool? isDeleted;
  @JsonKey(name: "created_at")
  final DateTime? createdAt;
  @JsonKey(name: "date_of_birth")
  final DateTime? dateOfBirth;
  @JsonKey(name: "gender")
  final dynamic gender;
  @JsonKey(name: "nationality")
  final dynamic nationality;
  @JsonKey(name: "work_permit")
  final dynamic workPermit;
  @JsonKey(name: "account_status")
  final dynamic accountStatus;
  @JsonKey(name: "is_2fa_on")
  final bool? is2FaOn;
  @JsonKey(name: "is_completed")
  final bool? isCompleted;
  @JsonKey(name: "completed_at")
  final DateTime? completedAt;
  @JsonKey(name: "final_completed")
  final bool? finalCompleted;
  @JsonKey(name: "final_completed_at")
  final DateTime? finalCompletedAt;
  @JsonKey(name: "preferred_job")
  final dynamic preferredJob;

  const JobSeekerLoginResponseModel({
    this.userId,
    this.name,
    this.email,
    this.phoneNumber,
    this.photo,
    this.status,
    this.isDeleted,
    this.createdAt,
    this.dateOfBirth,
    this.gender,
    this.nationality,
    this.workPermit,
    this.accountStatus,
    this.is2FaOn,
    this.isCompleted,
    this.completedAt,
    this.finalCompleted,
    this.finalCompletedAt,
    this.preferredJob,
  });

  factory JobSeekerLoginResponseModel.fromJson(Map<String, dynamic> json) => _$JobSeekerLoginResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$JobSeekerLoginResponseModelToJson(this);

  factory JobSeekerLoginResponseModel.fromEntity(JobSeekerLoginResponseEntity entity) {
    return JobSeekerLoginResponseModel(
      userId: entity.userId,
      name: entity.name,
      email: entity.email,  
      phoneNumber: entity.phoneNumber,
      photo: entity.photo,
      status: entity.status,
      isDeleted: entity.isDeleted,
      createdAt: entity.createdAt,
      dateOfBirth: entity.dateOfBirth,
      gender: entity.gender,
      nationality: entity.nationality,
      workPermit: entity.workPermit,
      accountStatus: entity.accountStatus,
      is2FaOn: entity.is2FaOn,
      isCompleted: entity.isCompleted,
      completedAt: entity.completedAt,
      finalCompleted: entity.finalCompleted,
      finalCompletedAt: entity.finalCompletedAt,
    );
  }
}

