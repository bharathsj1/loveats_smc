// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

UserData userFromJson(String str) => UserData.fromJson(json.decode(str));

String userToJson(UserData data) => json.encode(data.toJson());

class UserData {
  UserData({
    this.status,
    this.data,
    this.accessToken,
  });

  bool status;
  Data data;
  String accessToken;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
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
    this.custProfileImage,
    this.custPhoneNumber,
    this.custAccountStatus,
    this.custRegistrationType,
    this.custAccountType,
    this.custUid,
    this.createdAt,
    this.deviceId,
    this.stripeCusId,
  });

  int id;
  String custFirstName;
  String custLastName;
  String custMiddleName;
  String email;
  String custProfileImage;
  String custPhoneNumber;
  String custAccountStatus;
  String custRegistrationType;
  String custAccountType;
  String custUid;
  DateTime createdAt;
  String deviceId;
  String stripeCusId;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        custFirstName: json["cust_first_name"],
        custLastName: json["cust_last_name"],
        custMiddleName: json["cust_middle_name"],
        email: json["email"],
        custProfileImage: json["cust_profile_image"],
        custPhoneNumber: json["cust_phone_number"],
        custAccountStatus: json["cust_account_status"],
        custRegistrationType: json["cust_registration_type"],
        custAccountType: json["cust_account_type"],
        custUid: json["cust_uid"],
        createdAt: DateTime.parse(json["created_at"]),
        stripeCusId: json['stripe_cus_id'],
        deviceId: json["device_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cust_first_name": custFirstName,
        "cust_last_name": custLastName,
        "cust_middle_name": custMiddleName,
        "email": email,
        "cust_profile_image": custProfileImage,
        "cust_phone_number": custPhoneNumber,
        "cust_account_status": custAccountStatus,
        "cust_registration_type": custRegistrationType,
        "cust_account_type": custAccountType,
        "cust_uid": custUid,
        "created_at": createdAt.toIso8601String(),
        "device_id": deviceId,
        'stripe_cus_id': stripeCusId,
      };
}
