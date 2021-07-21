// To parse this JSON data, do
//
//     final subscriptionModel = subscriptionModelFromJson(jsonString);

import 'dart:convert';

SubscriptionModel subscriptionModelFromJson(String str) =>
    SubscriptionModel.fromJson(json.decode(str));

String subscriptionModelToJson(SubscriptionModel data) =>
    json.encode(data.toJson());

class SubscriptionModel {
  SubscriptionModel({
    this.status,
    this.data,
    this.message,
  });

  int status;
  Data data;
  String message;

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
        "message": message,
      };
}

class Data {
  Data({
    this.subscriptionPlanId,
    this.subscriptionStatus,
    this.subscriptionStartDate,
    this.subscriptionEndDate,
    this.userId,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  String subscriptionPlanId;
  String subscriptionStatus;
  String subscriptionStartDate;
  String subscriptionEndDate;
  int userId;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        subscriptionPlanId: json["subscription_plan_id"],
        subscriptionStatus: json["subscription_status"],
        subscriptionStartDate: json["subscription_start_date"],
        subscriptionEndDate: json["subscription_end_date"],
        userId: json["user_id"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "subscription_plan_id": subscriptionPlanId,
        "subscription_status": subscriptionStatus,
        "subscription_start_date": subscriptionStartDate,
        "subscription_end_date": subscriptionEndDate,
        "user_id": userId,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
      };
}
