// To parse this JSON data, do
//
//     final logoutresponse = logoutresponseFromJson(jsonString);

import 'dart:convert';

List<Logoutresponse> logoutresponseFromJson(String str) =>
    List<Logoutresponse>.from(
        json.decode(str).map((x) => Logoutresponse.fromJson(x)));

String logoutresponseToJson(List<Logoutresponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Logoutresponse {
  String? status;
  String? message;

  Logoutresponse({
    this.status,
    this.message,
  });

  factory Logoutresponse.fromJson(Map<String, dynamic> json) => Logoutresponse(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
