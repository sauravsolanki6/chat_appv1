// To parse this JSON data, do
//
//     final editmessageresponse = editmessageresponseFromJson(jsonString);

import 'dart:convert';

List<Editmessageresponse> editmessageresponseFromJson(String str) =>
    List<Editmessageresponse>.from(
        json.decode(str).map((x) => Editmessageresponse.fromJson(x)));

String editmessageresponseToJson(List<Editmessageresponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Editmessageresponse {
  String? status;
  String? message;
  EditmessageData? data;

  Editmessageresponse({
    this.status,
    this.message,
    this.data,
  });

  factory Editmessageresponse.fromJson(Map<String, dynamic> json) =>
      Editmessageresponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : EditmessageData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class EditmessageData {
  EditmessageData();

  factory EditmessageData.fromJson(Map<String, dynamic> json) =>
      EditmessageData();

  Map<String, dynamic> toJson() => {};
}
