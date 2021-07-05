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
    this.custFirstName,
    this.custLastName,
    this.custMiddleName,
    this.email,
    this.emailVerifiedAt,
    this.custProfileImage,
    this.custPhoneNumber,
    this.custAccountStatus,
    this.custRegistrationType,
    this.custAccountType,
    this.custUid,
    this.createdAt,
    this.updatedAt,
    this.deviceId,
  });

  int id;
  String custFirstName;
  dynamic custLastName;
  dynamic custMiddleName;
  String email;
  dynamic emailVerifiedAt;
  dynamic custProfileImage;
  String custPhoneNumber;
  String custAccountStatus;
  String custRegistrationType;
  String custAccountType;
  dynamic custUid;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deviceId;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        custFirstName: json["cust_first_name"],
        custLastName: json["cust_last_name"],
        custMiddleName: json["cust_middle_name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        custProfileImage: json["cust_profile_image"],
        custPhoneNumber: json["cust_phone_number"],
        custAccountStatus: json["cust_account_status"],
        custRegistrationType: json["cust_registration_type"],
        custAccountType: json["cust_account_type"],
        custUid: json["cust_uid"],
        createdAt: DateTime.parse(json["created_at"]),
        // updatedAt: DateTime.parse(json["updated_at"]),
        deviceId: json["device_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cust_first_name": custFirstName,
        "cust_last_name": custLastName,
        "cust_middle_name": custMiddleName,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "cust_profile_image": custProfileImage,
        "cust_phone_number": custPhoneNumber,
        "cust_account_status": custAccountStatus,
        "cust_registration_type": custRegistrationType,
        "cust_account_type": custAccountType,
        "cust_uid": custUid,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "device_id": deviceId,
      };
}
