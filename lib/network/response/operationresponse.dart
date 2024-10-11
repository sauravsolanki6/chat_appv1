// To parse this JSON data, do
//
//     final operationresponse = operationresponseFromJson(jsonString);

import 'dart:convert';

List<Operationresponse> operationresponseFromJson(String str) =>
    List<Operationresponse>.from(
        json.decode(str).map((x) => Operationresponse.fromJson(x)));

String operationresponseToJson(List<Operationresponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Operationresponse {
  String? status;
  String? message;
  Data? data;

  Operationresponse({
    this.status,
    this.message,
    this.data,
  });

  factory Operationresponse.fromJson(Map<String, dynamic> json) =>
      Operationresponse(
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
