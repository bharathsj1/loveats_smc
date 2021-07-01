// To parse this JSON data, do
//
//     final restaurentsModel = restaurentsModelFromJson(jsonString);

import 'dart:convert';

RestaurentsModel restaurentsModelFromJson(String str) =>
    RestaurentsModel.fromJson(json.decode(str));

String restaurentsModelToJson(RestaurentsModel data) =>
    json.encode(data.toJson());

class RestaurentsModel {
  RestaurentsModel({
    this.success,
    this.data,
    this.message,
  });

  bool success;
  List<Datum> data;
  String message;

  factory RestaurentsModel.fromJson(Map<String, dynamic> json) =>
      RestaurentsModel(
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
    this.name,
    this.lat,
    this.lng,
    this.isTrending,
    this.status,
    this.image,
    this.type,
    this.zipcode,
    this.open,
    this.openTime,
    this.closeTime,
    this.phone,
    this.country,
    this.city,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String address;
  String name;
  int lat;
  int lng;
  int isTrending;
  String status;
  String image;
  String type;
  String zipcode;
  int open;
  String openTime;
  String closeTime;
  String phone;
  String country;
  String city;
  DateTime createdAt;
  DateTime updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        address: json["address"],
        name: json["name"],
        lat: json["lat"],
        lng: json["lng"],
        isTrending: json["is_trending"],
        status: json["status"],
        image: json["image"],
        type: json["type"],
        zipcode: json["zipcode"],
        open: json["open"],
        openTime: json["open_time"],
        closeTime: json["close_time"],
        phone: json["phone"],
        country: json["country"],
        city: json["city"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "address": address,
        "name": name,
        "lat": lat,
        "lng": lng,
        "is_trending": isTrending,
        "status": status,
        "image": image,
        "type": type,
        "zipcode": zipcode,
        "open": open,
        "open_time": openTime,
        "close_time": closeTime,
        "phone": phone,
        "country": country,
        "city": city,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
