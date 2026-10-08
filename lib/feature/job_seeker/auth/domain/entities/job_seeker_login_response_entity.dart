import 'package:equatable/equatable.dart';

class JobSeekerLoginResponseEntity extends Equatable {
  final dynamic userId;
  final dynamic name;
  final dynamic email;
  final dynamic phoneNumber;
  final dynamic photo;
  final bool? status;
  final bool? isDeleted;
  final DateTime? createdAt;
  final DateTime? dateOfBirth;
  final dynamic gender;
  final dynamic nationality;
  final dynamic workPermit;
  final dynamic accountStatus;
  final bool? is2FaOn;
  final bool? isCompleted;
  final DateTime? completedAt;
  final bool? finalCompleted;
  final DateTime? finalCompletedAt;

  const JobSeekerLoginResponseEntity({
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
  });

  @override
  List<Object?> get props => [
    userId,
    name,
    email,
    phoneNumber,
    photo,
    status,
    isDeleted,
    createdAt,
    dateOfBirth,
    gender,
    nationality,
    workPermit,
    accountStatus,
    is2FaOn,
    isCompleted,
    completedAt,
    finalCompleted,
    finalCompletedAt,
  ];
}
