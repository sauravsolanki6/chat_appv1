import 'dart:io';
import 'package:chat_app/customisedesign.dart/colorfile.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'Utility/apputility.dart';
import 'Utility/login_service.dart';
import 'Utility/printmessage.dart';
import 'Utility/sharedpreference.dart';
import 'customisedesign.dart/colors.dart';
import 'customisedesign.dart/okalertdialogdesign.dart';
import 'network/createjson.dart';
import 'network/networkresponse.dart';
import 'network/response/profileresponse.dart';
import 'pages/chatlistscreen.dart';
import 'pages/homepage.dart';
import 'pages/login.dart';
import 'pages/profilescreen.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int selectedIndex = 1; // Default selected index set to Chats
  final ScrollController scrollController = ScrollController();
  bool _dataFetched = false;
  ColorFile colorFile = ColorFile();

  @override
  void initState() {
    try {
      super.initState();
      init();
      NetworkCallForProfile();
    } catch (e) {
      PrintMessage.printMessage(e.toString(), 'initState', 'Root Page ');
    }
  }

  static bool inited = false;
  Future<void> init() async {
    if (inited) return;
    onUserLogin();
    inited = true;
  }

  NetworkCallForProfile() async {
    try {
      String createjson = CreateJson().createjsonForProfile(AppUtility.ID);
      NetworkResponse networkResponse = NetworkResponse();
      List<Object?>? list = await networkResponse.postMethod(
          AppUtility.profile, AppUtility.profile_api, createjson);
      List<Profileresponse> response = List.from(list!);
      String status = response[0].status!;
      switch (status) {
        case "true":
          if (response[0].data == null) {
          } else {
            String push_token = response[0].data!.pushtoken!;
            String status1 = response[0].data!.status!;
            if (AppUtility.PUSH_TOKEN != push_token) {
              Showdialogforlogout(
                  "Already logged in somewhere, Logout from here");
            }
            if (status1 == "0") {
              Showdialogforlogout("You are on hold, contact admin");
            }
          }
          break;
        case "false":
          break;
      }
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'NetworkCallForProfile', 'Root Page');
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
              title: "Confirmation!!",
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
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      PrintMessage.printMessage(e.toString(), 'logout', 'Root Page ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          colorFile.whatsAppGreen, // WhatsApp green background color
      appBar: AppBar(
        backgroundColor: colorFile.whatsAppGreen, // WhatsApp green
        elevation: 0, // Flat design like WhatsApp
        title: Text(
          'Chat App', // Your app title
          style: TextStyle(
            fontSize: 30, // Slightly smaller font size for WhatsApp-like feel
            fontWeight: FontWeight.w400, // Lighter weight like WhatsApp
            color: Colors.white70,
          ),
        ),
        actions: [
          PopupMenuButton<int>(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 0) {
                setState(() {
                  selectedIndex = 1; // Redirect to Members
                });
              } else if (value == 1) {
                setState(() {
                  selectedIndex = 2; // Redirect to Profile
                });
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Text("Members"),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Text("Profile"),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: getTopNavigationBar(),
        ),
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    switch (selectedIndex) {
      case 0:
        return ChatlistScreen(); // Chats first
      case 1:
        return HomePage(); // Members second
      case 2:
        return ProfileScreen(); // Profile third
      default:
        return ChatlistScreen(); // Default to Chats
    }
  }

  Widget getTopNavigationBar() {
    return Container(
      color: colorFile.whatsAppGreen, // WhatsApp green background
      height: 48, // Fixed height for a compact feel
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceEvenly, // Even spacing for buttons
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedIndex = 0; // Chats
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Chats',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: selectedIndex == 0
                          ? Colors.white // Selected tab in white
                          : Colors.grey[300], // Unselected in grey
                    ),
                  ),
                  selectedIndex == 0
                      ? Container(
                          margin: EdgeInsets.only(top: 5),
                          height: 2,
                          width: 40,
                          color: Colors.white, // Underline on selected tab
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedIndex = 1; // Members
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Members',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color:
                          selectedIndex == 1 ? Colors.white : Colors.grey[300],
                    ),
                  ),
                  selectedIndex == 1
                      ? Container(
                          margin: EdgeInsets.only(top: 5),
                          height: 2,
                          width: 40,
                          color: Colors.white,
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedIndex = 2; // Profile
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color:
                          selectedIndex == 2 ? Colors.white : Colors.grey[300],
                    ),
                  ),
                  selectedIndex == 2
                      ? Container(
                          margin: EdgeInsets.only(top: 5),
                          height: 2,
                          width: 40,
                          color: Colors.white,
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
