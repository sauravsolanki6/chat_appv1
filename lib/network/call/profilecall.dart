// To parse this JSON data, do
//
//     final profilecall = profilecallFromJson(jsonString);

import 'dart:convert';

Profilecall profilecallFromJson(String str) =>
    Profilecall.fromJson(json.decode(str));

String profilecallToJson(Profilecall data) => json.encode(data.toJson());

class Profilecall {
  String? userId;

  Profilecall({
    this.userId,
  });

  factory Profilecall.fromJson(Map<String, dynamic> json) => Profilecall(
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
      };
}
