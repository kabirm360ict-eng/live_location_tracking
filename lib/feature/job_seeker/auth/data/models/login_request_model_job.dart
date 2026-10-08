import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/login_request_job_entity.dart';
part 'login_request_model_job.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class LoginRequestJobModel {
  @JsonKey(name: "email")
  final dynamic email;
  final dynamic password;

  LoginRequestJobModel({this.email, this.password});

  factory LoginRequestJobModel.fromJson(Map<String, dynamic> json) => _$LoginRequestJobModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestJobModelToJson(this);

  factory LoginRequestJobModel.fromEntity(LoginRequestJobEntity entity) {
    return LoginRequestJobModel(email: entity.email.toString().toLowerCase(), password: entity.password);
  }
}