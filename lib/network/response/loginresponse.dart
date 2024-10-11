// To parse this JSON data, do
//
//     final loginresponse = loginresponseFromJson(jsonString);

import 'dart:convert';

List<Loginresponse> loginresponseFromJson(String str) =>
    List<Loginresponse>.from(
        json.decode(str).map((x) => Loginresponse.fromJson(x)));

String loginresponseToJson(List<Loginresponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Loginresponse {
  String? status;
  String? message;
  Data? data;

  Loginresponse({
    this.status,
    this.message,
    this.data,
  });

  factory Loginresponse.fromJson(Map<String, dynamic> json) => Loginresponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
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
  String? createdOn;
  DateTime? updatedOn;

  Data({
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
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
        createdOn: json["created_on"],
        updatedOn: json["updated_on"] == null
            ? null
            : DateTime.parse(json["updated_on"]),
      );

  Map<String, dynamic> toJson() => {
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
        "created_on": createdOn,
        "updated_on": updatedOn?.toIso8601String(),
      };
}
