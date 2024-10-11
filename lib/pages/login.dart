import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../Utility/apputility.dart';
import '../Utility/printmessage.dart';
import '../Utility/sharedpreference.dart';
import '../customisedesign.dart/buttondesign.dart';
import '../customisedesign.dart/buttonvisibilitystate.dart';
import '../customisedesign.dart/progressdialog.dart';
import '../customisedesign.dart/snackbardesign.dart';
import '../customisedesign.dart/textdesign.dart';
import '../firebase_options.dart';
import '../network/checkinternetconnection.dart';
import '../network/createjson.dart';
import '../network/networkresponse.dart';
import '../network/response/loginresponse.dart';
import '../notification_service.dart';

final _userNameController = TextEditingController();
final _passwordController = TextEditingController();
bool _showPassword = false;
late Future<bool> _checkInternetConnection;

class Login extends StatefulWidget {
  State createState() => LoginState();
}

class LoginState extends State<Login> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkInternetConnection = CheckInternetConnection().hasNetwork();
  }

  @override
  Widget build(BuildContext context) {
    final buttonVisibilityState =
        Provider.of<ButtonVisibilityState>(context, listen: false);
    //final messageSelection = Provider.of<MessageSelectionModel>(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        resizeToAvoidBottomInset: false,
        body: SizedBox.expand(
            child: Container(
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 0, bottom: 0),
              child: Container(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Center(
                        child: Container(
                            width: 200,
                            height: 150,
                            // child: Icon(Icons.abc),
                            child: Image.asset('assets/images/chatbox.png')),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: Center(
                      child: Text(AppUtility.appName,
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xff6d24f3),
                          )),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 0, bottom: 0),
                      child: Form(child: FormUI()))
                ],
              )),
            )
          ]),
        )),
      ),
    );
  }

  void _togglevisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  Widget FormUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
            ),
            child: Padding(
              padding: EdgeInsets.all(5),
              child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle: TextDesign.TextStyleDesign,
                  ),
                  keyboardType: TextInputType.phone,
                  controller: _userNameController,
                  style: TextDesign.TextStyleDesign),
            )),
        SizedBox(
          height: 10,
        ),
        Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
            ),
            child: Padding(
              padding: EdgeInsets.all(5),
              child: TextFormField(
                controller: _passwordController,
                obscureText: !_showPassword,
                style: TextDesign.TextStyleDesign,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextDesign.TextStyleDesign,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      _togglevisibility();
                    },
                    child: Icon(
                      _showPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
              ),
            )),
        SizedBox(
          height: 20,
        ),
        ButtonDesign(
          onPressed: () {
            //  list = [];
            FocusScope.of(context).unfocus();
            String _UserName = _userNameController.text;
            String _Password = _passwordController.text;
            String? validation = _validateInputs(_UserName, _Password);
            if (validation == null) {
              //  list = [];
              logout(_UserName, _Password);
              requestPermissions(_UserName, _Password);
            } else {
              SnackBarDesign(validation, context);
            }
          },
          child: Text(
            'Log in',
            style: TextDesign.buttonTextStyleDesign,
          ),
        )
      ],
    );
  }

  String? _validateInputs(String UserName, String Password) {
    try {
      if (UserName.length != 10) {
        return 'Mobile Number must be of 10 digit';
      } else if (Password.isEmpty) {
        return 'Enter Password';
      }
      return null;
    } catch (e) {
      PrintMessage.printMessage(e.toString(), 'Validate Inputs', 'Login');
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
      return null;
    } catch (e) {
      PrintMessage.printMessage(e.toString(), '_getId', 'Login');
    }
  }

  logout(String _UserName, String _Password) {
    try {
      if (DefaultFirebaseOptions.currentPlatform == TargetPlatform.android) {
        ZegoUIKitPrebuiltCallInvitationService().uninit();
      }
      SharedPreference().setValueToSharedPrefernce("UserName", "");
      SharedPreference().setValueToSharedPrefernce("Password", "");
      SharedPreference().setValueToSharedPrefernce("Id", "");
      SharedPreference().setValueToSharedPrefernce("LogedInMemberIsAdmin", "");
      SharedPreference().setValueToSharedPrefernce("Push_Token", "");
    } catch (e) {
      PrintMessage.printMessage(e.toString(), 'Logout', 'Login');
    }
  }

  Future<void> requestPermissions(String UserName, String Password) async {
    try {
      NotificationServices notificationServices = NotificationServices();
      String pushToken = await notificationServices.getDevicetoken();
      HandlingSignIn(UserName, Password, pushToken);
    } catch (e) {
      PrintMessage.printMessage(e.toString(), 'requestPermission', 'Login');
    }
  }

  HandlingSignIn(
      String mobile_number, String password, String pushtoken) async {
    try {
      ProgressDialog.showProgressDialog(context, "Login...");
      String createjsonForlogin =
          CreateJson().createjsonForLogin(mobile_number, password, pushtoken);
      if (await _checkInternetConnection) {
        NetworkResponse networkResponse = NetworkResponse();
        List<Object?>? login = await networkResponse.postMethod(
            AppUtility.login, AppUtility.login_api, createjsonForlogin);
        try {
          List<Loginresponse> loginresponse = List.from(login!);
          String? status = loginresponse[0].status;
          switch (status) {
            case "true":
              Navigator.pop(context);
              Data? data1 = loginresponse[0].data;
              saveValuetoSharedpre(
                  data1!.name.toString(),
                  data1.mobileNumber.toString(),
                  data1.password.toString(),
                  data1.id.toString(),
                  data1.isAdmin.toString(),
                  pushtoken,
                  data1.isAdmin.toString(),
                  data1.status.toString(),
                  true);

              break;
            case "false":
              Navigator.pop(context);
              SnackBarDesign('Enter vaild username and password', context);
              break;
          }
        } catch (e) {
          Navigator.pop(context);
          PrintMessage.printMessage(e.toString(), 'Handle Sign In', 'Login');
        }
      }
    } catch (e) {
      PrintMessage.printMessage(e.toString(), 'Handle Sign in', 'Login In');
    }
  }

  saveValuetoSharedpre(
      String Name,
      String UserName,
      String Password,
      String Id,
      String LogedinMemberIsAdmin,
      String pushtoken,
      String isAdmin,
      String Status,
      bool isFirstTimeLogin) {
    try {
      SharedPreference().savevalueonlogin(Name, UserName, Password, Id,
          LogedinMemberIsAdmin, pushtoken, isAdmin, Status, isFirstTimeLogin);
      switchtoMain();
    } catch (e) {
      PrintMessage.printMessage(e.toString(), 'saveValuetoSharedpre', 'Login');
    }
  }

  switchtoMain() {
    try {
      _userNameController.clear();
      _passwordController.clear();

      if (AppUtility.LOGEDINMEMBERISADMIN == "1") {
        // navigatorKey.currentState!.pushNamedAndRemoveUntil(
        //   PageRouteNames.root_page,
        //   (route) => false,
        // );
        Navigator.pushNamedAndRemoveUntil(
            context, PageRouteNames.root_page, (route) => false);
      } else if (AppUtility.LOGEDINMEMBERISADMIN == "0") {
        // navigatorKey.currentState!.pushNamedAndRemoveUntil(
        //   PageRouteNames.root_page_member,
        //   (route) => false,
        // );
        Navigator.pushNamedAndRemoveUntil(
            context, PageRouteNames.root_page_member, (route) => false);
      }
    } catch (e) {
      PrintMessage.printMessage(e.toString(), 'switchToMain', 'Login');
    }
  }
}
