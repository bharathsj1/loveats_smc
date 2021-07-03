// To parse this JSON data, do
//
//     final menuTypesModel = menuTypesModelFromJson(jsonString);

import 'dart:convert';

MenuTypesModel menuTypesModelFromJson(String str) =>
    MenuTypesModel.fromJson(json.decode(str));

String menuTypesModelToJson(MenuTypesModel data) => json.encode(data.toJson());

class MenuTypesModel {
  MenuTypesModel({
    this.success,
    this.data,
    this.message,
  });

  bool success;
  List<Datum> data;
  String message;

  factory MenuTypesModel.fromJson(Map<String, dynamic> json) => MenuTypesModel(
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
    this.menuName,
    this.menuTypeImage,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String menuName;
  String menuTypeImage;
  DateTime createdAt;
  DateTime updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        menuName: json["menu_name"],
        menuTypeImage: json["menu_type_image"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "menu_name": menuName,
        "menu_type_image": menuTypeImage,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
