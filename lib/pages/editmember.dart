import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../RootPage.dart';
import '../Utility/apputility.dart';
import '../Utility/printmessage.dart';
import '../customisedesign.dart/buttondesign.dart';
import '../customisedesign.dart/colorfile.dart';
import '../customisedesign.dart/progressdialog.dart';
import '../customisedesign.dart/snackbardesign.dart';
import '../customisedesign.dart/textdesign.dart';
import '../network/checkinternetconnection.dart';
import '../network/createjson.dart';
import '../network/networkresponse.dart';
import '../network/response/getallmemberresponse.dart';
import '../network/response/updatememberresponse.dart';
import 'changepassword.dart';

final _nameController = TextEditingController();
final _mobilenumberController = TextEditingController();
final _passwordController = TextEditingController();
final _memberController = TextEditingController();
bool _showPassword = false;
List<String> typenameDropDown = ["Select Type", "Admin", "Member"];
List<String> typecodeDropDown = ["-1", "1", "0"];
String chosenValue1 = "", _typeName = "";
int _typeCode = 0;
String appBartitle = "Edit Member", buttonText = "EDIT MEMBER";
late Future<bool> _connectionName;

class EditMember extends StatefulWidget {
  String string;
  Datum chatmemberjson;
  EditMember(this.string, this.chatmemberjson);

  State createState() => EditMemberState();
}

class EditMemberState extends State<EditMember> {
  @override
  void initState() {
    // TODO: implement initState
    try {
      super.initState();
      getSingleProfile();
      _connectionName = CheckInternetConnection().hasNetwork();
    } catch (e) {
      PrintMessage.printMessage(e.toString(), 'initState', 'Edit Member');
    }
  }

  getSingleProfile() {
    try {
      setState(() {
        _nameController.text = widget.chatmemberjson.name.toString();
        _passwordController.text = widget.chatmemberjson.password.toString();
        _mobilenumberController.text =
            widget.chatmemberjson.mobileNumber.toString();
        if (widget.chatmemberjson.isAdmin == "1") {
          _typeCode = 1; //Admin
          _memberController.text = "Admin";
        } else {
          _typeCode = 0; //Member
          _memberController.text = "Member";
        }
      });
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'getSingleProfile', 'Edit Member');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Member"),
        backgroundColor: ColorFile().buttonColor,
      ),
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SizedBox.expand(
            child: Container(
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 0, bottom: 0),
              child: Container(
                  child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Center(
                        child: Container(
                            width: 200,
                            height: 150,
                            child: Image.asset("assets/images/chatbox.png")),
                      )),
                  Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 15, bottom: 0),
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
      children: <Widget>[
        Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextDesign.TextStyleDesign,
                  ),
                  keyboardType: TextInputType.text,
                  controller: _nameController,
                  style: TextDesign.TextStyleDesign),
            )),
        const SizedBox(
          height: 10,
        ),
        Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle: TextDesign.TextStyleDesign,
                  ),
                  keyboardType: TextInputType.phone,
                  controller: _mobilenumberController,
                  readOnly: true,
                  enabled: true,
                  style: TextDesign.TextStyleDesign),
            )),
        const SizedBox(
          height: 10,
        ),
        Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: TextFormField(
                enabled: true,
                readOnly: true,
                controller: _passwordController,
                obscureText: !_showPassword,
                style: TextDesign.TextStyleDesign,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextDesign.TextStyleDesign,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      //Payal uncomment this please comment this
                      // _togglevisibility();
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
        const SizedBox(
          height: 10,
        ),
        Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: TextFormField(
                  enabled: false,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Member type',
                    labelStyle: TextDesign.TextStyleDesign,
                  ),
                  keyboardType: TextInputType.phone,
                  controller: _memberController,
                  style: TextDesign.TextStyleDesign),
            )),
        const SizedBox(
          height: 20,
        ),
        Container(
            alignment: Alignment.centerRight,
            child: RichText(
                text: TextSpan(
                    text: "Reset Password ",
                    style:
                        const TextStyle(color: Color(0xff061A4D), fontSize: 12),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return ChangePassword(
                                title: "Change Password",
                                description:
                                    "Are you sure? You want reset password of " +
                                        widget.chatmemberjson.id!,
                                id: widget.chatmemberjson.id!,
                                own: false,
                                previouspassword: _passwordController.text);
                          },
                        )).then((value) {
                          //_passwordController.text = "";
                        });
                      }))),
        SizedBox(
          height: 10,
        ),
        ButtonDesign(
          onPressed: () async {
            FocusScope.of(context).unfocus();
            String _Name = _nameController.text;
            String _MobileNumber = _mobilenumberController.text;
            String _Password = _passwordController.text;
            String _Member = _memberController.text;
            String? validation =
                _validateInputs(_Name, _MobileNumber, _Password);
            if (validation == null) {
              widget.chatmemberjson.name = _Name;
              widget.chatmemberjson.mobileNumber = _MobileNumber;
              widget.chatmemberjson.password = _Password;
              if (_Member == "Admin") {
                widget.chatmemberjson.isAdmin = "1";
              } else {
                widget.chatmemberjson.isAdmin = "0";
              }
              widget.chatmemberjson.isAdmin = _typeCode.toString();
              try {
                NetworkCallForEditMember();
              } catch (e) {
                PrintMessage.printMessage(
                    e.toString(), 'Edit member network call ', 'Edit Member');
              }
            } else {
              SnackBarDesign(validation, context);
            }
          },
          child: const Text(
            'Edit Member',
            style: TextDesign.buttonTextStyleDesign,
          ),
        )
      ],
    );
  }

  String? _validateInputs(String Name, String UserName, String Password) {
    try {
      if (Name.isEmpty) {
        return 'Name should not be empty';
      } else if (UserName.length != 10) {
        return 'Mobile Number must be of 10 digit';
      } else if (Password.isEmpty) {
        return 'Enter Password';
      } else if (_typeCode == "" || _typeCode == "-1") {
        return 'Select Member Type';
      }
      return null;
    } catch (e) {
      PrintMessage.printMessage(e.toString(), 'Validate Inputs', 'Edit Member');
    }
  }

  NetworkCallForEditMember() async {
    ProgressDialog.showProgressDialog(context, "Update");
    String cretejsonforupdateProfile = CreateJson().createjsonForEdit(
        _nameController.text,
        _mobilenumberController.text,
        _passwordController.text,
        _typeCode.toString(),
        widget.chatmemberjson.id.toString());
    if (await _connectionName) {
      NetworkResponse networkResponse = NetworkResponse();
      List<Object?>? updateresponse = await networkResponse.postMethod(
          AppUtility.edit, AppUtility.edit_api, cretejsonforupdateProfile);
      try {
        List<Updatememberresponse> update = List.from(updateresponse!);
        String? status = update[0].status;
        switch (status) {
          case "true":
            Navigator.pop(context);
            SnackBarDesign('Profile edited successfully', context);
            break;
          case "false":
            Navigator.pop(context);
            SnackBarDesign('Unable to edit profile', context);
            break;
        }
      } catch (e) {
        PrintMessage.printMessage(
            e.toString(), 'Network Call For Update Profile', 'Edit Member');
      }
    }
  }

  void switchToMain(BuildContext context) {
    try {
      _nameController.clear();
      _mobilenumberController.clear();
      _passwordController.clear();
      _memberController.clear();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => RootPage()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      PrintMessage.printMessage(e.toString(), 'switchToMain', 'Edit Member');
    }
  }
}
