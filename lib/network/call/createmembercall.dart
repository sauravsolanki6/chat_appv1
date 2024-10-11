// To parse this JSON data, do
//
//     final createmembercall = createmembercallFromJson(jsonString);

import 'dart:convert';

List<Createmembercall> createmembercallFromJson(String str) =>
    List<Createmembercall>.from(
        json.decode(str).map((x) => Createmembercall.fromJson(x)));

String createmembercallToJson(List<Createmembercall> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Createmembercall {
  String? name;
  String? mobileNumber;
  String? password;
  String? createdBy;
  String? isAdmin;

  Createmembercall({
    this.name,
    this.mobileNumber,
    this.password,
    this.createdBy,
    this.isAdmin,
  });

  factory Createmembercall.fromJson(Map<String, dynamic> json) =>
      Createmembercall(
        name: json["name"],
        mobileNumber: json["mobile_number"],
        password: json["password"],
        createdBy: json["created_by"],
        isAdmin: json["is_admin"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "mobile_number": mobileNumber,
        "password": password,
        "created_by": createdBy,
        "is_admin": isAdmin,
      };
}
