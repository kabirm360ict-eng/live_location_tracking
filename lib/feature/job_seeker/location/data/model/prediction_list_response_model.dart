// To parse this JSON data, do
//
//     final predictionListResponseModel = predictionListResponseModelFromJson(jsonString);

import 'dart:convert';

List<PredictionListResponseModel> predictionListResponseModelFromJson(
  String str,
) => List<PredictionListResponseModel>.from(
  json.decode(str).map((x) => PredictionListResponseModel.fromJson(x)),
);

String predictionListResponseModelToJson(
  List<PredictionListResponseModel> data,
) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PredictionListResponseModel {
  final String? description;
  final dynamic placeId;

  PredictionListResponseModel({this.description, this.placeId});

  factory PredictionListResponseModel.fromJson(Map<String, dynamic> json) =>
      PredictionListResponseModel(
        description: json["description"],
        placeId: json["place_id"],
      );

  Map<String, dynamic> toJson() => {
    "description": description,
    "place_id": placeId,
  };
}
