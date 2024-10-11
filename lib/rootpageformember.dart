import 'dart:io';

import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:hidable/hidable.dart';
import 'package:line_icons/line_icons.dart';

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
import 'pages/login.dart';
import 'pages/profilescreen.dart';

class RootPageMember extends StatefulWidget {
  const RootPageMember({Key? key}) : super(key: key);

  @override
  _RootPageMemberState createState() => _RootPageMemberState();
}

class _RootPageMemberState extends State<RootPageMember> {
  int selectedIndex = 0;
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    try {
      super.initState();
      // if (context == null) {
      //   context == navigatorKey.currentState;
      // }
      init();
      NetworkCallForProfile();
      // getValueFromSharedPref(context);
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'initState', 'Root Page For Member');
    }
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
              Showdialogforlogout("Already login somewhere, Logout from here");
            }
            if (status1 == "0") {
              Showdialogforlogout("You are on hold,contact to admin");
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

  static bool inited1 = false;
  Future<void> init() async {
    if (inited1) return;
    onUserLogin();
    inited1 = true;
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
          e.toString(), 'Showdialogforlogout', 'Root Page For Member');
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
      PrintMessage.printMessage(e.toString(), 'logout', 'Root Page For Member');
    }
  }

  static bool inited = false;
  void getValueFromSharedPref(BuildContext context) async {
    if (inited) {
      return;
    } else {
      try {
        inited = true;
        String? deviceid = await _getId();
        String msg;
        // if (AppUtility.Status == "0") {
        //   msg = "Contact to admin";
        // } else {
        //   msg = "Already login somewhere, Logout from here";
        // }
        // Showdialogforlogout(msg);
      } catch (e) {
        PrintMessage.printMessage(
            e.toString(), 'getValueFromSharedPref', 'Root Page For Member');
      }
      // inited = true;
    }
  }

  Future<String?> _getId() async {
    try {
      var deviceInfo = DeviceInfoPlugin();
      if (Platform.isIOS) {
        // import 'dart:io'
        var iosDeviceInfo = await deviceInfo.iosInfo;
        return iosDeviceInfo.identifierForVendor; // unique ID on iOS
      } else if (Platform.isAndroid) {
        var androidDeviceInfo = await deviceInfo.androidInfo;
        return androidDeviceInfo.id; // unique ID on Android
      } else if (Platform.isWindows || Platform.isMacOS) {
        return "";
      }
    } catch (e) {
      PrintMessage.printMessage(e.toString(), '_getId', 'Root Page For Member');
    }
  }

  @override
  Widget build(BuildContext context) {
    // SizeConfig().init(context);
    return Scaffold(
        backgroundColor: backgroundColor(context),
        body: getBody(),
        bottomNavigationBar: Hidable(
          child: bottomNavigationBar(),
          controller: scrollController,
        ));
  }

  Widget getBody() {
    switch (selectedIndex) {
      case 0:
        return ChatlistScreen();
      case 1:
        return ProfileScreen();
      default:
        return ChatlistScreen();
    }
  }

  Widget bottomNavigationBar() {
    return CustomNavigationBar(
      iconSize: 24.0,
      selectedColor: whiteColor,
      strokeColor: greenGradient.lightShade.withOpacity(0.4),
      unSelectedColor: Colors.white54,
      backgroundColor: backgroundColor(context),
      items: [
        // CustomNavigationBarItem(
        //   title: Text(
        //     'Calls',
        //     style: TextStyle(fontSize: 15, color: Colors.white70),
        //   ),
        //   icon: const Icon(
        //     LineIcons.phone,
        //     size: 24,
        //   ),
        // ),
        CustomNavigationBarItem(
          title: Text(
            'Chats',
            style: TextStyle(fontSize: 15, color: Colors.white70),
          ),
          icon: const Icon(
            LineIcons.sms,
            size: 24,
          ),
        ),
        CustomNavigationBarItem(
          title: const Text(
            'Profile',
            style: TextStyle(fontSize: 15, color: Colors.white70),
          ),
          icon: const Icon(
            LineIcons.user,
            size: 24,
          ),
        ),
      ],
      currentIndex: selectedIndex,
      onTap: (index) {
        setState(() {
          selectedIndex = index;
        });
      },
    );
  }
}
