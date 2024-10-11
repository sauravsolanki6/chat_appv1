// To parse this JSON data, do
//
//     final getchatlistresponse = getchatlistresponseFromJson(jsonString);

import 'dart:convert';

List<Getchatlistresponse> getchatlistresponseFromJson(String str) =>
    List<Getchatlistresponse>.from(
        json.decode(str).map((x) => Getchatlistresponse.fromJson(x)));

String getchatlistresponseToJson(List<Getchatlistresponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Getchatlistresponse {
  String? status;
  String? message;
  List<Datum>? data;

  Getchatlistresponse({
    this.status,
    this.message,
    this.data,
  });

  factory Getchatlistresponse.fromJson(Map<String, dynamic> json) =>
      Getchatlistresponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  String? id;
  String? isRead;
  String? messageText;
  String? senderId;
  String? receiverId;
  String? lastMessageTime;
  String? name;
  String? lastactivetime;
  String? isOnline;
  int? side;
  int? messageCounter;

  Datum({
    this.id,
    this.isRead,
    this.messageText,
    this.senderId,
    this.receiverId,
    this.lastMessageTime,
    this.name,
    this.lastactivetime,
    this.isOnline,
    this.side,
    this.messageCounter,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        isRead: json["is_read"],
        messageText: json["message_text"],
        senderId: json["sender_id"],
        receiverId: json["receiver_id"],
        lastMessageTime: json["last_message_time"],
        name: json["name"],
        lastactivetime: json["lastactivetime"],
        isOnline: json["is_online"],
        side: json["side"],
        messageCounter: json["message_counter"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "is_read": isRead,
        "message_text": messageText,
        "sender_id": senderId,
        "receiver_id": receiverId,
        "last_message_time": lastMessageTime,
        "name": name,
        "lastactivetime": lastactivetime,
        "is_online": isOnline,
        "side": side,
        "message_counter": messageCounter,
      };
}
