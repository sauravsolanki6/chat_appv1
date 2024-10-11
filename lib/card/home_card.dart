import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Utility/apputility.dart';
import '../customisedesign.dart/alertdialogdesign.dart';
import '../customisedesign.dart/colorfile.dart';
import '../customisedesign.dart/snackbardesign.dart';
import '../customisedesign.dart/textdesign.dart';
import '../network/checkinternetconnection.dart';
import '../network/createjson.dart';
import '../network/networkresponse.dart';
import '../network/response/getallmemberresponse.dart';
import '../network/response/operationresponse.dart';
import '../pages/chatscreen.dart';
import '../pages/editmember.dart';

late Future<bool> _checkInternetconnection;

class HomeCard extends StatefulWidget {
  final Datum chatmemberjson;
  final bool showIcon;
  final Color colorforhold;

  HomeCard(this.chatmemberjson, this.showIcon, this.colorforhold);

  @override
  State createState() => HomeCardState();
}

class HomeCardState extends State<HomeCard> {
  late int unreadmessages;

  @override
  void initState() {
    super.initState();
    _checkInternetconnection = CheckInternetConnection().hasNetwork();
  }

  @override
  Widget build(BuildContext context) {
    String _name = widget.chatmemberjson.name.toString();

    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2.0,
            spreadRadius: 0.5,
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          bool isOnline = false;
          if (widget.chatmemberjson.isOnline == 1) {
            isOnline = true;
          }

          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return ChatScreen(
              AppUtility.ID,
              widget.chatmemberjson.name!,
              isOnline,
              widget.chatmemberjson.lastmessagetime,
              widget.chatmemberjson.id!,
            );
          }));
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(22.5),
                child: Icon(
                  CupertinoIcons.person_alt_circle_fill,
                  size: 45,
                  color: ColorFile().icon,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _name.length > 10 ? _name.substring(0, 10) + '..' : _name,
                      style: TextStyle(
                        fontSize: 16,
                        color: ColorFile().textColor,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      widget.chatmemberjson.mobileNumber.toString(),
                      maxLines: 1,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              if (widget.showIcon) ...[
                PopupMenuButton(
                  color: Colors.white,
                  icon: Icon(Icons.more_horiz, color: ColorFile().textColor),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.front_hand_outlined,
                            color: widget.colorforhold),
                        title: Text("Hold"),
                        onTap: () {
                          Navigator.of(context).pop(); // Close the menu
                          showConfirmationDialog(
                            context,
                            "H",
                            widget.chatmemberjson.id.toString(),
                            widget.chatmemberjson.status.toString(),
                          );
                        },
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        leading:
                            Icon(Icons.delete, color: ColorFile().textColor),
                        title: Text("Delete"),
                        onTap: () {
                          Navigator.of(context).pop(); // Close the menu
                          showConfirmationDialog(
                            context,
                            "D",
                            widget.chatmemberjson.id.toString(),
                            "",
                          );
                        },
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.edit, color: ColorFile().textColor),
                        title: Text("Edit"),
                        onTap: () {
                          Navigator.of(context).pop(); // Close the menu
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return EditMember(
                                widget.chatmemberjson.id.toString(),
                                widget.chatmemberjson);
                          }));
                        },
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.chat, color: ColorFile().textColor),
                        title: Text("Clear Chat"),
                        onTap: () {
                          Navigator.of(context).pop(); // Close the menu
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialogDesign(
                                yesbuttonPressed: () {
                                  Networkcallfordelete(AppUtility.ID,
                                      widget.chatmemberjson.id.toString());
                                  Navigator.of(context).pop();
                                },
                                nobuttonPressed: () {
                                  Navigator.of(context).pop();
                                },
                                title: "Confirmation!!",
                                description:
                                    "Are you sure? You want to clear chat",
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  showConfirmationDialog(
      BuildContext context1, String operation, String Id, String Status) {
    String OperationName = "";
    if (operation == "D") {
      OperationName = "delete?";
    } else if (operation == "H") {
      OperationName = Status == "1" ? "hold?" : "unhold?";
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialogDesign(
          yesbuttonPressed: () {
            Navigator.of(context).pop();
            updateDatebase(operation, Status);
            NetworkCallForOperation(context1, operation, Id, Status);
          },
          nobuttonPressed: () {
            Navigator.of(context).pop();
          },
          title: "Confirmation!!",
          description: "Are you sure? You want to " + OperationName,
        );
      },
    );
  }

  NetworkCallForOperation(
      BuildContext context, String operation, String id, String status) async {
    String createjson = CreateJson().createjsonForHold(id);
    String api = "";
    String message = "";
    if (operation == "H") {
      api = status == "1" ? AppUtility.hold_api : AppUtility.active_api;
      message = status == "1" ? "Hold Success" : "Unhold Success";
    }
    if (operation == "D") {
      api = AppUtility.delete_api;
      message = 'Delete Success';
    }
    if (await _checkInternetconnection) {
      NetworkResponse networkResponse = NetworkResponse();
      List<Object?>? operation = await networkResponse.postMethod(
          AppUtility.operation, api, createjson);
      List<Operationresponse> operationresponse = List.from(operation!);
      String? status = operationresponse[0].status;
      if (status == "true") {
        SnackBarDesign(message, context);
        setState(() {});
      } else {
        SnackBarDesign('Something went wrong', context);
      }
    }
  }

  Networkcallfordelete(String memberid, String id) async {
    String createjson = CreateJson().createjsonForDelete(memberid, id);
    if (await _checkInternetconnection) {
      NetworkResponse networkResponse = NetworkResponse();
      List<Object?>? operation = await networkResponse.postMethod(
          AppUtility.operation, AppUtility.clear_api, createjson);
      List<Operationresponse> operationresponse = List.from(operation!);
      String? status = operationresponse[0].status;
      if (status == "true") {
        SnackBarDesign("Chat cleared", context);
        setState(() {});
      } else {
        SnackBarDesign('Something went wrong', context);
      }
    }
  }

  updateDatebase(String opration, String status) {
    if (opration == "H") {
      widget.chatmemberjson.status = status == "1" ? "0" : "1";
    }
    if (opration == "D") {
      widget.chatmemberjson.isDeleted = "1";
    }
  }
}
