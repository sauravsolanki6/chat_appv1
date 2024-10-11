// To parse this JSON data, do
//
//     final updatestatuscall = updatestatuscallFromJson(jsonString);

import 'dart:convert';

Updatestatuscall updatestatuscallFromJson(String str) =>
    Updatestatuscall.fromJson(json.decode(str));

String updatestatuscallToJson(Updatestatuscall data) =>
    json.encode(data.toJson());

class Updatestatuscall {
  String? memberId;
  String? timestamp;

  Updatestatuscall({
    this.memberId,
    this.timestamp,
  });

  factory Updatestatuscall.fromJson(Map<String, dynamic> json) =>
      Updatestatuscall(
        memberId: json["member_id"],
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "member_id": memberId,
        "timestamp": timestamp,
      };
}
