// To parse this JSON data, do
//
//     final editmessagecall = editmessagecallFromJson(jsonString);

import 'dart:convert';

List<Editmessagecall> editmessagecallFromJson(String str) =>
    List<Editmessagecall>.from(
        json.decode(str).map((x) => Editmessagecall.fromJson(x)));

String editmessagecallToJson(List<Editmessagecall> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Editmessagecall {
  String? id;
  String? messageText;

  Editmessagecall({
    this.id,
    this.messageText,
  });

  factory Editmessagecall.fromJson(Map<String, dynamic> json) =>
      Editmessagecall(
        id: json["id"],
        messageText: json["message_text"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "message_text": messageText,
      };
}
