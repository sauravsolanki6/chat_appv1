// To parse this JSON data, do
//
//     final getchatresponse = getchatresponseFromJson(jsonString);

import 'dart:convert';

List<Getchatresponse> getchatresponseFromJson(String str) =>
    List<Getchatresponse>.from(
        json.decode(str).map((x) => Getchatresponse.fromJson(x)));

String getchatresponseToJson(List<Getchatresponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Getchatresponse {
  String? status;
  String? message;
  String? isOnline;
  String? filepath;
  List<Messagejson>? data;

  Getchatresponse({
    this.status,
    this.message,
    this.isOnline,
    this.filepath,
    this.data,
  });

  factory Getchatresponse.fromJson(Map<String, dynamic> json) =>
      Getchatresponse(
        status: json["status"],
        message: json["message"],
        isOnline: json["is_online"],
        filepath: json["file_path"],
        data: json["data"] == null
            ? []
            : List<Messagejson>.from(
                json["data"]!.map((x) => Messagejson.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "is_online": isOnline,
        "file_path": filepath,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Messagejson {
  String? id;
  String? senderId;
  String? receiverId;
  String? messageText;
  String? isRead;
  String? messageType;
  dynamic filename;
  String? duration;
  String? timestamp;
  String? status;
  String? isDeleted;
  DateTime? createdOn;
  DateTime? updatedOn;

  Messagejson({
    this.id,
    this.senderId,
    this.receiverId,
    this.messageText,
    this.isRead,
    this.messageType,
    this.filename,
    this.duration,
    this.timestamp,
    this.status,
    this.isDeleted,
    this.createdOn,
    this.updatedOn,
  });

  factory Messagejson.fromJson(Map<String, dynamic> json) => Messagejson(
        id: json["id"],
        senderId: json["sender_id"],
        receiverId: json["receiver_id"],
        messageText: json["message_text"],
        isRead: json["is_read"],
        messageType: json["message_type"],
        filename: json["filename"],
        duration: json["duration"],
        timestamp: json["timestamp"],
        status: json["status"],
        isDeleted: json["is_deleted"],
        createdOn: json["created_on"] == null
            ? null
            : DateTime.parse(json["created_on"]),
        updatedOn: json["updated_on"] == null
            ? null
            : DateTime.parse(json["updated_on"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sender_id": senderId,
        "receiver_id": receiverId,
        "message_text": messageText,
        "is_read": isRead,
        "message_type": messageType,
        "filename": filename,
        "duration": duration,
        "timestamp": timestamp,
        "status": status,
        "is_deleted": isDeleted,
        "created_on": createdOn?.toIso8601String(),
        "updated_on": updatedOn?.toIso8601String(),
      };
}
