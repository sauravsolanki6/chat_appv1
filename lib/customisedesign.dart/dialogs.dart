import 'package:flutter/material.dart';

import 'colorfile.dart';

class Dialogs {
  static void showSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: ColorFile().buttonColor.withOpacity(.8),
        behavior: SnackBarBehavior.floating));
  }
}
