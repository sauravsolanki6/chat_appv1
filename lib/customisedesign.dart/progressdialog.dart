import 'package:flutter/material.dart';

import 'colorfile.dart';

class ProgressDialog {
  static showProgressDialog(BuildContext context, String title) async {
    try {
      AlertDialog alert = AlertDialog(
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: Row(
          mainAxisSize: MainAxisSize.min, // Minimal layout
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 2.0, // Thinner progress indicator for a minimal look
            ),
            SizedBox(width: 15), // Small spacing
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500, // Slightly lighter font weight
                  fontSize: 16, // Smaller text size for minimal design
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis, // Avoid text overflow
              ),
            ),
          ],
        ),
        backgroundColor: ColorFile().buttonColor, // Custom button color
      );
      await Future.delayed(Duration(milliseconds: 50));
      showDialog(
        context: context,
        barrierDismissible: false, // Prevents closing when tapping outside
        builder: (BuildContext context) {
          return alert;
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }
}
