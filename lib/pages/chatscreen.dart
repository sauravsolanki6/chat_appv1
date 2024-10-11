import 'dart:async';
import 'dart:io' as io;
import 'dart:math' as math;
import 'dart:developer';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
// import 'package:record_mp3/record_mp3.dart';
import 'package:vibration/vibration.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../Utility/apis.dart';
import '../Utility/apputility.dart';
import '../Utility/mydateutil.dart';
import '../Utility/printmessage.dart';
import '../card/message_card.dart';
import '../customisedesign.dart/audiocontroller.dart';
import '../customisedesign.dart/buttonvisibilitystate.dart';
import '../customisedesign.dart/colorfile.dart';
import '../customisedesign.dart/messageselection.dart';
import '../customisedesign.dart/snackbardesign.dart';
import '../network/checkinternetconnection.dart';
import '../network/createjson.dart';
import '../network/networkresponse.dart';
import '../network/response/deletesinglechatresponse.dart';
import '../network/response/editmessageresponse.dart';
import '../network/response/getchatresponse.dart';
import '../network/response/sendmessageresponse.dart';
import 'camerabuttonpage.dart';
import 'forwardlistscreen.dart';
// import 'camerabuttonpage.dart';

late Future<bool> _checkinternetconnection;
List<Messagejson> list = [];
List<Messagejson> selectedlist = [];
//MessageSelectionModel messageSelection = MessageSelectionModel();

class ChatScreen extends StatefulWidget {
  // Datum datum;
  String id, name, receiverId;
  String? lastmessagetime;
  bool isOnline;
  ChatScreen(
      this.id, this.name, this.isOnline, this.lastmessagetime, this.receiverId);

  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  List selectedIndex = [];
  final _textController = TextEditingController();
  bool _showEmoji = false, _isUploading = false;
  final recorder = FlutterSoundRecorder();
  bool isRecorderReady = false;
  bool visibleButton = false;
  String _recordingPath = "";
  String FName = "";
  String audioFileDuration = "0";
  late String recordFilePath;
  int? selectedMessageIndex;
  Timer? _timer;
  @override
  void initState() {
    // TODO: implement initState
    try {
      super.initState();

      visibleButton = false;

      _checkinternetconnection = CheckInternetConnection().hasNetwork();
      list = [];
      requestPermissions();
      NetworkcallForGetChat();

      _timer = Timer.periodic(Duration(seconds: 3), (timer) {
        NetworkcallForGetChat();
      });
    } catch (e) {
      PrintMessage.printMessage(e.toString(), 'Init State', 'Chat Screen');
    }
  }

  NetworkcallForGetChat() async {
    String createjson = CreateJson()
        .createjsonForGetChat(AppUtility.ID, widget.receiverId.toString());
    if (await _checkinternetconnection) {
      NetworkResponse networkResponse = NetworkResponse();
      List<Object?>? chat = await networkResponse.postMethod(
          AppUtility.getchat, AppUtility.getChat_api, createjson);
      if (chat != null) {
        List<Getchatresponse> chatresponse = List.from(chat);
        String status = chatresponse[0].status!;
        widget.isOnline = chatresponse[0].isOnline == "1" ? true : false;
        switch (status) {
          case "true":
            list = chatresponse[0].data!;
            AppUtility.PathFile = chatresponse[0].filepath!;
            // setState(() {}); //Payal comment this added below code
            if (!mounted) {
              _timer?.cancel();
            } else {
              setState(() {});
            }

            break;
          case "false":
            break;
        }
      }
    } else {
      SnackBarDesign('Check internet connection', context);
    }
  }

