// To parse this JSON data, do
//
//     final freemealModel = freemealModelFromJson(jsonString);

import 'dart:convert';

FreemealModel freemealModelFromJson(String str) =>
    FreemealModel.fromJson(json.decode(str));

String freemealModelToJson(FreemealModel data) => json.encode(data.toJson());

class FreemealModel {
  FreemealModel({
    this.status,
    this.message,
  });

  bool status;
  String message;

  factory FreemealModel.fromJson(Map<String, dynamic> json) => FreemealModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
