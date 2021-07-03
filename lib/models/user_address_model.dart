// To parse this JSON data, do
//
//     final userAddressModel = userAddressModelFromJson(jsonString);

import 'dart:convert';

UserAddressModel userAddressModelFromJson(String str) =>
    UserAddressModel.fromJson(json.decode(str));

String userAddressModelToJson(UserAddressModel data) =>
    json.encode(data.toJson());

class UserAddressModel {
  UserAddressModel({
    this.success,
    this.data,
    this.message,
  });

  bool success;
  List<Datum> data;
  String message;

  factory UserAddressModel.fromJson(Map<String, dynamic> json) =>
      UserAddressModel(
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
    this.address,
    this.city,
    this.country,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.userLatitude,
    this.userLongitude,
    this.addressType,
  });

  int id;
  String address;
  String city;
  String country;
  int userId;
  DateTime createdAt;
  DateTime updatedAt;
  double userLatitude;
  double userLongitude;
  int addressType;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        address: json["address"],
        city: json["city"] == null ? null : json["city"],
        country: json["country"] == null ? null : json["country"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        userLatitude: json["user_latitude"].toDouble(),
        userLongitude: json["user_longitude"].toDouble(),
        addressType: json["address_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "address": address,
        "city": city == null ? null : city,
        "country": country == null ? null : country,
        "user_id": userId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "user_latitude": userLatitude,
        "user_longitude": userLongitude,
        "address_type": addressType,
      };
}
