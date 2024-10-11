import 'package:shared_preferences/shared_preferences.dart';

import 'apputility.dart';
import 'printmessage.dart';

class SharedPreference {
  late SharedPreferences sharedPreferences;

  Future setValueToSharedPrefernce(String key, String Value) async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      return sharedPreferences.setString(key, Value);
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'setValueToSharedPrefernce', 'SharedPreference');
    }
  }

  Future setboolToSharedPrefernce(String key, bool Value) async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      return sharedPreferences.setBool(key, Value);
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'setValueToSharedPrefernce', 'SharedPreference');
    }
  }

  Future<String?> getValueFromSharedPrefernce(String key) async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      String? abc = sharedPreferences.getString(key);
      if (abc == null) {
        return "";
      } else {
        return abc;
      }
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'getValueFromSharedPrefernce', 'SharedPreference');
    }
    return "";
  }

  Future<bool?> getboolValueFromSharedPrefernce(String key) async {
    sharedPreferences = await SharedPreferences.getInstance();
    bool? abc = sharedPreferences.getBool(key);
    if (abc == null) {
      return false;
    } else {
      return abc;
    }
  }

  savevalueonlogin(
      String Name,
      String UserName,
      String Password,
      String Id,
      String LogedinMemberIsAdmin,
      String pushtoken,
      String isAdmin,
      String Status,
      bool isFirstTimeLogin) {
    SharedPreference().setValueToSharedPrefernce("Name", Name);
    SharedPreference().setValueToSharedPrefernce("UserName", UserName);
    SharedPreference().setValueToSharedPrefernce("Password", Password);
    SharedPreference().setValueToSharedPrefernce("Id", Id);
    SharedPreference().setValueToSharedPrefernce(
        "LogedInMemberIsAdmin", LogedinMemberIsAdmin);
    SharedPreference().setValueToSharedPrefernce("Push_Token", pushtoken);
    SharedPreference().setValueToSharedPrefernce("IsAdmin", isAdmin);

    SharedPreference().setValueToSharedPrefernce("Status", Status);
    SharedPreference()
        .setboolToSharedPrefernce('FirstTimeLogin', isFirstTimeLogin);
    SharedPreference().setValueToSharedPrefernce('push_token', pushtoken);
    AppUtility.NAME = Name;
    AppUtility.USERNAME = UserName;
    AppUtility.PASSWORD = Password;
    AppUtility.LOGEDINMEMBERISADMIN = LogedinMemberIsAdmin;
    AppUtility.ID = Id;
    AppUtility.Status = Status;
    AppUtility.PUSH_TOKEN = pushtoken;
  }

  getvalueonligin() async {
    AppUtility.NAME =
        (await SharedPreference().getValueFromSharedPrefernce("Name"))!;
    AppUtility.USERNAME =
        (await SharedPreference().getValueFromSharedPrefernce("UserName"))!;
    AppUtility.PASSWORD =
        (await SharedPreference().getValueFromSharedPrefernce("Password"))!;
    AppUtility.ID =
        (await SharedPreference().getValueFromSharedPrefernce("Id"))!;
    AppUtility.LOGEDINMEMBERISADMIN = (await SharedPreference()
        .getValueFromSharedPrefernce("LogedInMemberIsAdmin"))!;
    AppUtility.ISADMIN =
        (await SharedPreference().getValueFromSharedPrefernce("IsAdmin"))!;
    AppUtility.Status =
        (await SharedPreference().getValueFromSharedPrefernce("Status"))!;
    AppUtility.PASSWORD =
        (await SharedPreference().getValueFromSharedPrefernce('push_token'))!;
  }
}
