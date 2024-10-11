import 'dart:convert';

import 'package:chat_app/network/call/changepasswordcall.dart';
import 'package:chat_app/network/call/editmessagecall.dart';

import '../Utility/printmessage.dart';
import 'call/checkmobilenumberexitcall.dart';
import 'call/createmembercall.dart';
import 'call/deletechat.dart';
import 'call/deletesinglechatcall.dart';
import 'call/getallmembers.dart';
import 'call/getchatcall.dart';
import 'call/logincall.dart';
import 'call/logoutcall.dart';
import 'call/operationcall.dart';
import 'call/profilecall.dart';
import 'call/sendmessagecall.dart';
import 'call/updatemembercall.dart';
import 'call/updatestatus.dart';

class CreateJson {
  String createjsonForLogin(
      String UserName, String Password, String pushToken) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Logincall logincalljson = Logincall(
          mobileNumber: UserName,
          password: Password,
          pushtoken: pushToken,
          timestamp: DateTime.now().millisecondsSinceEpoch.toString());
      var result = Logincall.fromJson(logincalljson.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'createjsonForLogin', 'Create Json');
      return "";
    }
  }

  String createjsonForCreatejson(
    String UserName,
    String Password,
    String Name,
    String createdby,
    String isAdmin,
  ) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Createmembercall createmembercalljson = Createmembercall(
        mobileNumber: UserName,
        password: Password,
        name: Name,
        createdBy: createdby,
        isAdmin: isAdmin,
      );
      var result = Createmembercall.fromJson(createmembercalljson.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'createjsonForCreateMember', 'Create Json');
      return "";
    }
  }

  String createjsonForEdit(String name, String mobile_number, String password,
      String typecode, String id) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Updatemembercall logincalljson = Updatemembercall(
          name: name,
          mobileNumber: mobile_number,
          password: password,
          isAdmin: typecode,
          memberId: id);
      var result = Updatemembercall.fromJson(logincalljson.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'createjsonForUpdate', 'Create Json');
      return "";
    }
  }

  String CreatejsonForCheckMobile(String mobile_number) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Checkmobilenumbercall checkmobilenumbercalljson =
          Checkmobilenumbercall(mobileNumber: mobile_number);
      var result =
          Checkmobilenumbercall.fromJson(checkmobilenumbercalljson.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'CreatejsonForUpdateMobile', 'Create Json');
      return "";
    }
  }

  String createjsonForHold(String member_id) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Operationcall operationcall = Operationcall(memberId: member_id);
      var result = Operationcall.fromJson(operationcall.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'createjsonForHold', 'Create Json');
      return "";
    }
  }

  String createjsonForDelete(String member_id, String id) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Deletechatcall operationcall =
          Deletechatcall(memberId: member_id, senderId: id);
      var result = Deletechatcall.fromJson(operationcall.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'createjsonForDeleteChat', 'Create Json');
      return "";
    }
  }

  String createjsonForGetAllMembers(String id) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Getallmemberscall operationcall = Getallmemberscall(id: id);
      var result = Getallmemberscall.fromJson(operationcall.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'createjsonForGetAllMembers', 'Create Json');
      return "";
    }
  }

  String createjsonForGetChat(String memberid, String senderid) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Getchatcall operationcall =
          Getchatcall(memberId: memberid, senderId: senderid);
      var result = Getchatcall.fromJson(operationcall.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'createjsonForGetChat', 'Create Json');
      return "";
    }
  }

  String createjsonForDeleteSingleChat(String id) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Deletesinglechatcall deletesinglechatcall = Deletesinglechatcall(id: id);
      var result = Deletesinglechatcall.fromJson(deletesinglechatcall.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'createjsonForGetChat', 'Create Json');
      return "";
    }
  }

  String createjsonForSendMessage(String senderid, String receiverid,
      String messagetext, String messagetype, String duration, filename) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Sendmessagecall sendmessagecall = Sendmessagecall(
          senderId: senderid,
          receiverId: receiverid,
          messageType: messagetype,
          messageText: messagetext,
          duration: duration,
          filename: filename,
          timestamp: DateTime.now().millisecondsSinceEpoch.toString());
      var result = Sendmessagecall.fromJson(sendmessagecall.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'createjsonForGetChat', 'Create Json');
      return "";
    }
  }

  String createjsonForUpdateReadStatus(String id) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Deletesinglechatcall deletesinglechatcall = Deletesinglechatcall(id: id);
      var result = Deletesinglechatcall.fromJson(deletesinglechatcall.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'createjsonForGetChat', 'Create Json');
      return "";
    }
  }

  String createjsonForUpdateStatus(String memberid, String timestamp) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Updatestatuscall updatestatuscall =
          Updatestatuscall(memberId: memberid, timestamp: timestamp);
      var result = Updatestatuscall.fromJson(updatestatuscall.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'createjsonForUpdateStatus', 'Create Json');
      return "";
    }
  }

  String createjsonforlogout(String memberid) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Logoutcall updatestatuscall = Logoutcall(memberId: memberid);
      var result = Logoutcall.fromJson(updatestatuscall.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'createjsonforlogout', 'Create Json');
      return "";
    }
  }

  String createjsonForProfile(String id) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Profilecall updatestatuscall = Profilecall(userId: id);
      var result = Profilecall.fromJson(updatestatuscall.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'createjsonForProfile', 'Create Json');
      return "";
    }
  }

  String createjsonForChangepassword(String id, String password) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Changepasswordcall updatestatuscall =
          Changepasswordcall(memberId: id, password: password);
      var result = Changepasswordcall.fromJson(updatestatuscall.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'createjsonForChangepassword', 'Create Json');
      return "";
    }
  }

  String createjsonForEditMessage(String id, String messagetext) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Editmessagecall deletesinglechatcall =
          Editmessagecall(id: id, messageText: messagetext);
      var result = Editmessagecall.fromJson(deletesinglechatcall.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'createjsonForEditMessage', 'Create Json');
      return "";
    }
  }
}
