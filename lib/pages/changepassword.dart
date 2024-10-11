import 'package:chat_app/Utility/apputility.dart';
import 'package:chat_app/Utility/printmessage.dart';
import 'package:chat_app/network/checkinternetconnection.dart';
import 'package:chat_app/network/response/changepasswordresponse.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Utility/sharedpreference.dart';
import '../customisedesign.dart/buttondesign.dart';
import '../customisedesign.dart/colorfile.dart';
import '../customisedesign.dart/snackbardesign.dart';
import '../network/createjson.dart';
import '../network/networkresponse.dart';

bool _showConfirmPassword = false, _showNewPassword = false;
final _currentPassword = TextEditingController();
final _newPassword = TextEditingController();
final _confirmPassword = TextEditingController();
late Future<bool> _ConnectionName;
bool validatecurrenpassword = true,
    validatenewpassword = true,
    validateconfirmpassword = true;
String errormessage = "";

class ChangePassword extends StatefulWidget {
  final String title;
  final String description;
  final double thickness; 
  final String id;
  final bool own;
  final String previouspassword;

  const ChangePassword({
    Key? key,
    required this.title,
    required this.description,
    this.thickness = 2,
    required this.id,
    required this.own,
    required this.previouspassword,
  }) : super(key: key);

  @override
  State createState() => ChangePasswordState();
}

class ChangePasswordState extends State<ChangePassword> {
  @override
  void initState() {
    super.initState();
    _currentPassword.text = widget.previouspassword;
    _ConnectionName = CheckInternetConnection().hasNetwork();
  }

  @override
  void dispose() {
    super.dispose();
    errormessage = "";
    validatenewpassword = true;
    validatecurrenpassword = true;
    validateconfirmpassword = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Reset Password",
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        backgroundColor: ColorFile().buttonColor,
        foregroundColor: Colors.white, // Set icon color to white if needed
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          // Allow scrolling for smaller screens
          child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                widget.own
                    ? _buildTextField('Current Password', _currentPassword,
                        true, validatecurrenpassword)
                    : Container(),
                SizedBox(height: 15),
                _buildTextField(
                  'New Password',
                  _newPassword,
                  _showNewPassword,
                  validatenewpassword,
                  suffixIcon: GestureDetector(
                    onTap: _togglevisibilityFornewPassword,
                    child: Icon(
                      _showNewPassword
                          ? CupertinoIcons.eye
                          : CupertinoIcons.eye_slash,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                _buildTextField(
                  'Confirm Password',
                  _confirmPassword,
                  _showConfirmPassword,
                  validateconfirmpassword,
                  suffixIcon: GestureDetector(
                    onTap: _togglevisibilityForConfirmPassword,
                    child: Icon(
                      _showConfirmPassword
                          ? CupertinoIcons.eye
                          : CupertinoIcons.eye_slash,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Center(
                  // Center the button
                  child: ButtonDesign(
                    onPressed: () {
                      String? validation = _validatePassword(
                        _currentPassword.text,
                        _newPassword.text,
                        _confirmPassword.text,
                      );
                      if (validation == null) {
                        NetworkCallForChangePassword(_confirmPassword.text);
                      } else if (validation == "abc") {
                        // Do nothing as it is handled in validation
                      } else {
                        SnackBarDesign(validation, context);
                      }
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      decoration: BoxDecoration(
                        color: ColorFile()
                            .buttonColor, // Ensure this matches your app's theme
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        'Done',
                        style: TextStyle(color: Colors.white, fontSize: 16),
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

  Widget _buildTextField(String label, TextEditingController controller,
      bool isObscured, bool isValid,
      {Widget? suffixIcon}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2)),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isObscured,
        style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey),
          errorText: isValid ? null : 'Please enter your $label',
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          border: InputBorder.none,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(CupertinoIcons.lock, color: ColorFile().buttonColor),
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  void _togglevisibilityForConfirmPassword() {
    setState(() {
      _showConfirmPassword = !_showConfirmPassword;
    });
  }

  void _togglevisibilityFornewPassword() {
    setState(() {
      _showNewPassword = !_showNewPassword;
    });
  }

  String? _validatePassword(
      String currentPassword, String newPassword, String confirmPassword) {
    if (currentPassword.isEmpty) {
      validatecurrenpassword = false;
      validatenewpassword = true;
      validateconfirmpassword = true;
      setState(() {});
      return 'abc';
    } else if (newPassword.isEmpty) {
      validatecurrenpassword = true;
      validatenewpassword = false;
      validateconfirmpassword = true;
      setState(() {});
      return 'abc';
    } else if (confirmPassword.isEmpty) {
      validatecurrenpassword = true;
      validatenewpassword = true;
      validateconfirmpassword = false;
      setState(() {});
      return 'abc';
    } else if (newPassword != confirmPassword) {
      validatecurrenpassword = true;
      validatenewpassword = false;
      validateconfirmpassword = false;
      setState(() {});
      return 'abc';
    } else {
      validatecurrenpassword = true;
      validatenewpassword = true;
      validateconfirmpassword = true;
      return null;
    }
  }

  Future<void> NetworkCallForChangePassword(String ConfirmPassword) async {
    String changepasswordjsonString =
        CreateJson().createjsonForChangepassword(widget.id, ConfirmPassword);
    if (await _ConnectionName) {
      NetworkResponse networkResponse = NetworkResponse();
      List<Object?>? login = await networkResponse.postMethod(
          AppUtility.changepassword,
          AppUtility.change_password_api,
          changepasswordjsonString);
      try {
        List<Changepasswordresponse> changepasswordResponse = List.from(login!);
        String status = changepasswordResponse[0].status.toString();
        switch (status) {
          case 'true':
            if (widget.own == true) {
              SharedPreference()
                  .setValueToSharedPrefernce("Password", ConfirmPassword);
              AppUtility.PASSWORD = ConfirmPassword;
            }
            setState(() {});
            SnackBarDesign('Success! password changed successfully', context);
            _currentPassword.clear();
            _newPassword.clear();
            _confirmPassword.clear();
            Navigator.pop(context);
            break;
          case 'false':
            SnackBarDesign('Unable to change password', context);
            break;
        }
      } catch (e) {
        PrintMessage.printMessage(
            e.toString(), 'NetworkCallForLogin', 'Login Screen');
      }
    } else {
      SnackBarDesign('Check Internet Connection', context);
    }
  }
}
