import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Utility/apputility.dart';
import '../Utility/mydateutil.dart';
import '../customisedesign.dart/colorfile.dart';
import '../customisedesign.dart/textdesign.dart';
import '../network/response/getchatlist.dart';
import '../pages/chatscreen.dart';

class ChatListCard extends StatefulWidget {
  final Datum datum;

  ChatListCard(this.datum);

  @override
  State createState() => ChatListCardState();
}

class ChatListCardState extends State<ChatListCard> {
  @override
  Widget build(BuildContext context) {
    String _name = widget.datum.name.toString();
    return InkWell(
      onTap: () {
        bool isOnline = widget.datum.isOnline == "1";
        String receiverid = (widget.datum.receiverId == AppUtility.ID)
            ? widget.datum.senderId!
            : widget.datum.receiverId!;

        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return ChatScreen(AppUtility.ID, widget.datum.name!, isOnline,
              widget.datum.lastMessageTime!, receiverid);
        }));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: ColorFile().textborderColor,
              width: 0.5, // Thinner separator line
            ),
          ),
        ),
        child: Row(
          children: [
            // Circular avatar without borders and grey color
            ClipOval(
              child: Container(
                width: 50,
                height: 50,
                // color: Colors.grey[300], // Set the background color to grey
                child: Center(
                  child: Icon(
                    CupertinoIcons.person_alt_circle_fill,
                    size: 45,
                    color: Colors.grey, // Set icon color to white for contrast
                  ),
                ),
              ),
            ),

            _space,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name text styled like WhatsApp
                  Text(
                    _name.length > 20 ? _name.substring(0, 20) + '..' : _name,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500, // Semi-bold for name
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 3),
                  // Last message preview styled like WhatsApp
                  Text(
                    widget.datum.messageText.toString().length > 40
                        ? widget.datum.messageText.toString().substring(0, 40) +
                            '...'
                        : widget.datum.messageText.toString(),
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            _space,
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Last message time styled like WhatsApp
                Text(
                  MyDateUtil.getLastActiveTimeForList(
                    context: context,
                    lastActive: widget.datum.lastMessageTime.toString(),
                  ),
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                SizedBox(height: 5),
                // Unread message counter styled like WhatsApp
                widget.datum.messageCounter! > 0
                    ? CircleAvatar(
                        backgroundColor: Color(0xFF25D366), // WhatsApp green
                        maxRadius: 10,
                        child: Center(
                          child: Text(
                            widget.datum.messageCounter.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget get _space => const SizedBox(width: 12);
}
