// To parse this JSON data, do
//
//     final operationcall = operationcallFromJson(jsonString);

import 'dart:convert';

Operationcall operationcallFromJson(String str) =>
    Operationcall.fromJson(json.decode(str));

String operationcallToJson(Operationcall data) => json.encode(data.toJson());

class Operationcall {
  String? memberId;

  Operationcall({
    this.memberId,
  });

  factory Operationcall.fromJson(Map<String, dynamic> json) => Operationcall(
        memberId: json["member_id"],
      );

  Map<String, dynamic> toJson() => {
        "member_id": memberId,
      };
}
