// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

// import '../pages/chatlistscreen.dart';
// import 'apputility.dart';
// import 'printmessage.dart';

// ZegoUIKitPrebuiltCallController? callController;
// bool state = true;
// bool release = false;
// void onUserLogin() {
//   AppUtility.alreadyIntialize = true;
//   callController ??= ZegoUIKitPrebuiltCallController();
//   ZegoUIKitPrebuiltCallInvitationService().init(
//     appID: AppUtility.APP_ID /*input your AppID*/,
//     appSign: AppUtility.APP_SIGNIN /*input your AppSign*/,
//     userID: AppUtility.ID,
//     userName: AppUtility.NAME,
//     notifyWhenAppRunningInBackgroundOrQuit: true,

//     // androidNotificationConfig: ZegoAndroidNotificationConfig(),
//     isIOSSandboxEnvironment: false,
//     androidNotificationConfig: ZegoAndroidNotificationConfig(
//         channelID: 'ZegoUIKitChatmitraBirti',
//         channelName: "call notification",
//         sound: 'res_custom_notification'),
// events: ZegoUIKitPrebuiltCallInvitationEvents(
//   onIncomingCallAcceptButtonPressed: () {},
//   onIncomingCallDeclineButtonPressed: () {},
//   onIncomingCallReceived:
//       (callID, caller, callType, callees, customData) {},
//   onOutgoingCallAccepted: (callID, callee) {},
//   onOutgoingCallDeclined: (callID, callee) {
//     try {
//       ChatlistScreenState().ShowSnackBarForCallEvents(
//           "Call declined from " + AppUtility.CallerName,
//           2,
//           AppUtility.callerId);
//     } catch (e) {
//       PrintMessage.printMessage(
//           e.toString(), 'onOutgoingCallDeclined', 'onUserLogin');
//     }
//   },
//   onIncomingCallTimeout: (callID, caller) {},
//   onOutgoingCallRejectedCauseBusy: (callID, callee) {},
//   onOutgoingCallTimeout: (callID, callees, isVideoCall) {
//     String message = "";
//     if (isVideoCall) {
//       message = "Missed video call ";
//     } else {
//       message = "Missed voice call ";
//     }
//   },
//   onIncomingCallCanceled: (callID, caller) {
//     print("call canceled" + caller.id);
//   },
//   onOutgoingCallCancelButtonPressed: () {
//     try {
//       ChatlistScreenState().ShowSnackBarForCallEvents(
//           "Missed call from " + AppUtility.NAME, 3, AppUtility.callerId);
//       state = false;
//     } catch (e) {
//       PrintMessage.printMessage(
//           e.toString(), 'onOutgoingCallCancelButtonPressed', 'onUserLogin');
//     }
//   },
// ),
//     plugins: [ZegoUIKitSignalingPlugin()],
//     controller: callController,
//     requireConfig: (ZegoCallInvitationData data) {
//       final config = (data.invitees.length > 1)
//           ? ZegoCallType.videoCall == data.type
//               ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
//               : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
//           : ZegoCallType.videoCall == data.type
//               ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
//               : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

//       config.topMenuBarConfig.isVisible = true;
//       config.topMenuBarConfig.buttons
//           .insert(0, ZegoMenuBarButtonName.hangUpButton);

//       return config;
//     },
//   );
// }

import 'package:chat_app/Utility/apputility.dart';
import 'package:chat_app/Utility/printmessage.dart';
import 'package:flutter/cupertino.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../pages/chatlistscreen.dart';

// Project imports:
// import 'common.dart';
// import 'constants.dart';

ZegoUIKitPrebuiltCallController? callController;
int appId = 237720255;
String yourAppSign =
    'd5be0770f243c4e5c98de40da6cf1de495d86a29fb81e4461e0b649db459d19f';

/// local virtual login
// Future<void> login({
//   required String userID,
//   required String userName,
// }) async {
//   final prefs = await SharedPreferences.getInstance();
//   prefs.setString(cacheUserIDKey, userID);

//   currentUser.id = userID;
//   currentUser.name = 'user_$userID';
// }

