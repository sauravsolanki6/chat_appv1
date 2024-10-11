// To parse this JSON data, do
//
//     final getallmemberscall = getallmemberscallFromJson(jsonString);

import 'dart:convert';

Getallmemberscall getallmemberscallFromJson(String str) =>
    Getallmemberscall.fromJson(json.decode(str));

String getallmemberscallToJson(Getallmemberscall data) =>
    json.encode(data.toJson());

class Getallmemberscall {
  String? id;

  Getallmemberscall({
    this.id,
  });

  factory Getallmemberscall.fromJson(Map<String, dynamic> json) =>
      Getallmemberscall(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
