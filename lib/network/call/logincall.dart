// To parse this JSON data, do
//
//     final logincall = logincallFromJson(jsonString);

import 'dart:convert';

Logincall logincallFromJson(String str) => Logincall.fromJson(json.decode(str));

String logincallToJson(Logincall data) => json.encode(data.toJson());

class Logincall {
  String? mobileNumber;
  String? password;
  String? timestamp;
  String? pushtoken;

  Logincall({
    this.mobileNumber,
    this.password,
    this.timestamp,
    this.pushtoken,
  });

  factory Logincall.fromJson(Map<String, dynamic> json) => Logincall(
        mobileNumber: json["mobile_number"],
        password: json["password"],
        timestamp: json["timestamp"],
        pushtoken: json["pushtoken"],
      );

  Map<String, dynamic> toJson() => {
        "mobile_number": mobileNumber,
        "password": password,
        "timestamp": timestamp,
        "pushtoken": pushtoken,
      };
}
