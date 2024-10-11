// To parse this JSON data, do
//
//     final updatestatusresponse = updatestatusresponseFromJson(jsonString);

import 'dart:convert';

List<Updatestatusresponse> updatestatusresponseFromJson(String str) =>
    List<Updatestatusresponse>.from(
        json.decode(str).map((x) => Updatestatusresponse.fromJson(x)));

String updatestatusresponseToJson(List<Updatestatusresponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Updatestatusresponse {
  String? status;
  String? message;
  DataUpdateStatus? data;

  Updatestatusresponse({
    this.status,
    this.message,
    this.data,
  });

  factory Updatestatusresponse.fromJson(Map<String, dynamic> json) =>
      Updatestatusresponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : DataUpdateStatus.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class DataUpdateStatus {
  DataUpdateStatus();

  factory DataUpdateStatus.fromJson(Map<String, dynamic> json) =>
      DataUpdateStatus();

  Map<String, dynamic> toJson() => {};
}