/// local virtual logout
// Future<void> logout() async {
//   final prefs = await SharedPreferences.getInstance();
//   prefs.remove(cacheUserIDKey);
// }

/// on user login
void onUserLogin() {
  callController ??= ZegoUIKitPrebuiltCallController();

  /// 4/5. initialized ZegoUIKitPrebuiltCallInvitationService when account is logged in or re-logged in
  ZegoUIKitPrebuiltCallInvitationService().init(
    appID: appId /*input your AppID*/,
    appSign: yourAppSign /*input your AppSign*/,
    userID: AppUtility.ID,
    userName: AppUtility.NAME,
    // notifyWhenAppRunningInBackgroundOrQuit: true,
    // androidNotificationConfig: ZegoAndroidNotificationConfig(
    //   channelID: "ZegoUIKit",
    //   channelName: "Call Notifications",
    //   sound: "res_custom_notification",
    //   // icon: "notification_icon",
    // ),
    // notificationConfig: ZegoIOSNotificationConfig(
    //   systemCallingIconName: 'CallKitIcon',
    // ),
    // events: ZegoUIKitPrebuiltCallInvitationEvents(
    //   onIncomingCallAcceptButtonPressed: () {},
    //   onIncomingCallDeclineButtonPressed: () {},
    //   onIncomingCallReceived:
    //       (callID, caller, callType, callees, customData) {},
    //   onOutgoingCallAccepted: (callID, callee) {},
    //   onOutgoingCallDeclined: (callID, callee) {
    //     try {
    //       ChatlistScreenState().ShowSnackBarForCallEvents(
    //           "Call declined from " + AppUtility.CallerName,
    //           2,
    //           AppUtility.callerId);
    //     } catch (e) {
    //       PrintMessage.printMessage(
    //           e.toString(), 'onOutgoingCallDeclined', 'onUserLogin');
    //     }
    //   },
    //   onIncomingCallTimeout: (callID, caller) {},
    //   onOutgoingCallRejectedCauseBusy: (callID, callee) {},
    //   onOutgoingCallTimeout: (callID, callees, isVideoCall) {
    //     String message = "";
    //     if (isVideoCall) {
    //       message = "Missed video call ";
    //     } else {
    //       message = "Missed voice call ";
    //     }
    //   },
    //   onIncomingCallCanceled: (callID, caller) {
    //     // print("call canceled" + caller.id);
    //   },
    //   onOutgoingCallCancelButtonPressed: () {
    //     try {
    //       ChatlistScreenState().ShowSnackBarForCallEvents(
    //           "Missed call from " + AppUtility.NAME, 3, AppUtility.callerId);
    //       // state = false;
    //     } catch (e) {
    //       PrintMessage.printMessage(
    //           e.toString(), 'onOutgoingCallCancelButtonPressed', 'onUserLogin');
    //     }
    //   },
    // ),
    plugins: [ZegoUIKitSignalingPlugin()],
    // controller: callController,
    requireConfig: (ZegoCallInvitationData data) {
      // log("data: ${data.invitees.join(",")}");
      // log("data123: ${data.toString()}");
      final config = (data.invitees.length == 1)
          ? (ZegoCallType.videoCall == data.type
          ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
          : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall())
          : (ZegoCallType.videoCall == data.type
          ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
          : ZegoUIKitPrebuiltCallConfig.groupVoiceCall());

      // config.avatarBuilder = customAvatarBuilder;

      /// support minimizing, show minimizing button
      config.topMenuBarConfig.isVisible = true;
      config.topMenuBarConfig.buttons
          .insert(0, ZegoMenuBarButtonName.minimizingButton);

      // config.onError = (ZegoUIKitError error) {
      //   debugPrint('onError:$error');
      // };

      return config;
    },
  );
}

/// on user logout
void onUserLogout() {
  callController = null;

  /// 5/5. de-initialization ZegoUIKitPrebuiltCallInvitationService when account is logged out
  ZegoUIKitPrebuiltCallInvitationService().uninit();
}
