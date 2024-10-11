import 'dart:async';
import 'dart:io';

import 'package:chat_app/customisedesign.dart/notificationdialog.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Utility/apputility.dart';
import '../Utility/sharedpreference.dart';
import '../customisedesign.dart/snackbardesign.dart';
import '../notification_service.dart';

class SplashScreen extends StatefulWidget {
  State createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // if (DefaultFirebaseOptions.currentPlatform == TargetPlatform.android) {
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    notificationServices.setInteractMessage(context);
    notificationServices
        .getDevicetoken()
        .then((value) => print('Device Token ${value}'));
    // }
    Timer(const Duration(seconds: 2), () => movetonext());
    //Payal change this
    // Future.delayed(Duration.zero, () async {
    //   if (await Permission.systemAlertWindow.isGranted) {
    //     Timer(const Duration(seconds: 3), () => movetonext());
    //   } else {
    //     ShowAlterDialogForPermission();
    //   }
    // });
  }

  ShowAlterDialogForPermission() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return NotificationDialog(
          title: "Warning...",
          yesbuttonPressed: () async {
            Map<Permission, PermissionStatus> statuses = await [
              Permission.systemAlertWindow,
            ].request();
            if (await Permission.systemAlertWindow.isGranted) {
              Navigator.pop(context);
              Timer(const Duration(seconds: 2), () => movetonext());
            } else {
              SnackBarDesign(
                  'No permission for accessing this application', context);
            }
            //  requestPermissions();
          },
          nobuttonPressed: () {
            Navigator.pop(context);
            exit(0);
          },
          description:
              "To make and receive call in application, Application needs to know  whether you are on an active call so that your carrier call are not disturbed. Tap Continue > Allow.",
        );
      },
    );
  }

  void movetonext() async {
    //await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    if (AppUtility.USERNAME.isEmpty) {
      // navigatorKey.currentState!.pushNamedAndRemoveUntil(
      //   PageRouteNames.login,
      //   (route) => false,
      // );
      Navigator.pushNamedAndRemoveUntil(
          context, PageRouteNames.login, (route) => false);
    } else {
      AppUtility.PASSWORD =
          (await SharedPreference().getValueFromSharedPrefernce("Password"))!;
      AppUtility.ID =
          (await SharedPreference().getValueFromSharedPrefernce("Id"))!;
      AppUtility.NAME =
          (await SharedPreference().getValueFromSharedPrefernce("Name"))!;
      AppUtility.PUSH_TOKEN =
          (await SharedPreference().getValueFromSharedPrefernce("push_token"))!;
      if (AppUtility.LOGEDINMEMBERISADMIN == "1") {
        // navigatorKey.currentState!.pushNamedAndRemoveUntil(
        //   PageRouteNames.root_page,
        //   (route) => false,
        // );
        Navigator.pushNamedAndRemoveUntil(
            context, PageRouteNames.root_page, (route) => false);
      } else if (AppUtility.LOGEDINMEMBERISADMIN == "0") {
        Navigator.pushNamedAndRemoveUntil(
            context, PageRouteNames.root_page_member, (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        child: Image.asset(
          "assets/images/chatbox.png",
        ),
      ),
    );
  }
}
