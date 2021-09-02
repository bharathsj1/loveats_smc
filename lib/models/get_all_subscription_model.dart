// To parse this JSON data, do
//
//     final getAllSubscriptionModel = getAllSubscriptionModelFromJson(jsonString);

import 'dart:convert';

GetAllSubscriptionModel getAllSubscriptionModelFromJson(String str) =>
    GetAllSubscriptionModel.fromJson(json.decode(str));

String getAllSubscriptionModelToJson(GetAllSubscriptionModel data) =>
    json.encode(data.toJson());

class GetAllSubscriptionModel {
  GetAllSubscriptionModel({
    this.success,
    this.data,
    this.message,
  });

  bool success;
  List<Datum> data;
  String message;

  factory GetAllSubscriptionModel.fromJson(Map<String, dynamic> json) =>
      GetAllSubscriptionModel(
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
    this.object,
    this.active,
    this.attributes,
    this.created,
    this.description,
    this.images,
    this.livemode,
    this.metadata,
    this.name,
    this.packageDimensions,
    this.shippable,
    this.statementDescriptor,
    this.type,
    this.unitLabel,
    this.updated,
    this.url,
    this.amount,
  });

  String id;
  String object;
  bool active;
  List<dynamic> attributes;
  int created;
  String description;
  List<dynamic> images;
  bool livemode;
  dynamic metadata;
  String name;
  dynamic packageDimensions;
  dynamic shippable;
  dynamic statementDescriptor;
  String type;
  dynamic unitLabel;
  int updated;
  dynamic url;
  String amount;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        object: json["object"],
        active: json["active"],
        attributes: List<dynamic>.from(json["attributes"].map((x) => x)),
        created: json["created"],
        description: json["description"] == null ? null : json["description"],
        images: List<dynamic>.from(json["images"].map((x) => x)),
        livemode: json["livemode"],
        metadata: json["metadata"],
        name: json["name"],
        packageDimensions: json["package_dimensions"],
        shippable: json["shippable"],
        statementDescriptor: json["statement_descriptor"],
        type: json["type"],
        unitLabel: json["unit_label"],
        updated: json["updated"],
        url: json["url"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "object": object,
        "active": active,
        "attributes": List<dynamic>.from(attributes.map((x) => x)),
        "created": created,
        "description": description == null ? null : description,
        "images": List<dynamic>.from(images.map((x) => x)),
        "livemode": livemode,
        "metadata": metadata,
        "name": name,
        "package_dimensions": packageDimensions,
        "shippable": shippable,
        "statement_descriptor": statementDescriptor,
        "type": type,
        "unit_label": unitLabel,
        "updated": updated,
        "url": url,
      };
}

class MetadataClass {
  MetadataClass({
    this.amount,
  });

  String amount;

  factory MetadataClass.fromJson(Map<String, dynamic> json) => MetadataClass(
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
      };
}
