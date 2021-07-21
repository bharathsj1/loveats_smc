// To parse this JSON data, do
//
//     final getAllSubscriptionModel = getAllSubscriptionModelFromJson(jsonString);

import 'dart:convert';

GetAllSubscriptionModel getAllSubscriptionModelFromJson(String str) =>
    GetAllSubscriptionModel.fromJson(json.decode(str));

String getAllSubscriptionModelToJson(GetAllSubscriptionModel data) =>
    json.encode(data.toJson());

class GetAllSubscriptionModel {
  GetAllSubscriptionModel({
    this.success,
    this.data,
    this.message,
  });

  bool success;
  List<Datum> data;
  String message;

  factory GetAllSubscriptionModel.fromJson(Map<String, dynamic> json) =>
      GetAllSubscriptionModel(
        success: json["success"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class Datum {
  Datum({
    this.id,
    this.planDetails,
    this.discount,
    this.status,
    this.duration,
    this.price,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String planDetails;
  String discount;
  String status;
  String duration;
  String price;
  dynamic createdAt;
  dynamic updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        planDetails: json["plan_details"],
        discount: json["discount"],
        status: json["status"],
        duration: json["duration"],
        price: json["price"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "plan_details": planDetails,
        "discount": discount,
        "status": status,
        "duration": duration,
        "price": price,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
