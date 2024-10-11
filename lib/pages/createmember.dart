import 'package:flutter/material.dart';

import '../RootPage.dart';
import '../Utility/apputility.dart';
import '../Utility/printmessage.dart';
import '../customisedesign.dart/buttondesign.dart';
import '../customisedesign.dart/colorfile.dart';
import '../customisedesign.dart/dropdowndesign.dart';
import '../customisedesign.dart/progressdialog.dart';
import '../customisedesign.dart/snackbardesign.dart';
import '../customisedesign.dart/textdesign.dart';
import '../network/checkinternetconnection.dart';
import '../network/createjson.dart';
import '../network/networkresponse.dart';
import '../network/response/checkmobilenumberexistresponse.dart';
import '../network/response/creatememberresponse.dart';

final _nameController = TextEditingController();
final _mobilenumberController = TextEditingController();
final _passwordController = TextEditingController();
bool _showPassword = false;
late Future<bool> _ConnectionName;
String CreatedBy = "0", IsAdmin = "0";
List<String> typenameDropDown = ["Select Type", "Admin", "Member"];
List<String> typecodeDropDown = ["-1", "1", "0"];
String chosenValue1 = "", _typeName = "";
int _typeCode = -1;
String appBartitle = "Create Member", buttonText = "Create Member";
bool showdropdown = false;
late Future<bool> _connectionName;

class CreateMember extends StatefulWidget {
  String Operation, Id;
  CreateMember(this.Operation, this.Id);

  @override
  State createState() => CreateMemberState(this.Operation, this.Id);
}

class CreateMemberState extends State<CreateMember> {
  String operation, id;
  CreateMemberState(this.operation, this.id);

  @override
  void initState() {
    // TODO: implement initState
    try {
      super.initState();
      _connectionName = CheckInternetConnection().hasNetwork();
    } catch (e) {
      PrintMessage.printMessage(e.toString(), 'InitState', 'Create Member');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    try {
      super.dispose();
      _nameController.clear();
      _mobilenumberController.clear();
      _passwordController.clear();
      _typeCode = -1;
      _typeName = "";
      operation = "";
    } catch (e) {
      PrintMessage.printMessage(e.toString(), 'dispose', 'Create Member');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBartitle,
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        backgroundColor: ColorFile().buttonColor,
        foregroundColor: Colors
            .white, // Ensures icons and other text in the AppBar are also white
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
                            child: Image.asset('assets/images/chatbox.png')),
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
        _buildTextField(
          label: 'Name',
          controller: _nameController,
          keyboardType: TextInputType.text,
        ),
        _buildTextField(
          label: 'Phone Number',
          controller: _mobilenumberController,
          keyboardType: TextInputType.phone,
        ),
        _buildPasswordField(
          label: 'Password',
          controller: _passwordController,
        ),
        _buildDropdown(),
        SizedBox(height: 20),
        _buildCreateMemberButton(),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required TextInputType keyboardType,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle:
              TextDesign.TextStyleDesign.copyWith(color: Colors.black54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30), // More rounded corners
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          filled: true,
          fillColor: Colors.grey.shade100, // Softer background color
          contentPadding: EdgeInsets.symmetric(
              vertical: 15, horizontal: 20), // More padding
        ),
        keyboardType: keyboardType,
        controller: controller,
        style: TextDesign.TextStyleDesign,
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: !_showPassword,
        style: TextDesign.TextStyleDesign,
        decoration: InputDecoration(
          labelText: label,
          labelStyle:
              TextDesign.TextStyleDesign.copyWith(color: Colors.black54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30), // More rounded corners
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          filled: true,
          fillColor: Colors.grey.shade100, // Softer background color
          contentPadding: EdgeInsets.symmetric(
              vertical: 15, horizontal: 20), // More padding
          suffixIcon: GestureDetector(
            onTap: _togglevisibility,
            child: Icon(
              _showPassword ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey.shade500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30), // More rounded corners
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.grey.shade100, // Softer background color
      ),
      child: CustDropDown(
        items: const [
          CustDropdownMenuItem(
            value: 0,
            child: Text("Member", style: TextDesign.TextStyleDesign),
          ),
          CustDropdownMenuItem(
            value: 1,
            child: Text("Admin", style: TextDesign.TextStyleDesign),
          ),
        ],
        defaultSelectedIndex: _typeCode,
        hintText: "Select Type",
        onChanged: (val) {
          setState(() {
            _typeCode = val;
          });
        },
      ),
    );
  }

