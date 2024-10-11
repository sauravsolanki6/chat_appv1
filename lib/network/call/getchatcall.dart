// To parse this JSON data, do
//
//     final getchatcall = getchatcallFromJson(jsonString);

import 'dart:convert';

Getchatcall getchatcallFromJson(String str) =>
    Getchatcall.fromJson(json.decode(str));

String getchatcallToJson(Getchatcall data) => json.encode(data.toJson());

class Getchatcall {
  String? memberId;
  String? senderId;

  Getchatcall({
    this.memberId,
    this.senderId,
  });

  factory Getchatcall.fromJson(Map<String, dynamic> json) => Getchatcall(
        memberId: json["member_id"],
        senderId: json["sender_id"],
      );

  Map<String, dynamic> toJson() => {
        "member_id": memberId,
        "sender_id": senderId,
      };
}