  Future<void> requestPermissions() async {
    try {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
        Permission.microphone,
        Permission.storage,
      ].request();
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'Request Permission', 'Chat Screen');
    }
  }

  AudioController audioController = Get.put(AudioController());
  String audioURL = "";
  Future<bool> checkPermission() async {
    try {
      if (!await Permission.microphone.isGranted) {
        PermissionStatus status = await Permission.microphone.request();
        if (status != PermissionStatus.granted) {
          return false;
        }
      }
    } catch (e) {
      PrintMessage.printMessage(e.toString(), 'checkPermission', 'Chat Screen');
      return false;
    }
    return true;
  }

  // void startRecord() async {
  //   try {
  //     bool hasPermission = await checkPermission();
  //     if (hasPermission) {
  //       isRecorderReady = true;
  //       recordFilePath = await getFilePath();
  //       RecordMp3.instance.start(recordFilePath, (type) {
  //         setState(() {});
  //       });
  //     } else {}
  //     setState(() {});
  //   } catch (e) {
  //     PrintMessage.printMessage(e.toString(), 'start Record', 'Chat Screen');
  //   }
  // }

  // void stopRecord() async {
  //   try {
  //     bool stop = RecordMp3.instance.stop();

  //     audioController.end.value = DateTime.now();
  //     audioController.calcDuration();
  //     var ap = AudioPlayer();
  //     ap.setAsset("assets/audio/payal.mp3");
  //     await ap.play();
  //     if (stop) {
  //       setState(() {
  //         audioController.isRecording.value = false;
  //         audioController.isSending.value = true;
  //         isRecorderReady = false;
  //       });
  //       APIs.sendChatFile(
  //           widget.receiverId,
  //           io.File(recordFilePath),
  //           AppUtility.ID,
  //           DateTime.now().millisecondsSinceEpoch.toString() + '.mp3',
  //           audioController.getTotal,
  //           io.File(recordFilePath).readAsBytes());
  //     }
  //   } catch (e) {
  //     PrintMessage.printMessage(e.toString(), 'stop Record', 'Chat Screen');
  //   }
  // }

  Future<String> getFilePath() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    String FolderPath = "";
    String sdPath = "";

    FolderPath = (await getApplicationDocumentsDirectory()).path;

    sdPath = FolderPath;
    var d = io.Directory(sdPath);
    if (!d.existsSync()) {
      _recordingPath = sdPath;
      d.createSync(recursive: true);
    }
    return "$sdPath/$fileName.mp3";
  }

  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        {
          if (audioController.getIsRecordPlaying) {
            await audioController.pauseRecord();
          }
        }
        break;
      case AppLifecycleState.paused:
        if (audioController.getIsRecordPlaying) {
          await audioController.pauseRecord();
        }
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void dispose() {
    try {
      Get.delete<AudioController>();
      selectedlist.clear();
      recorder.closeRecorder();
      _timer?.cancel();

      super.dispose();
    } catch (e) {
      PrintMessage.printMessage(e.toString(), 'dispose', 'Chat Screen');
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonVisibilityState =
        Provider.of<ButtonVisibilityState>(context, listen: false);

    final messageSelection =
        Provider.of<MessageSelectionModel>(context, listen: true);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        color: ColorFile().whatsAppGreen,
        child: SafeArea(
          child: WillPopScope(
            onWillPop: () {
              messageSelection
                  .clearSelection(); //Payal change this on 22/8/2023
              if (_showEmoji) {
                setState(() {
                  _showEmoji = !_showEmoji;
                });
                return Future.value(false);
              } else {
                return Future.value(true);
              }
            },
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                iconTheme: const IconThemeData(
                    color: Colors.white), // Change icon color to white
                flexibleSpace: _appBar(messageSelection),
                backgroundColor: ColorFile().buttonColor,
              ),
              body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:
                        AssetImage('assets/images/chat.png'), // Your image path
                    fit: BoxFit.cover, // Cover the entire container
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          reverse: true,
                          cacheExtent: 9999,
                          itemCount: list.length,
                          padding: const EdgeInsets.only(top: 0.1),
                          itemBuilder: (context, intex) {
                            final isSelected =
                                messageSelection.isSelected(intex);
                            return MessageCard(
                              messagejson: list[intex],
                              index: intex + 1,
                              selectedlist: selectedlist,
                              onSelectionChanged: (bool isSelected) {
                                if (selectedMessageIndex == null) {
                                  selectedMessageIndex = intex;
                                  messageSelection.setFirstSelection(intex);
                                } else {
                                  messageSelection.toggleSelection(intex);
                                }
                                selectedlist = messageSelection
                                    .getSelectedIndexes()
                                    .map((index) => list[index])
                                    .toList();
                              },
                              isSelected: isSelected,
                            );
                          }),
                    ),
                    if (_isUploading)
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    _charInput(buttonVisibilityState),
                    if (_showEmoji)
                      SizedBox(
                        height: 300,
                        child: EmojiPicker(
                          onEmojiSelected: (category, emoji) {
                            buttonVisibilityState.updateTextVisibility(true);
                          },
                          textEditingController: _textController,
                          config: Config(columns: 8, emojiSizeMax: 32 * 1.0),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar(MessageSelectionModel messageSelection) {
    String name = widget.name.toString();
    return Container(
      color: const Color(0xFF075E54), // WhatsApp-like background color
      padding: const EdgeInsets.symmetric(horizontal: 10), // Horizontal padding
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          ClipRRect(
            borderRadius:
                BorderRadius.circular(20), // More rounded for a friendlier look
            child: const Icon(
              CupertinoIcons.person_alt_circle_fill,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(width: 8), // Increased space for better aesthetics
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedlist.length < 1
                      ? name.length > 10
                          ? name.substring(0, 10) + '...'
                          : name
                      : "${selectedlist.length} selected",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold, // Bold for emphasis
                      color: Colors.white),
                ),
                const SizedBox(height: 2),
                Text(
                  list.isNotEmpty
                      ? widget.isOnline
                          ? 'Online'
                          : MyDateUtil.getLastActiveTime(
                              context: context,
                              lastActive: widget.lastmessagetime.toString())
                      : MyDateUtil.getLastActiveTime(
                          context: context,
                          lastActive: widget.lastmessagetime.toString()),
                  style: const TextStyle(
                      fontSize: 14,
                      color: Colors
                          .white), // Slightly larger for better readability
                ),
              ],
            ),
          ),
          // Action buttons
          selectedlist.isEmpty
              ? sendCallButton(
                  isVideoCall: false,
                  id: widget.receiverId,
                  name: widget.name.toString(),
                  onCallFinished: onSendCallInvitationFinished)
              : AppUtility.LOGEDINMEMBERISADMIN == "1"
                  ? IconButton(
                      onPressed: () async {
                        for (int i = 0; i < selectedlist.length; i++) {
                          selectedlist[i].isDeleted = "1";
                          NetworkCallForDeleteMessage(
                              selectedlist[i].id!, i, messageSelection);
                        }
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 26,
                      ),
                    )
                  : Container(),
          // IconButton(
          //   onPressed: () {
          //     print(
          //         'Duration: ${TimeOfDay.fromDateTime(DateTime.fromMillisecondsSinceEpoch(int.parse(selectedlist[0].timestamp!)))}');
          //     _editSelectedMessages();
          //   },
          //   icon: const Icon(
          //     Icons.edit,
          //     color: Colors.white,
          //     size: 26,
          //   ),
          // ),
          selectedlist.isEmpty
              ? sendCallButton(
                  isVideoCall: true,
                  id: widget.receiverId,
                  name: widget.name.toString(),
                  onCallFinished: onSendCallInvitationFinished)
              : AppUtility.LOGEDINMEMBERISADMIN == "1"
                  ? IconButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return ForwardlistScreen(
                              selectedlist, messageSelection);
                        }));
                      },
                      icon: const Icon(
                        Icons.forward,
                        color: Colors.white,
                        size: 26,
                      ),
                    )
                  : Container(),
        ],
      ),
    );
  }

  bool editmessagesendagain = false;
  String editmessagetext = "", editmessageid = "";
  void _editSelectedMessages() {
    if (selectedlist.isNotEmpty) {
      editmessagesendagain = true;
      editmessagetext = selectedlist.map((msg) => msg.messageText).join('\n');
      editmessageid = selectedlist.map((e) => e.id!).join('\n');
      Clipboard.setData(ClipboardData(text: editmessagetext));
      _textController.text = editmessagetext;
      setState(() {});
      // showTopSnackBar(context, "Messages copied to clipboard");
    }
  }

  NetworkCallForDeleteMessage(
      String isDeleted, int i, MessageSelectionModel messageSelection) async {
    String createjson = CreateJson().createjsonForDeleteSingleChat(isDeleted);
    if (await _checkinternetconnection) {
      NetworkResponse response = NetworkResponse();
      List<Object?>? deletechat = await response.postMethod(
          AppUtility.delete_single_message,
          AppUtility.delete_single_message_api,
          createjson);
      List<Deletesinglechatresponse> list = List.from(deletechat!);
      String status = list[0].status!;
      switch (status) {
        case "true":
          SnackBarDesign("Message has been delete successfully", context);
          if (i == selectedlist.length - 1) {
            setState(() {
              selectedlist.clear();
              selectedIndex.clear();
              messageSelection.clearSelection();
            });
          }
          break;
        case "false":
          break;
      }
    } else {
      SnackBarDesign('Check Internet Connection', context);
    }
  }

  Future<void> NetworkCallForEditMessage(
      String messageId, String messagetext) async {
    editmessagesendagain = false;
    setState(() {});
    String createjson =
        CreateJson().createjsonForEditMessage(messageId, _textController.text);
    if (await _checkinternetconnection) {
      NetworkResponse response = NetworkResponse();
      List<Object?>? deletechat = await response.postMethod(
        AppUtility.updatemessage,
        AppUtility.update_message_api,
        createjson,
      );
      List<Editmessageresponse> list = List.from(deletechat!);
      String status = list[0].status!;
      switch (status) {
        case "true":
          selectedlist.clear();

          _textController.clear();

          setState(() {});
          NetworkcallForGetChat();
          break;
        case "false":
          selectedlist.clear();
          _textController.clear();
          setState(() {});

          NetworkcallForGetChat();
          break;
      }
    } else {
      print('Internet connection');
    }
  }

  Widget sendCallButton({
    required bool isVideoCall,
    required String id,
    required String name,
    void Function(String code, String message, List<String>)? onCallFinished,
  }) {
    try {
      final invitees = getInvitesFromTextCtrl(id, name);
      AppUtility.callerId = id;
      AppUtility.CallerName = name;
      return ZegoSendCallInvitationButton(
        isVideoCall: isVideoCall,
        invitees: invitees,
        callID: generateRandomString1(10),
        resourceID: 'chatmitra',
        timeoutSeconds: 30,
        iconSize: const Size(40, 40),
        buttonSize: const Size(50, 50),
        icon: ButtonIcon(
            backgroundColor: ColorFile().buttonColor,
            icon: Icon(
              isVideoCall ? Icons.video_call_rounded : Icons.call,
              color: Colors.white,
            )),
        onPressed: onCallFinished,
      );
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'Send Call Button', 'Chat Screen');
      return Container();
    }
  }

  static String generateRandomString1(int length) {
    var r = math.Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

    return List.generate(length, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  List<ZegoUIKitUser> getInvitesFromTextCtrl(String id, String Name) {
    final invitees = <ZegoUIKitUser>[];
    try {
      invitees.add(ZegoUIKitUser(
        id: id,
        name: Name,
      ));
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'getInvitesFromTextCtrl', 'Chat Screen');
    }
    return invitees;
  }

  void onSendCallInvitationFinished(
    String code,
    String message,
    List<String> errorInvitees,
  ) {
    try {
      if (errorInvitees.isNotEmpty) {
        var userIDs = '';
        for (var index = 0; index < errorInvitees.length; index++) {
          if (index >= 5) {
            userIDs += '... ';
            break;
          }

          final userID = errorInvitees.elementAt(index);
          userIDs += '$userID ';
        }
        if (userIDs.isNotEmpty) {
          userIDs = userIDs.substring(0, userIDs.length - 1);
        }

        var message = "User doesn't exist or is offline: $userIDs";
        if (code.isNotEmpty) {
          message += ', code: $code, message:$message';
        }
        SnackBarDesign(message, context);
        print(
          message,
        );
      } else if (code.isNotEmpty) {
        print(
          'code: $code, message:$message',
        );
      }
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'onSendCallInvitationFinished', 'Chat Screen');
    }
  }

  Widget _charInput(ButtonVisibilityState buttonVisibilityState) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 1, // Optional shadow effect
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        _showEmoji = !_showEmoji;
                        visibleButton = true;
                      });
                    },
                    icon: Icon(
                      Icons.emoji_emotions,
                      color: ColorFile().buttonColor,
                      size: 24,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      onTap: () {
                        if (_showEmoji) {
                          setState(() {
                            _showEmoji = false;
                          });
                        }
                      },
                      onChanged: _onChanged,
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null, // Allows for more than 2 lines if needed
                      decoration: InputDecoration(
                        hintText: audioController.isRecording.value
                            ? "Recording audio..."
                            : "Message",
                        hintStyle: TextStyle(color: ColorFile().textColor),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      visibleButton = false;
                      AudioController audioController1 =
                          Get.put(AudioController());
                      if (audioController1.getIsRecordPlaying) {
                        audioController1.onPressedPlayButton(
                            audioController1.getCurrentId,
                            "audioController1.ci");
                      }
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return CameraButtonPage(widget.receiverId);
                      }));
                    },
                    icon: Icon(
                      Icons.camera_alt,
                      color: ColorFile().buttonColor,
                      size: 24,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      visibleButton = true;
                      _showBottomSheet();
                      AudioController audioController1 =
                          Get.put(AudioController());
                      if (audioController1.getIsRecordPlaying) {
                        audioController1.onPressedPlayButton(
                            audioController1.getCurrentId,
                            "audioController1.ci");
                      }
                    },
                    icon: Icon(
                      CupertinoIcons.paperclip,
                      color: ColorFile().buttonColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
              ),
            ),
          ),
          recorder.isRecording
              ? StreamBuilder(
                  stream: recorder.onProgress,
                  builder: (context, snapshot) {
                    final duration = snapshot.hasData
                        ? const Duration(seconds: 2)
                        : Duration.zero;
                    String twoDigits(int n) => n.toString().padLeft(2, "0");
                    final twoDigitMinutes =
                        twoDigits(duration.inMinutes.remainder(60));
                    final twoDigitSeconds =
                        twoDigits(duration.inSeconds.remainder(60));
                    audioFileDuration = twoDigitSeconds;
                    return Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        '$twoDigitMinutes:$twoDigitSeconds',
                        style: TextStyle(
                            color: ColorFile().buttonColor, fontSize: 16),
                      ),
                    );
                  },
                )
              : Container(),
          ValueListenableBuilder<bool>(
            valueListenable: buttonVisibilityState.isTextNotEmpty,
            builder: (context, value, child) {
              return Visibility(
                visible: value,
                replacement: GestureDetector(
                  onLongPress: () async {
                    AudioController audioController1 =
                        Get.put(AudioController());
                    if (audioController1.getIsRecordPlaying) {
                      audioController1.onPressedPlayButton(
                          audioController1.getCurrentId, "audioController1.ci");
                    }
                    var audioPlayer = AudioPlayer();
                    audioPlayer.setAsset("assets/audio/payal.mp3");
                    await audioPlayer.play();

                    Vibration.vibrate(duration: 100);
                    audioController.start.value = DateTime.now();
                    audioController.isRecording.value = true;
                    Future.delayed(const Duration(milliseconds: 200), () {
                      setState(() {
                        audioController.isRecording.value = true;
                      });
                    });
                  },
                  onLongPressEnd: (details) async {
                    visibleButton = false;
                  },
                  child: MaterialButton(
                    minWidth: 0,
                    padding: const EdgeInsets.all(10),
                    shape: const CircleBorder(),
                    color: ColorFile().buttonColor,
                    onPressed: () async {},
                    child: const Icon(
                      Icons.mic,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
                child: MaterialButton(
                  minWidth: 0,
                  onPressed: () {
                    if (_textController.text.isNotEmpty) {
                      if (editmessagesendagain) {
                        NetworkCallForEditMessage(
                            editmessageid, editmessagetext);
                      } else {
                        NetworkcallForSendMessage(widget.receiverId.toString(),
                            "text", "", "", _textController.text);
                        _textController.text = '';
                      }
                      buttonVisibilityState.updateTextVisibility(false);
                      setState(() {
                        visibleButton = false;
                      });
                    }
                  },
                  padding: const EdgeInsets.all(10),
                  shape: const CircleBorder(),
                  color: ColorFile().buttonColor,
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future record() async {
    await recorder.startRecorder(toFile: 'audio');
  }

  Future stop() async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      String FolderPath = "";
      String sdPath = "";
      final path = await recorder.stopRecorder();
      io.File audiofile = io.File(path!);

      final ext = audiofile.toString().split("'");
      sdPath = ext[1];
      recordFilePath = '$sdPath/$fileName.mp3';

      final bytes1 = await audiofile.readAsBytes();
      // print('Bytes1 $bytes1');
      //  io.File pdf = io.File.fromRawPath(bytes1);
      if (bytes1 != null) {
        final bytes = Future.value(bytes1);
        print('Bytes $bytes');

        APIs.sendChatFile(
            widget.receiverId,
            audiofile,
            AppUtility.ID,
            DateTime.now().millisecondsSinceEpoch.toString() + '.mp3',
            '',
            bytes);
      }
    } catch (e) {
      PrintMessage.printMessage(e.toString(), "stop", 'Chat Screen');
    }
  }

  _onChanged(String value) {
    try {
      final buttonVisibilityState =
          Provider.of<ButtonVisibilityState>(context, listen: false);
      buttonVisibilityState.updateTextVisibility(value.isNotEmpty);
    } catch (e) {
      PrintMessage.printMessage(e.toString(), '_onChanged', "Chat Screen");
    }
  }

  NetworkcallForSendMessage(String receiverid, String messagetpe,
      String duration, String filename, String message) async {
    String createjson = CreateJson().createjsonForSendMessage(
        AppUtility.ID, receiverid, message, messagetpe, duration, filename);
    if (await _checkinternetconnection) {
      NetworkResponse networkResponse = NetworkResponse();
      List<Object?>? list = await networkResponse.postMethod(
          AppUtility.send_message, AppUtility.send_message_api, createjson);
      List<Sendmessageresponse> sendmessageResponse = List.from(list!);
      String status = sendmessageResponse[0].status.toString();
      switch (status) {
        case "true":
          Data data = sendmessageResponse[0].data!;
          NetworkcallForGetChat();
          APIs.SendPushNotification(
              message,
              AppUtility.ID,
              data.pushtoken,
              data.name!,
              data.isAdmin!,
              data.isOnline == 1 ? true : false,
              DateTime.now().millisecondsSinceEpoch.toString(),
              receiverid);

          break;
        case "false":
          break;
      }
    } else {
      SnackBarDesign('Check internet connection', context);
    }
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return GridView.count(
            padding:
                kIsWeb ? const EdgeInsets.all(1) : const EdgeInsets.all(20),
            crossAxisCount: 2,
            shrinkWrap: true,
            children: [
              _OptionItemWidget(
                name: "Gallery",
                icon: RawMaterialButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    final ImagePicker picker = ImagePicker();

                    //pick an image
                    final List<XFile?> images =
                        await picker.pickMultipleMedia(imageQuality: 70);
                    if (images.isNotEmpty) {
                      for (var i in images) {
                        setState(() {
                          _isUploading = true;
                        });
                        //need to check this in
                        final bytes = i!.readAsBytes();
                        print(bytes);
                        // print('Image path:${i!.path}');

                        await APIs.sendChatFile(
                                widget.receiverId,
                                io.File(i.path),
                                AppUtility.ID,
                                i.name,
                                '',
                                bytes)
                            .then((value) {
                          setState(() {
                            _isUploading = false;
                            visibleButton = false;
                          });
                        });
                      }
                    }
                  },
                  elevation: 2.0,
                  fillColor: ColorFile().buttonColor,
                  child: const Icon(
                    Icons.image_rounded,
                    color: Colors.white,
                    size: 35.0,
                  ),
                  padding: const EdgeInsets.all(15.0),
                  shape: const CircleBorder(),
                ),
              ),
              _OptionItemWidget(
                name: "Document",
                icon: RawMaterialButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    // FilePickerResult? result = await FilePicker.platform
                    //     .pickFiles(allowMultiple: true, type: FileType.any);
                    // var result = await FilePicker.platform.pickFiles();
                    // if (result != null) {
                    //   Uint8List pdf1 = result.files.single.bytes!;
                    //   io.File pdf = io.File.fromRawPath(pdf1);
                    //   String filename = result.files.single.name.toString();
                    //   print('Filename: ' + filename);
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(allowMultiple: true, type: FileType.any);

                    if (result != null) {
                      List<io.File> files =
                          result.paths.map((path) => io.File(path!)).toList();
                      for (int i = 0; i < files.length; i++) {
                        io.File pdf = io.File(result.files[i].path!);
                        String filename = result.names[i].toString();
                        print(filename);

                        // final bytes = Future.value(pdf1);
                        final bytes = pdf.readAsBytes();
                        await APIs.sendChatFile(widget.receiverId, pdf,
                                AppUtility.ID, filename, '', bytes)
                            .then((value) {
                          setState(() {
                            _isUploading = false;
                            visibleButton = false;
                          });
                        });
                      }
                    }
                    // } else {
                    //   // User canceled the picker
                    // }
                  },
                  elevation: 2.0,
                  fillColor: ColorFile().buttonColor,
                  child: const Icon(
                    CupertinoIcons.doc,
                    color: Colors.white,
                    size: 35.0,
                  ),
                  padding: const EdgeInsets.all(15.0),
                  shape: const CircleBorder(),
                ),
              ),
            ],
          );
        });
  }

  onGoBack(value) {
    if (!mounted) {
      setState(() {});
    } else {
      NetworkcallForGetChat();
    }
  }
}

class _OptionItemWidget extends StatelessWidget {
  final RawMaterialButton icon;
  final String name;
  //final VoidCallback onTap;
  const _OptionItemWidget({required this.icon, required this.name});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: kIsWeb
            ? const EdgeInsets.only(left: 5, top: 5)
            : const EdgeInsets.only(left: 5, top: 15),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(
                height: 5,
              ),
              Flexible(
                  child: Text('$name',
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          letterSpacing: 0.5))),
            ]),
      ),
    );
  }
}
