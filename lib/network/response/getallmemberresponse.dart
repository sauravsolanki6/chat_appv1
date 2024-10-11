// To parse this JSON data, do
//
//     final getallmemberresponse = getallmemberresponseFromJson(jsonString);

import 'dart:convert';

List<Getallmemberresponse> getallmemberresponseFromJson(String str) =>
    List<Getallmemberresponse>.from(
        json.decode(str).map((x) => Getallmemberresponse.fromJson(x)));

String getallmemberresponseToJson(List<Getallmemberresponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Getallmemberresponse {
  String? status;
  String? message;
  List<Datum>? data;

  Getallmemberresponse({
    this.status,
    this.message,
    this.data,
  });

  factory Getallmemberresponse.fromJson(Map<String, dynamic> json) =>
      Getallmemberresponse(
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
  String? userId;
  String? id;
  String? name;
  String? mobileNumber;
  String? password;
  String? createdBy;
  String? isAdmin;
  String? isOnline;
  String? isLogout;
  String? alreadyLogin;
  String? logout;
  dynamic lastmessagetime;
  dynamic lastactivetime;
  String? status;
  String? isDeleted;
  DateTime? createdOn;
  DateTime? updatedOn;
  dynamic senderId;
  dynamic receiverId;
  dynamic messageText;
  dynamic isRead;
  dynamic messageType;
  dynamic filename;
  dynamic duration;

  Datum({
    this.userId,
    this.id,
    this.name,
    this.mobileNumber,
    this.password,
    this.createdBy,
    this.isAdmin,
    this.isOnline,
    this.isLogout,
    this.alreadyLogin,
    this.logout,
    this.lastmessagetime,
    this.lastactivetime,
    this.status,
    this.isDeleted,
    this.createdOn,
    this.updatedOn,
    this.senderId,
    this.receiverId,
    this.messageText,
    this.isRead,
    this.messageType,
    this.filename,
    this.duration,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        userId: json["user_id"],
        id: json["id"],
        name: json["name"],
        mobileNumber: json["mobile_number"],
        password: json["password"],
        createdBy: json["created_by"],
        isAdmin: json["is_admin"],
        isOnline: json["is_online"],
        isLogout: json["is_logout"],
        alreadyLogin: json["already_login"],
        logout: json["logout"],
        lastmessagetime: json["lastmessagetime"],
        lastactivetime: json["lastactivetime"],
        status: json["status"],
        isDeleted: json["is_deleted"],
        createdOn: json["created_on"] == null
            ? null
            : DateTime.parse(json["created_on"]),
        updatedOn: json["updated_on"] == null
            ? null
            : DateTime.parse(json["updated_on"]),
        senderId: json["sender_id"],
        receiverId: json["receiver_id"],
        messageText: json["message_text"],
        isRead: json["is_read"],
        messageType: json["message_type"],
        filename: json["filename"],
        duration: json["duration"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "id": id,
        "name": name,
        "mobile_number": mobileNumber,
        "password": password,
        "created_by": createdBy,
        "is_admin": isAdmin,
        "is_online": isOnline,
        "is_logout": isLogout,
        "already_login": alreadyLogin,
        "logout": logout,
        "lastmessagetime": lastmessagetime,
        "lastactivetime": lastactivetime,
        "status": status,
        "is_deleted": isDeleted,
        "created_on": createdOn?.toIso8601String(),
        "updated_on": updatedOn?.toIso8601String(),
        "sender_id": senderId,
        "receiver_id": receiverId,
        "message_text": messageText,
        "is_read": isRead,
        "message_type": messageType,
        "filename": filename,
        "duration": duration,
      };
}
