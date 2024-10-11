import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../Utility/apputility.dart';
import '../Utility/printmessage.dart';
import '../Utility/sharedpreference.dart';
import '../customisedesign.dart/colorfile.dart';
import '../firebase_options.dart';
import '../network/checkinternetconnection.dart';
import '../network/createjson.dart';
import '../network/networkresponse.dart';
import '../network/response/logoutresponse.dart';
import 'changepassword.dart';
import 'login.dart';

List<String> typenameDropDown = [];
List<String> typecodeDropDown = [];
String chosenValue1 = "", _typeCode = "", _typeName = "";
final _nameController = TextEditingController();
final _mobilenumberController = TextEditingController();
final _passwordController = TextEditingController();
bool _showPassword = false;
bool showdropdown = false;
late Future<bool> _checkInternetconnection;
String pass = "";

// Profile screen -- to show signed in user info
class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    _checkInternetconnection = CheckInternetConnection().hasNetwork();
    pass = AppUtility.PASSWORD;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton.extended(
            backgroundColor: ColorFile().buttonColor,
            onPressed: () async {
              NetworkCallForLogout();
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            label: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        body: SizedBox.expand(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                // Profile picture
                Container(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("assets/images/chatbox.png"),
                  ),
                ),
                // User name
                const Text(
                  'User Name', // Replace with dynamic user name
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Status Message', // Replace with dynamic status
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                // Form section
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      child: Column(
                        children: [
                          // Add more form fields or other UI elements here
                          FormUI(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
      children: <Widget>[
        _buildCustomContainer(
          label: 'Name',
          value: AppUtility.NAME,
        ),
        const SizedBox(height: 10),
        _buildCustomContainer(
          label: 'Mobile Number',
          value: AppUtility.USERNAME,
        ),
        const SizedBox(height: 10),
        _buildCustomContainer(
          label: 'Password',
          value: pass,
        ),
        const SizedBox(height: 10),
        _buildCustomContainer(
          label: 'Member Type',
          value: AppUtility.LOGEDINMEMBERISADMIN == '1' ? 'Admin' : 'Member',
        ),
        const SizedBox(height: 10),
        Container(
          alignment: Alignment.centerRight,
          child: RichText(
            text: TextSpan(
              text: "Reset Password ",
              style: const TextStyle(color: Color(0xff061A4D), fontSize: 12),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return ChangePassword(
                        title: "Change Password",
                        description:
                            "Are you sure? You want to reset the password of " +
                                AppUtility.ID,
                        id: AppUtility.ID,
                        own: true,
                        previouspassword: AppUtility.PASSWORD,
                      );
                    },
                  )).then((value) {
                    pass = AppUtility.PASSWORD;
                    setState(() {});
                  });
                },
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildCustomContainer({required String label, required String value}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100], // Light grey background for containers
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.black54, // Softer color for label
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                    height: 2), // Reduced space between label and value
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.black, // Dark color for value
                    fontSize: 16,
                    fontWeight: FontWeight.w600, // Semi-bold for emphasis
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  NetworkCallForLogout() async {
    try {
      String createJson = CreateJson().createjsonforlogout(AppUtility.ID);
      if (await _checkInternetconnection) {
        NetworkResponse networkResponse = NetworkResponse();
        List<Object?>? response = await networkResponse.postMethod(
            AppUtility.logout, AppUtility.logout_api, createJson);
        List<Logoutresponse> logout = List.from(response!);
        String status = logout[0].status!;
        switch (status) {
          case "true":
            logoutFromApp();
            break;
          case "false":
            break;
        }
      }
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), "NetworkCallForLogout", "Profile");
    }
  }

  logoutFromApp() {
    try {
      SharedPreference().setValueToSharedPrefernce("UserName", "");
      SharedPreference().setValueToSharedPrefernce("Password", "");
      SharedPreference().setValueToSharedPrefernce("Id", "");
      SharedPreference().setValueToSharedPrefernce("LogedInMemberIsAdmin", "");
      SharedPreference().setValueToSharedPrefernce("Push_Token", "");
      SharedPreference().setValueToSharedPrefernce("IsAdmin", "");

      SharedPreference().setValueToSharedPrefernce("Status", "");
      SharedPreference().setboolToSharedPrefernce('FirstTimeLogin', false);
      if (DefaultFirebaseOptions.currentPlatform == TargetPlatform.android) {
        ZegoUIKitPrebuiltCallInvitationService().uninit();
        clearAllData().deleteCacheDir();
        clearAllData()._deleteAppDir();

        setState(() {});
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return Login();
          },
        ));
      }
    } catch (e) {
      PrintMessage.printMessage(e.toString(), 'logout', 'Profile Screen');
    }
  }
}

class clearAllData {
  Future<void> deleteCacheDir() async {
    try {
      var f = await getApplicationSupportDirectory();
      if (f.existsSync()) {
        f.deleteSync(recursive: true);
      }
    } catch (e) {
      PrintMessage.printMessage(e.toString(), "ClearAllData", "Profile Screen");
    }
  }

  Future<void> _deleteAppDir() async {
    var appDocDir = await getApplicationDocumentsDirectory();
    if (appDocDir.existsSync()) {
      appDocDir.deleteSync(recursive: true);
    }
  }
}
