import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/fcm_token_entity.dart';
part 'fcm_token_model.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class FcmTokenModel {
  @JsonKey(name: "user[device_id]")
  final dynamic fcmToken;

  const FcmTokenModel({this.fcmToken});

  factory FcmTokenModel.fromJson(Map<String, dynamic> json) => _$FcmTokenModelFromJson(json);
  Map<String, dynamic> toJson() => _$FcmTokenModelToJson(this);

  factory FcmTokenModel.fromEntity(FcmTokenEntity entity) {
    return FcmTokenModel(fcmToken: entity.fcmToken);
  }
}


// class FcmTokenModel {
//   String? fcmToken;
//   FcmTokenModel({this.fcmToken});

//   factory FcmTokenModel.fromJson(Map<String, dynamic> json) {
//     return FcmTokenModel(fcmToken: json['user[device_id]']);
//   }
//   Map<String, String> toJson() => {"user[device_id]": fcmToken ?? ""};
// }
