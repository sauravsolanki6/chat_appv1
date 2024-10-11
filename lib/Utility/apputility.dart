import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

import '../network/response/getallmemberresponse.dart';
import '../pages/login.dart';
import '../pages/splashscreen.dart';
import '../rootpage.dart';
import '../rootpageformember.dart';

class AppUtility {
  static String appName = "Chat App";
  static String NAME = "";
  static String USERNAME = "";
  static String PASSWORD = "";
  static String ID = "";
  static String LOGEDINMEMBERISADMIN = "1"; //Change this
  static String Status = "";
  static String PUSH_TOKEN = "";
  static String ISADMIN = "";
  static int APP_ID = 237720255;
  static String APP_SIGNIN =
      'd5be0770f243c4e5c98de40da6cf1de495d86a29fb81e4461e0b649db459d19f';
  static String callerId = "";
  static String CallerName = "";
  static bool alreadyIntialize = false;
  static int unreadmesssageCount = 0;
  static List<Datum> selectedlist = [];
  //===============================================================
  // static String base_api = "http://68.178.148.19/chat_apis/";
  static String base_api =
      "https://birtikendrajituniversity.ac.in/chat_app_code/";
  static String login_api = base_api + "web_login";
  static String create_api = base_api + "create_members";
  static String edit_api = base_api + "update_members";
  static String get_member_api = base_api + "get_all_member";
  static String hold_api = base_api + "set_hold_login";
  static String active_api = base_api + "set_activate_login";
  static String clear_api = base_api + "delete_all_chat";
  static String delete_api = base_api + "set_delete_login";
  static String get_latest_chat_list_api = base_api + "get_my_latest_chat_list";
  static String unique_mobile_api = base_api + "get_unique_mobile_number";
  static String get_single_member = base_api + "get_single_member";
  static String logout_api = base_api + "logout_member";
  static String getChat_api = base_api + "get_individual_chat";
  static String delete_single_message_api = base_api + "delete_single_chat";
  static String send_message_api = base_api + "send_message";
  static String update_status = base_api + "check_online";
  static String profile_api = base_api + "get_member_profile";
  static String change_password_api = base_api + "update_password";
  static String update_message_api = base_api + "update_message";
  static String PathFile = "";
  static XFile? imagepath;
  static int login = 1;
  static int create = 2;
  static int edit = 3;
  static int getmember = 4;
  static int operation = 5;
  static int clear = 6;
  static int delete = 7;
  static int unique_mobile = 8;
  static int active = 9;
  static int getsinglemember = 10;
  static int getlatestchat = 11;
  static int getchat = 12;
  static int delete_single_message = 13;
  static int send_message = 14;
  static int updatestatus = 15;
  static int logout = 16;
  static int profile = 17;
  static int changepassword = 18;
  static int updatemessage = 19;
}

class PageRouteNames {
  static const String splash = '/splashpage';
  static const String login = '/login';
  static const String root_page = '/root_page';
  static const String root_page_member = '/root_page_member';
}

Map<String, WidgetBuilder> routes = {
  PageRouteNames.login: (context) => Login(),
  PageRouteNames.root_page: (context) => RootPage(),
  PageRouteNames.root_page_member: (context) => RootPageMember(),
  PageRouteNames.splash: (context) => SplashScreen(),
};
