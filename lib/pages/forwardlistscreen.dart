import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../RootPage.dart';
import '../Utility/apis.dart';
import '../Utility/apputility.dart';
import '../Utility/printmessage.dart';
import '../card/forward_chat_card.dart';
import '../customisedesign.dart/colorfile.dart';
import '../customisedesign.dart/messageselection.dart';
import '../customisedesign.dart/progressdialog.dart';
import '../customisedesign.dart/snackbardesign.dart';
import '../network/checkinternetconnection.dart';
import '../network/createjson.dart';
import '../network/networkresponse.dart';
import '../network/response/getallmemberresponse.dart';
import '../network/response/getchatresponse.dart';
import '../network/response/sendmessageresponse.dart';

bool showFloatingActionButton = true;
List<Datum> list = [];
List<Datum> selectedlist = [];
// List<Messagejson> selectedmessagelist = [];

// for storing searched items
final List<Datum> _searchList = [];
late Future<bool> _connectionName;
bool _isSearching = false;

class ForwardlistScreen extends StatefulWidget {
  List<Messagejson> selectedmessagelist;
  MessageSelectionModel messageSelection;
  ForwardlistScreen(this.selectedmessagelist, this.messageSelection);

  State createState() => ForwardlistScreenState();
}

class ForwardlistScreenState extends State<ForwardlistScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _connectionName = CheckInternetConnection().hasNetwork();
    NetworkCallForGetMemberList();
  }

  NetworkCallForGetMemberList() async {
    try {
      String createjson =
          CreateJson().createjsonForGetAllMembers(AppUtility.ID);
      if (await _connectionName) {
        NetworkResponse networkResponse = NetworkResponse();
        List<Object?>? getallmemberresponse = await networkResponse.postMethod(
            AppUtility.getmember, AppUtility.get_member_api, createjson);
        try {
          List<Getallmemberresponse> getallmember =
              List.from(getallmemberresponse!);
          String? status = getallmember[0].status;
          //String status = data![0].status.toString();
          switch (status) {
            case "true":
              list = getallmember[0].data!;
              setState(() {});
              break;
            case "false":
              break;
          }
        } catch (e) {
          PrintMessage.printMessage(
              e.toString(), 'NetworkCallForGetMemberList', 'Home Page');
        }
      }
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'Network Call For Get Member List', 'Home Page');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: WillPopScope(
            onWillPop: () {
              if (_isSearching) {
                setState(() {
                  _isSearching = !_isSearching;
                });
                return Future.value(false);
              } else {
                return Future.value(true);
              }
            },
            child: Scaffold(
                appBar: new AppBar(
                  title: _isSearching
                      ? TextField(
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Name  ...',
                              hintStyle: TextStyle(color: Colors.white)),
                          autofocus: true,
                          style: const TextStyle(
                              fontSize: 17,
                              letterSpacing: 0.5,
                              color: Colors.white),
                          //when search text changes then updated search list
                          onChanged: (val) {
                            //search logic
                            _searchList.clear();

                            for (var i in list) {
                              if (i.name!
                                  .toLowerCase()
                                  .contains(val.toLowerCase())) {
                                _searchList.add(i);
                                setState(() {
                                  _searchList;
                                });
                              }
                            }
                          },
                        )
                      : const Text('Chatapp'),
                  actions: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _isSearching = !_isSearching;
                          });
                        },
                        icon: Icon(_isSearching
                            ? CupertinoIcons.clear_circled_solid
                            : Icons.search)),
                  ],
                  backgroundColor: ColorFile().buttonColor,
                ),
                body: list.length > 0
                    ? ListView.builder(
                        itemCount:
                            _isSearching ? _searchList.length : list.length,
                        padding: EdgeInsets.only(top: 0.1),
                        itemBuilder: (context, intex) {
                          print(list[intex]);

                          return ForwardMemberCard(
                              _isSearching ? _searchList[intex] : list[intex],
                              selectedlist);
                        })
                    : Container(),

                // body: joinCallContaier(),
                floatingActionButton: Visibility(
                  visible: showFloatingActionButton,
                  child: FloatingActionButton(
                    onPressed: () {
                      //Forward Message
                      ProgressDialog.showProgressDialog(
                          context, "Forward Messages");
                      int f = 0;
                      if (AppUtility.selectedlist.length > 0) {
                        for (int i = 0;
                            i < AppUtility.selectedlist.length;
                            i++) {
                          int j = 0;
                          f = widget.selectedmessagelist.length;
                          NetworkcallForSendMessage(
                              AppUtility.selectedlist[i].id!,
                              widget.selectedmessagelist[j].messageType!,
                              widget.selectedmessagelist[j].duration!,
                              widget.selectedmessagelist[j].filename,
                              widget.selectedmessagelist[j].messageText!,
                              f,
                              i,
                              j);
                        }
                      }
                    },
                    child: Icon(Icons.send),
                    backgroundColor: ColorFile().textColor,
                    foregroundColor: Colors.white,
                  ),
                ))));
  }

  movetonext(int f) {
    if (f == 0) {
      Navigator.pop(context);
      AppUtility.selectedlist.clear();
      list.clear();
      widget.selectedmessagelist.clear();
      widget.messageSelection.clearSelection();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => RootPage()),
        (Route<dynamic> route) => false,
      );
      widget.messageSelection.clearSelection();
      widget.selectedmessagelist.clear();
    }
  }

  forwardmessageCall(int i, int j, int f) {
    if (j < widget.selectedmessagelist.length)
      NetworkcallForSendMessage(
          AppUtility.selectedlist[i].id!,
          widget.selectedmessagelist[j].messageType!,
          widget.selectedmessagelist[j].duration!,
          widget.selectedmessagelist[j].filename,
          widget.selectedmessagelist[j].messageText!,
          f,
          i,
          j);
  }

  NetworkcallForSendMessage(
      String receiverid,
      String messagetpe,
      String duration,
      String filename,
      String message,
      int f,
      int i,
      int j) async {
    String createjson = CreateJson().createjsonForSendMessage(
        AppUtility.ID, receiverid, message, messagetpe, duration, filename);
    if (await _connectionName) {
      NetworkResponse networkResponse = NetworkResponse();
      List<Object?>? list = await networkResponse.postMethod(
          AppUtility.send_message, AppUtility.send_message_api, createjson);
      List<Sendmessageresponse> sendmessageResponse = List.from(list!);
      String status = sendmessageResponse[0].status.toString();
      switch (status) {
        case "true":
          Data data = sendmessageResponse[0].data!;
          APIs.SendPushNotification(
              message,
              AppUtility.ID,
              data.pushtoken,
              data.name!,
              data.isAdmin!,
              data.isOnline == 1 ? true : false,
              data.lastmessagetime,
              receiverid);

          f--;
          if (f == 0 && i == AppUtility.selectedlist.length - 1) {
            movetonext(f);
          } else {
            j++;
            forwardmessageCall(i, j, f);
          }

          break;
        case "false":
          break;
      }
    } else {
      SnackBarDesign('Check internet connection', context);
    }
  }
}
