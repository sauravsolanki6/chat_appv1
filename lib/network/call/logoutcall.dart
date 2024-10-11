// To parse this JSON data, do
//
//     final logoutcall = logoutcallFromJson(jsonString);

import 'dart:convert';

Logoutcall logoutcallFromJson(String str) =>
    Logoutcall.fromJson(json.decode(str));

String logoutcallToJson(Logoutcall data) => json.encode(data.toJson());

class Logoutcall {
  String? memberId;

  Logoutcall({
    this.memberId,
  });

  factory Logoutcall.fromJson(Map<String, dynamic> json) => Logoutcall(
        memberId: json["member_id"],
      );

  Map<String, dynamic> toJson() => {
        "member_id": memberId,
      };
}
