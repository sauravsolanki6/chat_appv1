import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart' as dio;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../network/createjson.dart';
import '../network/networkresponse.dart';
import '../network/response/sendmessageresponse.dart';
import 'apputility.dart';
import 'printmessage.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
  //for accessing cloud firestore
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  //for accessing firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;
//For firebase messaging
  static FirebaseMessaging fmessaging = FirebaseMessaging.instance;

  static uploadfile(File file, String id, String type, String duration,
      String filename, Future<Uint8List> bytesforweb) async {
    // print("File base name" + filename);

    try {
      final bytes;
      if (kIsWeb) {
        bytes = List<int>.from(await bytesforweb);
      } else {
        bytes = await File(file.path).readAsBytes();
      }

      dio.FormData formData = dio.FormData.fromMap({
        'filename': await dio.MultipartFile.fromBytes(bytes, filename: filename)
      });
      final response1 = dio.Dio().post(
        'https://www.birtikendrajituniversity.ac.in/chat_app_code/file_send_in_dir',
        data: formData,
        onSendProgress: (count, total) {
          // print('count:$count,$total');
          if (count == total) {
            NetworkcallForSendMessage(id, type, '', duration, filename);
          }
        },
      );
      // print("file upload response" + response1.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<void> sendChatFile(String id, File file, String uid,
      String filename, String duration, Future<Uint8List> bytes) async {
    final ext = filename.split('.').last;
    print(ext);
    var type;
    if (ext == "pdf") {
      type = "pdf";
    } else if (ext == "xls" || ext == "xlsx") {
      type = "xls";
    } else if (ext == "docx") {
      type = "word";
    } else if (ext == "ppt") {
      type = "ppt";
    } else if (ext == 'jpg' ||
        ext == 'png' ||
        ext == 'gif87a' ||
        ext == 'gif89a' ||
        ext == 'jpeg' ||
        ext == 'tiff' ||
        ext == 'bmp') {
      type = "image";
    } else if (ext == "mp4" ||
        ext == "mov" ||
        ext == "wmv" ||
        ext == "avi" ||
        ext == "avchd" ||
        ext == "flv" ||
        ext == "f4v" ||
        ext == "swf" ||
        ext == "mkv" ||
        ext == "webm" ||
        ext == "html5") {
      type = "video";
    } else if (ext == "mp3" ||
        ext == "aac" ||
        ext.toUpperCase() == "FLAc" ||
        ext.toUpperCase() == "ALAC" ||
        ext.toUpperCase() == "WAV" ||
        ext.toUpperCase() == "AIFF" ||
        ext.toUpperCase() == "DSD") {
      type = "audio";
    }

    filename = DateTime.now().millisecondsSinceEpoch.toString() + filename;

    uploadfile(file, id, type, duration, filename, bytes);
  }

  static String getConversationId(String id, String uid) =>
      uid.hashCode <= id.hashCode ? '${uid}_$id' : '${id}_${uid}';

  static NetworkcallForSendMessage(String receiverid, String messagetpe,
      String message, String duration, String filename) async {
    String createjson = CreateJson().createjsonForSendMessage(
        AppUtility.ID, receiverid, filename, messagetpe, duration, message);
    NetworkResponse networkResponse = NetworkResponse();
    List<Object?>? list = await networkResponse.postMethod(
        AppUtility.send_message, AppUtility.send_message_api, createjson);
    List<Sendmessageresponse> sendmessageResponse = List.from(list!);
    String status = sendmessageResponse[0].status.toString();
    switch (status) {
      case "true":
        {
          Data data = sendmessageResponse[0].data!;
          SendPushNotification(
            message,
            AppUtility.ID,
            data.pushtoken,
            data.name!,
            data.isAdmin!,
            data.isOnline == 1 ? true : false,
            data.lastmessagetime,
            receiverid,
          );
        }
        break;
      case "false":
        break;
    }
  }

  static Future<void> SendPushNotification(
      String msg,
      String uid,
      String pushToken,
      String name,
      String isAdmin,
      bool isOnline,
      String lastmessagetime,
      String receiverid) async {
    try {
      final body = {
        "to": pushToken,
        'priority': 'high',
        "notification":{
          "title": AppUtility.NAME,
          "body": msg,
        },
        "data": {
          "title": AppUtility.NAME,
          "body": msg,
          "id": uid,
          "name": name,
          "isOnline": isOnline,
          "lastmessagetime": lastmessagetime,
          "receiverid": receiverid,
          "android_channel_id": "1",
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          "uuid": uid,
          "type": "text",
          'isAdmin': isAdmin,
        },
      };

      var res = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'key=AAAAUcpXMoI:APA91bEGeSlSFCepesJZo5DNefWC5ywwQleEBWkaKr84H475UP0zkje--M8sA7ITJ3MKVdRXds_bbFt8l3-HEjQlr8fYgNMDz6mSTVf6Gzw_7vwQUEfn_Xyl8MJNf5BgvGO4tYaYWZU6'
          },
          body: jsonEncode(body));

      // print('Response status: ${res.statusCode}');
      // print('Response body: ${res.body}');
    } catch (e) {
      // log('SendPushNotification Exception: $e');
      PrintMessage.printMessage(e.toString(), 'SendPushNotification', 'APIS');
    }
  }
}
