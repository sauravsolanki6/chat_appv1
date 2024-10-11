// To parse this JSON data, do
//
//     final changepasswordcall = changepasswordcallFromJson(jsonString);

import 'dart:convert';

List<Changepasswordcall> changepasswordcallFromJson(String str) =>
    List<Changepasswordcall>.from(
        json.decode(str).map((x) => Changepasswordcall.fromJson(x)));

String changepasswordcallToJson(List<Changepasswordcall> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Changepasswordcall {
  String? memberId;
  String? password;

  Changepasswordcall({
    this.memberId,
    this.password,
  });

  factory Changepasswordcall.fromJson(Map<String, dynamic> json) =>
      Changepasswordcall(
        memberId: json["member_id"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "member_id": memberId,
        "password": password,
      };
}
