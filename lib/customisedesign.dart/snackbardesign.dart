import 'package:flutter/material.dart';

void SnackBarDesign(String Message, BuildContext context) {
  final snackBar = new SnackBar(content: new Text(Message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
  print(Message);
}
