import 'package:json_annotation/json_annotation.dart';
import '../../domain/entity/login_request_hotelier_entity.dart';

part 'login_request_hotelier_model.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class LoginRequestHotelierModel {
  @JsonKey(name: "email")
  final dynamic email;
  @JsonKey(name: "password")
  final dynamic password;

  LoginRequestHotelierModel({this.email, this.password});

  factory LoginRequestHotelierModel.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestHotelierModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestHotelierModelToJson(this);

  factory LoginRequestHotelierModel.fromEntity(LoginRequestHotelierEntity entity) {
    return LoginRequestHotelierModel(
      email: entity.email?.toString().toLowerCase(),
      password: entity.password,
    );
  }
}
