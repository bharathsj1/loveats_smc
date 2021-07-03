// To parse this JSON data, do
//
//     final restaurentMenuModel = restaurentMenuModelFromJson(jsonString);

import 'dart:convert';

RestaurentMenuModel restaurentMenuModelFromJson(String str) =>
    RestaurentMenuModel.fromJson(json.decode(str));

String restaurentMenuModelToJson(RestaurentMenuModel data) =>
    json.encode(data.toJson());

class RestaurentMenuModel {
  RestaurentMenuModel({
    this.success,
    this.data,
    this.message,
  });

  bool success;
  List<Datum> data;
  String message;

  factory RestaurentMenuModel.fromJson(Map<String, dynamic> json) =>
      RestaurentMenuModel(
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
    this.menuImage,
    this.menuPrice,
    this.menuName,
    this.menuDetails,
    this.menuQuantity,
    this.restId,
    this.menuTypeId,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String menuImage;
  int menuPrice;
  String menuName;
  String menuDetails;
  int menuQuantity;
  int restId;
  int menuTypeId;
  dynamic createdAt;
  dynamic updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        menuImage: json["menu_image"],
        menuPrice: json["menu_price"],
        menuName: json["menu_name"],
        menuDetails: json["menu_details"],
        menuQuantity: json["menu_quantity"],
        restId: json["rest_id"],
        menuTypeId: json["menu_type_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "menu_image": menuImage,
        "menu_price": menuPrice,
        "menu_name": menuName,
        "menu_details": menuDetails,
        "menu_quantity": menuQuantity,
        "rest_id": restId,
        "menu_type_id": menuTypeId,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
