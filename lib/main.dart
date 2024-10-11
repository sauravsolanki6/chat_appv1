import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import 'Utility/apputility.dart';
import 'Utility/printmessage.dart';
import 'Utility/sharedpreference.dart';
import 'customisedesign.dart/buttonvisibilitystate.dart';
import 'customisedesign.dart/messageselection.dart';
import 'notification_service.dart';

final navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    // final navigatorKey = GlobalKey<NavigatorState>();
    // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    await Firebase.initializeApp();

    // FirebaseMessaging.onBackgroundMessage(firebasebackgroundHandler);
    log("navigation key: ${navigatorKey.toString()}");
    ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

    ZegoUIKit().initLog().then((value) async {
      ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
        [ZegoUIKitSignalingPlugin()],
      );

      await getValueFromSharedPref(navigatorKey);
    });
  } catch (e) {
    PrintMessage.printMessage(e.toString(), 'main', 'Main');
  }

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    await firebaseBackgroundHandler(message);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
    // log("remote message date: ${remoteMessage.toMap().toString()}");
  });
}

// @pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  try {
    // Firebase.initializeApp();
    // log('Background message title ' + message.data['title'].toString());
    if (message.data['type'] == 'text') {
      NotificationServices notificationServices = NotificationServices();
      notificationServices.showNotification(message);
    }
  } catch (e) {
    PrintMessage.printMessage(
        e.toString(), 'firebasebackgroundHandler', 'Main');
  }
}

Future<void> getValueFromSharedPref(
    GlobalKey<NavigatorState> navigatorKey) async {
  try {
    AppUtility.USERNAME =
        (await SharedPreference().getValueFromSharedPrefernce("UserName"))!;
    AppUtility.LOGEDINMEMBERISADMIN = (await SharedPreference()
        .getValueFromSharedPrefernce("LogedInMemberIsAdmin"))!;

    runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => ButtonVisibilityState()),
      ChangeNotifierProvider(create: (_) => MessageSelectionModel()),
    ], child: MainApp(navigatorKey: navigatorKey)));
  } catch (e) {
    PrintMessage.printMessage(e.toString(), 'getValueFromSharedPref', 'Main');
  }
}

class MainApp extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const MainApp({
    required this.navigatorKey,
    Key? key,
  }) : super(key: key);
  State createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    log('widget.navigatorKey: ${widget.navigatorKey}');
    return MaterialApp(
      routes: routes,
      debugShowCheckedModeBanner: false,
      initialRoute: PageRouteNames.splash,
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFEFEFEF)),

      /// 3/5: register the navigator key to MaterialApp
      navigatorKey: widget.navigatorKey,
      builder: (BuildContext context, Widget? child) {
        return Stack(
          children: [
            child!,

            /// support minimizing
            ZegoUIKitPrebuiltCallMiniOverlayPage(
              contextQuery: () {
                return widget.navigatorKey.currentState!.context;
              },
            ),
          ],
        );
      },
    );
  }
}
