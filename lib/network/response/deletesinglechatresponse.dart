// To parse this JSON data, do
//
//     final deletesinglechatresponse = deletesinglechatresponseFromJson(jsonString);

import 'dart:convert';

List<Deletesinglechatresponse> deletesinglechatresponseFromJson(String str) =>
    List<Deletesinglechatresponse>.from(
        json.decode(str).map((x) => Deletesinglechatresponse.fromJson(x)));

String deletesinglechatresponseToJson(List<Deletesinglechatresponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Deletesinglechatresponse {
  String? status;
  String? message;

  Deletesinglechatresponse({
    this.status,
    this.message,
  });

  factory Deletesinglechatresponse.fromJson(Map<String, dynamic> json) =>
      Deletesinglechatresponse(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
