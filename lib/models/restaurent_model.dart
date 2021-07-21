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
    this.restAddress,
    this.restName,
    this.restLatitude,
    this.restLongitude,
    this.restIsTrending,
    this.restStatus,
    this.restImage,
    this.restType,
    this.restZipCode,
    this.restIsOpen,
    this.restOpenTime,
    this.restCloseTime,
    this.restPhone,
    this.restCountry,
    this.restMenuId,
    this.restCity,
    this.delivery,
    this.pickup,
    this.tableService,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String restAddress;
  String restName;
  double restLatitude;
  double restLongitude;
  String restIsTrending;
  String restStatus;
  String restImage;
  String restType;
  String restZipCode;
  String restIsOpen;
  String restOpenTime;
  String restCloseTime;
  String restPhone;
  String restCountry;
  int restMenuId;
  String restCity;
  String delivery;
  String pickup;
  String tableService;
  dynamic createdAt;
  dynamic updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        restAddress: json["rest_address"],
        restName: json["rest_name"],
        restLatitude: double.parse(json["rest_latitude"]),
        // restLatitude: json["rest_latitude"].toDouble(),
        // restLongitude: json["rest_longitude"].toDouble(),
        restLongitude: double.parse(json["rest_longitude"]),
        restIsTrending: json["rest_isTrending"],
        restStatus: json["rest_status"],
        restImage: json["rest_image"],
        restType: json["rest_type"],
        restZipCode: json["rest_zipCode"],
        restIsOpen: json["rest_isOpen"],
        restOpenTime: json["rest_openTime"],
        restCloseTime: json["rest_close_time"],
        restPhone: json["rest_phone"],
        restCountry: json["rest_country"],
        restMenuId: json["rest_menuId"],
        restCity: json["rest_city"],
        delivery: json["delivery"],
        pickup: json["pickup"],
        tableService: json["table_service"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "rest_address": restAddress,
        "rest_name": restName,
        "rest_latitude": restLatitude,
        "rest_longitude": restLongitude,
        "rest_isTrending": restIsTrending,
        "rest_status": restStatus,
        "rest_image": restImage,
        "rest_type": restType,
        "rest_zipCode": restZipCode,
        "rest_isOpen": restIsOpen,
        "rest_openTime": restOpenTime,
        "rest_close_time": restCloseTime,
        "rest_phone": restPhone,
        "rest_country": restCountry,
        "rest_menuId": restMenuId,
        "rest_city": restCity,
        "delivery": delivery,
        "pickup": pickup,
        "table_service": tableService,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
