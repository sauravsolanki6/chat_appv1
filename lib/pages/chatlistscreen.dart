import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../Utility/apis.dart';
import '../Utility/apputility.dart';
import '../Utility/login_service.dart';
import '../Utility/printmessage.dart';
import '../Utility/sharedpreference.dart';
import '../card/chat_card.dart';
import '../customisedesign.dart/colorfile.dart';
import '../customisedesign.dart/okalertdialogdesign.dart';
import '../customisedesign.dart/snackbardesign.dart';
import '../network/checkinternetconnection.dart';
import '../network/createjson.dart';
import '../network/networkresponse.dart';
import '../network/response/getchatlist.dart';
import '../network/response/sendmessageresponse.dart';
import '../network/response/updatestatusresponse.dart';
import '../notification_service.dart';
import '../network/response/loginresponse.dart' as loginres;
import 'login.dart';

bool showFloatingActionButton = false;
bool showProgressDialog = false;
bool _isSearching = false;
late Future<bool> _coneectionName;
List<Datum> data = [];
List<Datum> _searchList = [];

class ChatlistScreen extends StatefulWidget {
  State createState() => ChatlistScreenState();
}

class ChatlistScreenState extends State<ChatlistScreen>
    with WidgetsBindingObserver {
  Timer? _timer;
  @override
  void initState() {
    // TODO: implement initState
    try {
      super.initState();
      WidgetsBinding.instance.addObserver(this);
      _coneectionName = CheckInternetConnection().hasNetwork();
      NetworkCallForGetLatestChatList(AppUtility.ID);
      _timer = Timer.periodic(Duration(seconds: 3), (timer) {
        NetworkCallForGetLatestChatList(AppUtility.ID);
      });
      HandlingSignIn();
    } catch (e) {
      PrintMessage.printMessage(e.toString(), 'Init State', 'Chat list Screen');
    }
  }

  HandlingSignIn() async {
    try {
      NotificationServices notificationServices = NotificationServices();
      String pushToken = await notificationServices.getDevicetoken();
      notificationServices.requestNotificationPermission();
      notificationServices.firebaseInit(context);
      notificationServices.setInteractMessage(context);
      String createjsonForlogin = CreateJson().createjsonForLogin(
          AppUtility.USERNAME, AppUtility.PASSWORD, pushToken);
      if (await _coneectionName) {
        NetworkResponse networkResponse = NetworkResponse();
        List<Object?>? login = await networkResponse.postMethod(
            AppUtility.login, AppUtility.login_api, createjsonForlogin);
        try {
          List<loginres.Loginresponse> loginresponse = List.from(login!);
          String? status = loginresponse[0].status;
          switch (status) {
            case "true":
              loginres.Data? data1 = loginresponse[0].data;
              saveValuetoSharedpre(
                  data1!.name.toString(),
                  data1.mobileNumber.toString(),
                  data1.password.toString(),
                  data1.id.toString(),
                  data1.isAdmin.toString(),
                  pushToken,
                  data1.isAdmin.toString(),
                  data1.status.toString(),
                  true);

              break;
            case "false":
              Showdialogforlogout(
                  "Your password changed by admin please contact to admin");
              // SnackBarDesign('Enter vaild username and password', context);
              break;
          }
        } catch (e) {
          PrintMessage.printMessage(e.toString(), 'Handle Sign In', 'Login');
        }
      }
    } catch (e) {
      PrintMessage.printMessage(e.toString(), 'Handle Sign in', 'Login In');
    }
  }

  saveValuetoSharedpre(
      String Name,
      String UserName,
      String Password,
      String Id,
      String LogedinMemberIsAdmin,
      String pushtoken,
      String isAdmin,
      String Status,
      bool isFirstTimeLogin) {
    try {
      SharedPreference().savevalueonlogin(Name, UserName, Password, Id,
          LogedinMemberIsAdmin, pushtoken, isAdmin, Status, isFirstTimeLogin);
    } catch (e) {
      PrintMessage.printMessage(e.toString(), 'saveValuetoSharedpre', 'Login');
    }
  }

  Showdialogforlogout(String msg) {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return OkAlertDialogDesign(
              yesbuttonPressed: () {
                Navigator.of(context).pop();
                logout();
              },
              title: "Warning!!",
              description: msg);
        },
      );
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'Showdialogforlogout', 'Root Page ');
    }
  }

  logout() {
    try {
      SharedPreference().setValueToSharedPrefernce("UserName", "");
      SharedPreference().setValueToSharedPrefernce("Password", "");
      SharedPreference().setValueToSharedPrefernce("Id", "");
      SharedPreference().setValueToSharedPrefernce("LogedInMemberIsAdmin", "");
      SharedPreference().setValueToSharedPrefernce("Push_Token", "");
//Update active status
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      PrintMessage.printMessage(e.toString(), 'logout', 'Root Page ');
    }
  }

  static bool inited = false;
  Future<void> init() async {
    if (inited) return;
    onUserLogin();
    inited = true;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // print("app in resumed");
        break;
      case AppLifecycleState.inactive:
        // print("app in inactive");
        NetworkCallForUpdateStatus();
        break;
      case AppLifecycleState.paused:
        // print("app in paused");
        break;
      case AppLifecycleState.detached:
        // print("app in detached");
        break;
    }
  }

  NetworkCallForUpdateStatus() async {
    try {
      String createjson = CreateJson().createjsonForUpdateStatus(
          AppUtility.ID, DateTime.now().millisecondsSinceEpoch.toString());
      if (await _coneectionName) {
        NetworkResponse networkResponse = NetworkResponse();
        List<Object?>? list = await networkResponse.postMethod(
            AppUtility.updatestatus, AppUtility.update_status, createjson);
        List<Updatestatusresponse> updateresponse = List.from(list!);
        String status = updateresponse[0].status.toString();
        switch (status) {
          case "true":
            break;
          case "false":
            break;
        }
      }
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'NetworkCallForUpdateStatus', 'Chat list Screen');
    }
  }

  NetworkCallForGetLatestChatList(String id) async {
    String createjson = CreateJson().createjsonForHold(id);
    if (await _coneectionName) {
      NetworkResponse networkResponse = NetworkResponse();
      List<Object?>? listresponse = await networkResponse.postMethod(
          AppUtility.getlatestchat,
          AppUtility.get_latest_chat_list_api,
          createjson);
      if (listresponse != null) {
        List<Getchatlistresponse> chatlist = List.from(listresponse);
        String status = chatlist[0].status!;
        switch (status) {
          case "true":
            data = chatlist[0].data!;
            //  setState(() {}); //Payal commented this code and added below
            if (!mounted) {
              _timer?.cancel();
            } else {
              setState(() {});
            }
            break;
          case "false":
            data = [];
            break;
        }
      }
    } else {
      SnackBarDesign('Check internet connection', context);
    }
  }

  @override
  void dispose() {
    try {
      super.dispose();
      // WidgetsBinding.instance?.removeObserver(this);
      _timer?.cancel();
    } catch (e) {
      PrintMessage.printMessage(e.toString(), 'dispose', 'Chat list Screen');
    }
  }

  NetworkcallForSendMessage(
      String receiverid,
      String senderId,
      String messagetpe,
      String duration,
      String filename,
      String message) async {
    String createjson = CreateJson().createjsonForSendMessage(
        senderId, receiverid, message, messagetpe, duration, filename);
    if (await _coneectionName) {
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
              DateTime.now().millisecondsSinceEpoch.toString(),
              receiverid);

          break;
        case "false":
          break;
      }
    } else {
      SnackBarDesign('Check internet connection', context);
    }
  }

  ShowSnackBarForCallEvents(String Message, int code, String receiverid) async {
    try {
      String senderId = AppUtility.ID;
      switch (code) {
        // case 1: //Send messge-- Reject Call
        //   NetworkcallForSendMessage(
        //     receiverid, senderId, 'call', " ", "", Message);
        // break;
        case 2: //Send messge--Decline Call
          {
            NetworkcallForSendMessage(
                senderId, receiverid, 'call', " ", "", Message);
          }
          break;
        case 3:
          {
            NetworkcallForSendMessage(
                receiverid, senderId, 'call', " ", "", Message);
          }
          break;
        default:
          break;
      }
    } catch (e) {
      log("Exception: ${e.toString()}");
      PrintMessage.printMessage(
          e.toString(), 'ShowSnackBarForCallEvents', 'Chat list Screen');
    }
  }

  Future<void> requestPermissions() async {
    try {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
        Permission.microphone,
        Permission.storage,
        Permission.notification,
        Permission.manageExternalStorage
      ].request();
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'Request Permission', 'Chat list Screen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (_isSearching) {
          setState(() {
            _isSearching = false; // Close the search mode when back is pressed
          });
          return Future.value(false);
        } else {
          return ZegoUIKit().onWillPop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorFile().buttonColor,
          title: GestureDetector(
            onTap: () {
              setState(() {
                _isSearching = true; // Always set to true to enter search mode
              });
            },
            child: _isSearching
                ? Container(
                    decoration: BoxDecoration(
                      color: ColorFile()
                          .buttonColor, // Background color for search bar
                      borderRadius:
                          BorderRadius.circular(20), // Rounded corners
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none, // No border
                        hintText: 'Search...',
                        hintStyle:
                            TextStyle(color: Colors.white60), // Hint text color
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20), // Vertical and horizontal padding
                      ),
                      autofocus: true,
                      style: TextStyle(
                          fontSize: 17,
                          letterSpacing: 0.5,
                          color: Colors.white),
                      onChanged: (val) {
                        _searchList.clear();
                        for (var i in data) {
                          if (i.name!
                              .toLowerCase()
                              .contains(val.toLowerCase())) {
                            _searchList.add(i);
                          }
                        }
                        setState(() {});
                      },
                    ),
                  )
                : Text(
                    'Search...',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching; // Toggle search mode
                });
              },
              icon: Icon(
                _isSearching ? Icons.close : Icons.search,
                color: Colors.white, // Set the icon color to white
              ),
            ),
          ],
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return ChatListCard(
                _isSearching ? _searchList[index] : data[index]);
          },
          itemCount: _isSearching ? _searchList.length : data.length,
        ),
      ),
    );
  }
}
