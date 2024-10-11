import 'package:chat_app/network/response/changepasswordresponse.dart';
import 'package:chat_app/network/response/editmessageresponse.dart';
import 'package:http/http.dart';

import '../Utility/printmessage.dart';
import 'call/createmembercall.dart';
import 'response/checkmobilenumberexistresponse.dart';
import 'response/creatememberresponse.dart';
import 'response/deletesinglechatresponse.dart';
import 'response/getallmemberresponse.dart';
import 'response/getchatlist.dart';
import 'response/getchatresponse.dart';
import 'response/loginresponse.dart';
import 'response/logoutresponse.dart';
import 'response/operationresponse.dart';
import 'response/profileresponse.dart';
import 'response/sendmessageresponse.dart';
import 'response/updatememberresponse.dart';
import 'response/updatestatusresponse.dart';

class NetworkResponse {
  Future<List<Object?>?> postMethod(
      int requestCode, String url, String body) async {
    var response = await post(Uri.parse(url), body: body);
    var data = response.body;
    try {
      if (response.statusCode == 200) {
        String ResponseString = "[" + response.body + "]";
        switch (requestCode) {
          case 1: //Login
            final login = loginresponseFromJson(ResponseString);
            return login;
            break;
          case 2: //Create
            final createmember = creatememberresponseFromJson(ResponseString);
            return createmember;
            break;
          case 3: //Edit
            final updatememberresponse =
                updatememberresponseFromJson(ResponseString);
            return updatememberresponse;
          case 4: //Get All members
            final getmember = getallmemberresponseFromJson(ResponseString);
            return getmember;
          case 5: //Operation
            final operationresponse = operationresponseFromJson(ResponseString);
            return operationresponse;
          case 6: //Delete
            break;
          case 8: //Unique Mobile Number
            final checkmobilenumberexits =
                checkmobileexitsresponseFromJson(ResponseString);
            return checkmobilenumberexits;
          case 11:
            final getchatlist = getchatlistresponseFromJson(ResponseString);
            return getchatlist;
          case 12:
            final getchatresponse = getchatresponseFromJson(ResponseString);
            return getchatresponse;
            break;
          case 13:
            final deletesinglechat =
                deletesinglechatresponseFromJson(ResponseString);
            return deletesinglechat;
            break;
          case 14:
            final sendmessageresponse =
                sendmessageresponseFromJson(ResponseString);
            return sendmessageresponse;
            break;
          case 15:
            final updatestatusresponse =
                updatestatusresponseFromJson(ResponseString);
            return updatestatusresponse;
            break;
          case 16:
            final logoutres = logoutresponseFromJson(ResponseString);
            return logoutres;
            break;
          case 17:
            final profileres = profileresponseFromJson(ResponseString);
            return profileres;
            break;
          case 18:
            final changepass = changepasswordresponseFromJson(ResponseString);
            return changepass;
            break;
          case 19:
            final editmessage = editmessageresponseFromJson(ResponseString);
            return editmessage;
        }
      }
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'post Method', 'Network Response');
    }
  }

  Future<List<Object?>?> getMethod(int requestCode, String url) async {
    var response = await get(Uri.parse(url));
    var data = response.body;
    try {
      if (response.statusCode == 200) {
        String ResponseString = "[" + response.body + "]";
        switch (requestCode) {
          case 2:
            final createmember = createmembercallFromJson(ResponseString);
            return createmember;
            break;
          case 3:
            break;
        }
      }
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'post Method', 'Network Response');
    }
  }
}
