// To parse this JSON data, do
//
//     final changepasswordresponse = changepasswordresponseFromJson(jsonString);

import 'dart:convert';

List<Changepasswordresponse> changepasswordresponseFromJson(String str) =>
    List<Changepasswordresponse>.from(
        json.decode(str).map((x) => Changepasswordresponse.fromJson(x)));

String changepasswordresponseToJson(List<Changepasswordresponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Changepasswordresponse {
  String? status;
  String? message;
  Data? data;

  Changepasswordresponse({
    this.status,
    this.message,
    this.data,
  });

  factory Changepasswordresponse.fromJson(Map<String, dynamic> json) =>
      Changepasswordresponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  Data();

  factory Data.fromJson(Map<String, dynamic> json) => Data();

  Map<String, dynamic> toJson() => {};
}
