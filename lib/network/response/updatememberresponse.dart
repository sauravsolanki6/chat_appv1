// To parse this JSON data, do
//
//     final updatememberresponse = updatememberresponseFromJson(jsonString);

import 'dart:convert';

List<Updatememberresponse> updatememberresponseFromJson(String str) =>
    List<Updatememberresponse>.from(
        json.decode(str).map((x) => Updatememberresponse.fromJson(x)));

String updatememberresponseToJson(List<Updatememberresponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Updatememberresponse {
  String? status;
  String? message;

  Updatememberresponse({
    this.status,
    this.message,
  });

  factory Updatememberresponse.fromJson(Map<String, dynamic> json) =>
      Updatememberresponse(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
