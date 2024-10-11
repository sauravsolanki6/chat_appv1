// To parse this JSON data, do
//
//     final deletechatcall = deletechatcallFromJson(jsonString);

import 'dart:convert';

Deletechatcall deletechatcallFromJson(String str) =>
    Deletechatcall.fromJson(json.decode(str));

String deletechatcallToJson(Deletechatcall data) => json.encode(data.toJson());

class Deletechatcall {
  String? senderId;
  String? memberId;

  Deletechatcall({
    this.senderId,
    this.memberId,
  });

  factory Deletechatcall.fromJson(Map<String, dynamic> json) => Deletechatcall(
        senderId: json["sender_id"],
        memberId: json["member_id"],
      );

  Map<String, dynamic> toJson() => {
        "sender_id": senderId,
        "member_id": memberId,
      };
}
