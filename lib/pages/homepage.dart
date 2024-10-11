import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../Utility/apputility.dart';
import '../Utility/printmessage.dart';
import '../Utility/sharedpreference.dart';
import '../card/home_card.dart';
import '../customisedesign.dart/colorfile.dart';
import '../customisedesign.dart/progressdialog.dart';
import '../network/checkinternetconnection.dart';
import '../network/createjson.dart';
import '../network/networkresponse.dart';
import '../network/response/getallmemberresponse.dart';
import 'createmember.dart';
import 'login.dart';

bool showFloatingActionButton = true;
bool showIcon = true;
Color colorforhold = Colors.black;
ZegoUIKitPrebuiltCallController? callController;
bool _isSearching = false;
late Future<bool> _connectionName;
List<Datum> memberlist = [];
List<Datum> _searchList = [];

class HomePage extends StatefulWidget {
  State createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    try {
      super.initState();
      showIcon = true;
      _connectionName = CheckInternetConnection().hasNetwork();
      NetworkCallForGetMemberList();
    } catch (e) {
      PrintMessage.printMessage(e.toString(), 'initState', 'Home Page');
    }
  }

  void getValueFromSharedPref(BuildContext context) async {
    try {
      SharedPreference().getvalueonligin();
      if (AppUtility.USERNAME.isEmpty ||
          AppUtility.PASSWORD.isEmpty ||
          AppUtility.ID.isEmpty) {
        logout();
      } else {
        if (AppUtility.LOGEDINMEMBERISADMIN == "1" ||
            AppUtility.LOGEDINMEMBERISADMIN == "2") {
          //remove this 2 condition
          setState(() {
            showFloatingActionButton = true;
          });
        } else {
          setState(() {
            showFloatingActionButton = false;
          });
        }
      }
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'getValueFromSharedPref', 'Home Page');
    }
  }

  NetworkCallForGetMemberList() async {
    try {
      ProgressDialog.showProgressDialog(context, "Loading...");
      String createjson =
          CreateJson().createjsonForGetAllMembers(AppUtility.ID);
      if (await _connectionName) {
        NetworkResponse networkResponse = NetworkResponse();
        List<Object?>? getallmemberresponse = await networkResponse.postMethod(
            AppUtility.getmember, AppUtility.get_member_api, createjson);
        try {
          List<Getallmemberresponse> getallmember =
              List.from(getallmemberresponse!);
          String? status = getallmember[0].status;
          //String status = data![0].status.toString();
          switch (status) {
            case "true":
              Navigator.pop(context);
              memberlist = getallmember[0].data!;
              setState(() {});
              break;
            case "false":
              Navigator.pop(context);
              break;
          }
        } catch (e) {
          Navigator.pop(context);
          PrintMessage.printMessage(
              e.toString(), 'NetworkCallForGetMemberList', 'Home Page');
        }
      }
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'Network Call For Get Member List', 'Home Page');
    }
  }

  logout() {
    try {
      //  APIs.updatelogedinStatus(false, AppUtility.ID, "");
      SharedPreference().setValueToSharedPrefernce("UserName", "");
      SharedPreference().setValueToSharedPrefernce("Password", "");
      SharedPreference().setValueToSharedPrefernce("Id", "");
      SharedPreference().setValueToSharedPrefernce("LogedInMemberIsAdmin", "");
      SharedPreference().setValueToSharedPrefernce("Push_Token", "");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      PrintMessage.printMessage(e.toString(), 'logout', 'Home Page');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () async {
          if (_isSearching) {
            setState(() {
              _isSearching = false; // Exit search mode
              _searchList?.clear(); // Clear search results
            });
            return false; // Prevent default back action
          }
          return true; // Allow default back action
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF008069), // WhatsApp green
            elevation: 0,
            title: _isSearching
                ? Container(
                    decoration: BoxDecoration(
                      color: ColorFile()
                          .buttonColor, // Background color for search bar
                      borderRadius:
                          BorderRadius.circular(20), // Rounded corners
                    ),
                    child: TextField(
                      autofocus: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none, // Remove any borders
                        enabledBorder:
                            InputBorder.none, // Remove the enabled border
                        focusedBorder:
                            InputBorder.none, // Remove the focused border
                        hintText: 'Search...',
                        hintStyle: TextStyle(color: Colors.white60),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20), // Padding for centering text
                      ),
                      style: TextStyle(
                          fontSize: 17, color: Colors.white), // Text style
                      onChanged: (val) {
                        _searchList?.clear(); // Clear previous results
                        for (var i in memberlist!) {
                          if (i.name!
                              .toLowerCase()
                              .contains(val.toLowerCase())) {
                            _searchList?.add(i);
                          }
                        }
                        setState(
                            () {}); // Update the UI with new search results
                      },
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        _isSearching = true; // Activate search mode
                      });
                    },
                    child: Text(
                      'Search...',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching; // Toggle search mode
                    if (!_isSearching) {
                      _searchList
                          ?.clear(); // Clear search results if exiting search
                    }
                  });
                },
                icon: Icon(
                  _isSearching ? Icons.close : Icons.search,
                  color: Colors.white, // Set the icon color to white
                ),
              ),
            ],
          ),

          body: memberlist.isNotEmpty
              ? Container(
                  color: Colors.white, // White background for the entire list
                  child: ListView.builder(
                    padding: EdgeInsets.zero, // No padding for the ListView
                    itemCount:
                        _isSearching ? _searchList?.length : memberlist.length,
                    itemBuilder: (context, index) {
                      var currentMember = _isSearching
                          ? _searchList![index]
                          : memberlist[index];
                      bool showIcon = false;
                      Color colorforhold = Colors.black; // Default color

                      // Determine icon visibility based on member status
                      if (AppUtility.LOGEDINMEMBERISADMIN == "1") {
                        showIcon = (currentMember.isAdmin == "1" ||
                            currentMember.isAdmin == "0");
                        colorforhold = currentMember.status == "0"
                            ? Colors.black
                            : ColorFile().textColor;
                      }

                      if (currentMember.id == AppUtility.ID) {
                        showIcon =
                            false; // Do not show icon for logged-in member
                      }

                      return Container(
                        color: Colors.white, // Fully white background
                        margin: EdgeInsets.symmetric(
                            vertical: 0), // No margin to ensure they touch
                        child: HomeCard(currentMember, showIcon,
                            colorforhold), // Your HomeCard widget
                      );
                    },
                  ),
                )
              : Center(
                  child: Text(
                      'No members found')), // Show a message when the list is empty
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Navigate to Add Member Page
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return CreateMember("C", "");
              }));
            },
            child: Icon(
              Icons.message,
              size: 26, // Slightly smaller icon for minimal design
            ),
            backgroundColor: Color(0xFF008069), // WhatsApp gradient green
            foregroundColor: Colors.white, // Icon color remains white
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30), // Pill-shaped FAB
            ),
            elevation: 12, // Slightly higher elevation for more shadow effect
            tooltip: 'Add Member', // Tooltip text for accessibility
            splashColor: Colors.white54, // Subtle splash effect when pressed
            hoverElevation: 14, // Higher elevation on hover for a smooth effect
            heroTag:
                'addMemberBtn', // Unique hero tag for animation transitions
          ),
        ),
      ),
    );
  }
}
