// To parse this JSON data, do
//
//     final deletesinglechatcall = deletesinglechatcallFromJson(jsonString);

import 'dart:convert';

Deletesinglechatcall deletesinglechatcallFromJson(String str) =>
    Deletesinglechatcall.fromJson(json.decode(str));

String deletesinglechatcallToJson(Deletesinglechatcall data) =>
    json.encode(data.toJson());

class Deletesinglechatcall {
  String? id;

  Deletesinglechatcall({
    this.id,
  });

  factory Deletesinglechatcall.fromJson(Map<String, dynamic> json) =>
      Deletesinglechatcall(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
