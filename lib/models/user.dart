// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.status,
    this.data,
    this.accessToken,
  });

  bool status;
  Data data;
  String accessToken;

  factory User.fromJson(Map<String, dynamic> json) => User(
        status: json["status"],
        data: Data.fromJson(json["data"]),
        accessToken: json["access_token"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
        "access_token": accessToken,
      };
}

class Data {
  Data({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.photo,
    this.phoneNumber,
    this.type,
    this.uId,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String name;
  String email;
  dynamic emailVerifiedAt;
  String photo;
  String phoneNumber;
  int type;
  dynamic uId;
  DateTime createdAt;
  DateTime updatedAt;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        photo: json["photo"],
        phoneNumber: json["phone_number"],
        type: json["type"],
        uId: json["uID"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "photo": photo,
        "phone_number": phoneNumber,
        "type": type,
        "uID": uId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
