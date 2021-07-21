// To parse this JSON data, do
//
//     final specificUserSubscriptionModel = specificUserSubscriptionModelFromJson(jsonString);

import 'dart:convert';

SpecificUserSubscriptionModel specificUserSubscriptionModelFromJson(
        String str) =>
    SpecificUserSubscriptionModel.fromJson(json.decode(str));

String specificUserSubscriptionModelToJson(
        SpecificUserSubscriptionModel data) =>
    json.encode(data.toJson());

class SpecificUserSubscriptionModel {
  SpecificUserSubscriptionModel({
    this.success,
    this.data,
    this.message,
  });

  bool success;
  List<Datum> data;
  String message;

  factory SpecificUserSubscriptionModel.fromJson(Map<String, dynamic> json) =>
      SpecificUserSubscriptionModel(
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
    this.userId,
    this.subscriptionPlanId,
    this.subscriptionStatus,
    this.subscriptionStartDate,
    this.subscriptionEndDate,
    this.createdAt,
    this.updatedAt,
    this.subscriptionPlan,
  });

  int id;
  int userId;
  int subscriptionPlanId;
  String subscriptionStatus;
  String subscriptionStartDate;
  String subscriptionEndDate;
  String createdAt;
  String updatedAt;
  SubscriptionPlan subscriptionPlan;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["user_id"],
        subscriptionPlanId: json["subscription_plan_id"],
        subscriptionStatus: json["subscription_status"],
        subscriptionStartDate: json["subscription_start_date"],
        subscriptionEndDate: json["subscription_end_date"],
        createdAt: (json["created_at"]),
        updatedAt:(json["updated_at"]),
        subscriptionPlan: SubscriptionPlan.fromJson(json["subscription_plan"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "subscription_plan_id": subscriptionPlanId,
        "subscription_status": subscriptionStatus,
        "subscription_start_date": subscriptionStartDate,
        "subscription_end_date": subscriptionEndDate,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "subscription_plan": subscriptionPlan.toJson(),
      };
}

class SubscriptionPlan {
  SubscriptionPlan({
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

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) =>
      SubscriptionPlan(
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
