// To parse this JSON data, do
//
//     final updatemembercall = updatemembercallFromJson(jsonString);

import 'dart:convert';

Updatemembercall updatemembercallFromJson(String str) =>
    Updatemembercall.fromJson(json.decode(str));

String updatemembercallToJson(Updatemembercall data) =>
    json.encode(data.toJson());

class Updatemembercall {
  String? name;
  String? mobileNumber;
  String? password;
  String? isAdmin;
  String? memberId;

  Updatemembercall({
    this.name,
    this.mobileNumber,
    this.password,
    this.isAdmin,
    this.memberId,
  });

  factory Updatemembercall.fromJson(Map<String, dynamic> json) =>
      Updatemembercall(
        name: json["name"],
        mobileNumber: json["mobile_number"],
        password: json["password"],
        isAdmin: json["is_admin"],
        memberId: json["member_id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "mobile_number": mobileNumber,
        "password": password,
        "is_admin": isAdmin,
        "member_id": memberId,
      };
}
