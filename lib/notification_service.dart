import 'dart:io';
import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'Utility/apis.dart';
import 'Utility/printmessage.dart';
import 'pages/chatscreen.dart';

class NotificationServices {
  String? callId;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  AwesomeNotifications awesomeNotifications = AwesomeNotifications();
  static final onNotifications = BehaviorSubject<String?>();

  // Request notification permission (Android/iOS)
  void requestNotificationPermission() async {
    try {
      NotificationSettings settings = await firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // User granted permission
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        // Provisional permission granted
      } else {
        // User declined permission
      }
    } catch (e) {
      PrintMessage.printMessage(e.toString(), 'requestNotificationPermission',
          'Notification Service');
    }
  }

  // Initialize local notifications for Android/iOS
  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    try {
      var androidInitialization =
          const AndroidInitializationSettings('@mipmap/ic_launcher');
      var iosInitialization = const DarwinInitializationSettings();
      var initializationSettings = InitializationSettings(
        android: androidInitialization,
        iOS: iosInitialization,
      );

      awesomeNotifications.initialize(
        null,
        [
          NotificationChannel(
            channelKey: 'text',
            channelName: 'Text Notifications',
            channelDescription: 'Your channel description',
            importance: NotificationImportance.High,
            playSound: true,
          ),
        ],
      );
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'initLocalNotifications', 'Notification Service');
    }
  }

  // Firebase Initialization for handling messages
  void firebaseInit(BuildContext context) {
    try {
      FirebaseMessaging.onMessage.listen((message) {
        if (Platform.isAndroid) {
          initLocalNotifications(context, message);
          if (message.data['type'] == 'text') {
            showNotification(message);
          } else if (message.data['type'] == 'call') {
            showCallNotification(message);
          }
        } else {
          if (message.data['type'] == 'text') {
            showNotification(message);
          } else if (message.data['type'] == 'call') {
            showCallNotification(message);
          }
        }
      });
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'firebaseInit', 'Notification Service');
    }
  }

  // Show notification for text messages
  Future<void> showNotification(RemoteMessage message) async {
    try {
      AndroidNotificationChannel channel = AndroidNotificationChannel(
          Random.secure().nextInt(100000).toString(), 'text_channel',
          importance: Importance.max);

      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        channel.id.toString(),
        channel.name.toString(),
        channelDescription: 'Your channel description',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('res_custom_message'),
      );

      DarwinNotificationDetails darwinNotificationDetails =
          const DarwinNotificationDetails(
              presentAlert: true, presentBadge: true, presentSound: true);

      NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails,
      );

      await awesomeNotifications.createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: 'text',
          title: message.data['title'].toString(),
          body: message.data['body'].toString(),
        ),
      );
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'showNotification', 'Notification Service');
    }
  }

  // Show call notification
  Future<void> showCallNotification(RemoteMessage message) async {
    try {
      AndroidNotificationChannel channel = AndroidNotificationChannel(
          Random.secure().nextInt(100000).toString(), 'call_channel',
          importance: Importance.max);

      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        channel.id.toString(),
        channel.name.toString(),
        channelDescription: 'Your channel description',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('res_custom_notification'),
      );

      DarwinNotificationDetails darwinNotificationDetails =
          const DarwinNotificationDetails(
              presentAlert: true, presentBadge: true, presentSound: true);

      NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails,
      );

      await awesomeNotifications.createNotification(
        content: NotificationContent(
          id: 2,
          channelKey: 'call',
          title: message.data['title'].toString(),
          body: message.data['body'].toString(),
        ),
      );
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'showCallNotification', 'Notification Service');
    }
  }

  // Get device token for Firebase Messaging
  Future<String> getDevicetoken() async {
    String? token = await firebaseMessaging.getToken();
    return token!;
  }

  // Handle token refresh
  void isTokenRefresh() {
    try {
      firebaseMessaging.onTokenRefresh.listen((event) {
        event.toString();
      });
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'isTokenRefresh', 'Notification Service');
    }
  }

  // Interact with messages when app is terminated or in background
  Future<void> setInteractMessage(BuildContext context) async {
    try {
      RemoteMessage? initialmessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (initialmessage != null) {
        handleRemoteMessage(context, initialmessage);
      }
      FirebaseMessaging.onMessageOpenedApp.listen((event) {
        handleRemoteMessage(context, event);
      });
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'setInteractMessage', 'Notification Service');
    }
  }

  // Handle remote message when received
  void handleRemoteMessage(BuildContext context, RemoteMessage message) {
    try {
      if (message.data['type'] == 'text') {
        String id = message.data['id'];
        String name = message.data['name'];
        bool isOnline = message.data['isOnline'] == "true" ? true : false;
        String lastmessagetime = message.data['lastmessagetime'];
        String receiverid = message.data['receiverid'];
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(
                    id, name, isOnline, lastmessagetime, receiverid)));
      } else if (message.data['type'] == 'call') {
        // Handle call notification navigation logic
      }
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'handleRemoteMessage', 'Notification Service');
    }
  }
}
