// To parse this JSON data, do
//
//     final checkmobilenumbercall = checkmobilenumbercallFromJson(jsonString);

import 'dart:convert';

Checkmobilenumbercall checkmobilenumbercallFromJson(String str) =>
    Checkmobilenumbercall.fromJson(json.decode(str));

String checkmobilenumbercallToJson(Checkmobilenumbercall data) =>
    json.encode(data.toJson());

class Checkmobilenumbercall {
  String? mobileNumber;

  Checkmobilenumbercall({
    this.mobileNumber,
  });

  factory Checkmobilenumbercall.fromJson(Map<String, dynamic> json) =>
      Checkmobilenumbercall(
        mobileNumber: json["mobile_number"],
      );

  Map<String, dynamic> toJson() => {
        "mobile_number": mobileNumber,
      };
}
