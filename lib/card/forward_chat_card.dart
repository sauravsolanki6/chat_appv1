import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Utility/apputility.dart';
import '../customisedesign.dart/colorfile.dart';
import '../customisedesign.dart/textdesign.dart';
import '../network/response/getallmemberresponse.dart';

bool visibleCheckbox = false;
bool isSelected = false;

class ForwardMemberCard extends StatefulWidget {
  Datum chatmemberjson;
  // List<Messagejson> selectedmessagelist;

  List<Datum> selectedlist;
  ForwardMemberCard(this.chatmemberjson, this.selectedlist);
  // ForwardMemberCard(this.chatmemberjson, this.msg, this.fromid, this.type,
  //     this.selectedlist, this.duration);
  State createState() => ForwardMemberCardState();
}

class ForwardMemberCardState extends State<ForwardMemberCard> {
  void updateValues(Datum chatmemberjson) {
    if (widget.selectedlist.contains(chatmemberjson)) {
      widget.selectedlist.remove(chatmemberjson);
      AppUtility.selectedlist.remove(chatmemberjson);
      setState(() {
        visibleCheckbox = false;
      });
    } else {
      widget.selectedlist.add(chatmemberjson);
      AppUtility.selectedlist.add(chatmemberjson);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    visibleCheckbox = false;
  }

  @override
  Widget build(BuildContext context) {
    String _name = widget.chatmemberjson.name.toString();
    return Card(
      //  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      // elevation: 0.5,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 2),
      child: InkWell(
        onTap: () {
          setState(() {
            visibleCheckbox = true;
          });

          updateValues(widget.chatmemberjson);
        },
        child: Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.all(5),
          child: Row(children: [
            Stack(
              children: [
                ClipRRect(
                  //  borderRadius: BorderRadius.circular(3),
                  child: Icon(
                    CupertinoIcons.person_alt_circle_fill,
                    size: 45,
                    color: ColorFile().buttonColor,
                  ),
                ),
                Positioned(
                  // right: 5,
                  top: 15,
                  left: 15,
                  child: visibleCheckbox
                      ? Checkbox(
                          shape: CircleBorder(),
                          checkColor: Colors.white,
                          // fillColor: MaterialStateProperty.resolveWith(getColor),
                          value: widget.selectedlist
                              .contains(widget.chatmemberjson),
                          onChanged: (v) {
                            setState(() {
                              isSelected = v!;

                              updateValues(widget.chatmemberjson);
                            });
                            // parent inkwell will handle this
                          },
                        )
                      : Container(),
                ),
              ],
            ),
            _space,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Name of Member
                Text(
                  _name.length > 10 ? _name.substring(0, 10) + '..' : _name,
                  style: TextDesign.boldTextStyleDesign,
                  overflow: TextOverflow.ellipsis,
                ),

                Text(
                  widget.chatmemberjson.mobileNumber.toString(),
                  maxLines: 1,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            Spacer(),
          ]),
        ),
      ),
    );
  }

  Widget get _space => const SizedBox(width: 10);
}
