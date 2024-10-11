import 'package:chat_app/customisedesign.dart/colorfile.dart';
import 'package:flutter/material.dart';

class TextDesign {
  static const TextStyle buttonTextStyleDesign = TextStyle(
    fontSize: 18,
    color: Colors.white,
  );

  static const TextStyle TextStyleDesign =
      TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold);

  static TextStyle boldTextStyleDesign = TextStyle(
      // fontFamily: 'Raleway',
      fontSize: 16,
      color: ColorFile().buttonColor,
      // color: Colors.white,
      fontWeight: FontWeight.bold);

  static const TextStyle alertDialogTittleTextStyleDesign = TextStyle(
    // fontFamily: 'Raleway',
    fontSize: 18,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle alertDialogDescriptioneTextStyleDesign = TextStyle(
    // fontFamily: 'Raleway',
    fontSize: 14,
    color: Colors.black,
    // fontWeight: FontWeight.bold,
  );
  static TextStyle alertDialogbuttonTextStyleDesign = TextStyle(
    // fontFamily: 'Raleway',
    fontSize: 16,
    color: ColorFile().buttonColor,
    // fontWeight: FontWeight.bold,
  );
}
