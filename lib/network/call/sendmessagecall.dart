// To parse this JSON data, do
//
//     final sendmessagecall = sendmessagecallFromJson(jsonString);

import 'dart:convert';

Sendmessagecall sendmessagecallFromJson(String str) =>
    Sendmessagecall.fromJson(json.decode(str));

String sendmessagecallToJson(Sendmessagecall data) =>
    json.encode(data.toJson());

class Sendmessagecall {
  String? senderId;
  String? receiverId;
  String? messageText;
  String? messageType;
  String? duration;
  String? filename;
  String? timestamp;

  Sendmessagecall({
    this.senderId,
    this.receiverId,
    this.messageText,
    this.messageType,
    this.duration,
    this.filename,
    this.timestamp,
  });

  factory Sendmessagecall.fromJson(Map<String, dynamic> json) =>
      Sendmessagecall(
        senderId: json["sender_id"],
        receiverId: json["receiver_id"],
        messageText: json["message_text"],
        messageType: json["message_type"],
        duration: json["duration"],
        filename: json["filename"],
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "sender_id": senderId,
        "receiver_id": receiverId,
        "message_text": messageText,
        "message_type": messageType,
        "duration": duration,
        "filename": filename,
        "timestamp": timestamp,
      };
}
