// To parse this JSON data, do
//
//     final creatememberresponse = creatememberresponseFromJson(jsonString);

import 'dart:convert';

List<Creatememberresponse> creatememberresponseFromJson(String str) =>
    List<Creatememberresponse>.from(
        json.decode(str).map((x) => Creatememberresponse.fromJson(x)));

String creatememberresponseToJson(List<Creatememberresponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Creatememberresponse {
  String? status;
  String? message;
  Data? data;

  Creatememberresponse({
    this.status,
    this.message,
    this.data,
  });

  factory Creatememberresponse.fromJson(Map<String, dynamic> json) =>
      Creatememberresponse(
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
