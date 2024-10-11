// To parse this JSON data, do
//
//     final checkmobileexitsresponse = checkmobileexitsresponseFromJson(jsonString);

import 'dart:convert';

List<Checkmobileexitsresponse> checkmobileexitsresponseFromJson(String str) =>
    List<Checkmobileexitsresponse>.from(
        json.decode(str).map((x) => Checkmobileexitsresponse.fromJson(x)));

String checkmobileexitsresponseToJson(List<Checkmobileexitsresponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Checkmobileexitsresponse {
  String? status;
  String? message;
  String? exist;

  Checkmobileexitsresponse({
    this.status,
    this.message,
    this.exist,
  });

  factory Checkmobileexitsresponse.fromJson(Map<String, dynamic> json) =>
      Checkmobileexitsresponse(
        status: json["status"],
        message: json["message"],
        exist: json["exist"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "exist": exist,
      };
}
