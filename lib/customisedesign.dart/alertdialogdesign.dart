import 'package:flutter/material.dart';

import 'textdesign.dart';

class AlertDialogDesign extends StatelessWidget {
  final VoidCallback yesbuttonPressed;
  final VoidCallback nobuttonPressed;
  final String title;
  final String description;
  final double thickness;
  const AlertDialogDesign({
    Key? key,
    required this.yesbuttonPressed,
    required this.nobuttonPressed,
    required this.title,
    required this.description,
    this.thickness = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Container(
      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 5,
            width: 25,
          ),
          Row(
            children: [
              Image.asset('assets/images/chatbox.png', width: 50, height: 50),
              SizedBox(width: 15, height: 5),
              Text(title, style: TextDesign.alertDialogTittleTextStyleDesign),
            ],
          ),
          Text(
            description,
            style: TextDesign.alertDialogDescriptioneTextStyleDesign,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15.0),
                    bottomRight: Radius.circular(15.0),
                  ),
                  highlightColor: Colors.grey[200],
                  onTap: nobuttonPressed,
                  child: Center(
                    child: Text(
                      "NO",
                      style: TextDesign.alertDialogbuttonTextStyleDesign,
                    ),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                InkWell(
                  onTap: yesbuttonPressed,
                  child: Center(
                    child: Text("YES",
                        style: TextDesign.alertDialogbuttonTextStyleDesign),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