  Widget _buildCreateMemberButton() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        onPressed: () async {
          FocusScope.of(context).unfocus();
          String _Name = _nameController.text;
          String _MobileNumber = _mobilenumberController.text;
          String _Password = _passwordController.text;
          String? validation = _validateInputs(_Name, _MobileNumber, _Password);
          if (validation == null) {
            NetworkCallForUniqueMobileNumber(_MobileNumber);
          } else {
            SnackBarDesign(validation, context);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorFile().whatsAppGreen, // WhatsApp green color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // More rounded corners
          ),
          padding: EdgeInsets.symmetric(
              vertical: 15, horizontal: 40), // More padding
        ),
        child: Text(
          'Create Member',
          style: TextDesign.buttonTextStyleDesign.copyWith(color: Colors.white),
        ),
      ),
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
      PrintMessage.printMessage(
          e.toString(), 'validate Inputs', 'Create Member');
    }
  }

  void switchToMain(BuildContext context) {
    try {
      _nameController.clear();
      _mobilenumberController.clear();
      _passwordController.clear();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => RootPage()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      PrintMessage.printMessage(e.toString(), 'swichtomain', 'Create Member');
    }
  }

  NetworkCallForUniqueMobileNumber(String mobileno) async {
    ProgressDialog.showProgressDialog(context, 'Creating profile');
    String checkupdatemobile = CreateJson().CreatejsonForCheckMobile(mobileno);
    if (await _connectionName) {
      NetworkResponse networkResponse = NetworkResponse();
      List<Object?>? checkmobilenumber = await networkResponse.postMethod(
          AppUtility.unique_mobile,
          AppUtility.unique_mobile_api,
          checkupdatemobile);
      List<Object?>? checkmobile = await networkResponse.postMethod(
          AppUtility.unique_mobile,
          AppUtility.unique_mobile_api,
          checkupdatemobile);
      List<Checkmobileexitsresponse> checkexist = List.from(checkmobile!);
      String? exits = checkexist[0].exist;
      switch (exits) {
        case "1":
          Navigator.pop(context);
          SnackBarDesign('Mobile no. already exits', context);
          break;
        case "0":
          NetworkCallForCreateMember(
              _nameController.text,
              _mobilenumberController.text,
              _passwordController.text,
              _typeCode.toString());
          break;
      }
    } else {
      SnackBarDesign('Check internet connection', context);
    }
  }

  NetworkCallForCreateMember(
      String Name, String MobileNo, String Password, String memberType) async {
    String jsonForCreateMember = CreateJson().createjsonForCreatejson(
        MobileNo, Password, Name, AppUtility.ID, memberType);
    if (await _connectionName) {
      NetworkResponse networkResponse = NetworkResponse();
      List<Object?>? cretemember = await networkResponse.postMethod(
          AppUtility.create, AppUtility.create_api, jsonForCreateMember);
      try {
        List<Creatememberresponse> creatememberresponse =
            List.from(cretemember!);
        String? status = creatememberresponse[0].status;
        switch (status) {
          case "true":
            Navigator.pop(context);
            SnackBarDesign('Profile created successfully', context);
            switchToMain(context);
            break;
          case "false":
            Navigator.pop(context);
            SnackBarDesign('Something went wrong', context);
            break;
        }
      } catch (e) {
        Navigator.pop(context);
        PrintMessage.printMessage(
            e.toString(), 'NetworkCallForCreateMember', 'Create Member');
      }
    } else {
      SnackBarDesign('Check internet connection', context);
    }
  }
}
