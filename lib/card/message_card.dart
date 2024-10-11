import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/customisedesign.dart/snackbardesign.dart';
import 'package:dio/dio.dart';
import 'package:file_utils/file_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:line_icons/line_icons.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../Utility/apputility.dart';
import '../Utility/mydateutil.dart';
import '../Utility/printmessage.dart';
import '../customisedesign.dart/audiocontroller.dart';
import '../customisedesign.dart/colorfile.dart';
import '../network/response/getchatresponse.dart';
import '../pages/detailimagescreen.dart';

bool downloading = false;
var progress = "";
String path = "no data";

class MessageCard extends StatefulWidget {
  final Messagejson messagejson;
  final int index;
  final List<Messagejson> selectedlist;
  final Function(bool) onSelectionChanged;
  bool isSelected;
  MessageCard({
    required this.messagejson,
    required this.index,
    required this.selectedlist,
    required this.onSelectionChanged,
    required this.isSelected,
  });
  State createState() => MessageCardState();
}

class MessageCardState extends State<MessageCard> {
  bool isSelected = false;
//Payal Change this on 22/8/2023
  @override
  void didChangeDependencies() {
    isSelected = widget.isSelected;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    bool isMe = AppUtility.ID == widget.messagejson.senderId;
    return InkWell(
        onLongPress: () {
          //Payal Change this on 22/8/2023
          try {
            setState(() {
              isSelected = !isSelected;
              widget.onSelectionChanged(!isSelected);
            });
          } catch (e) {
            PrintMessage.printMessage(
                e.toString(), 'On Long Press', 'Message Card');
          }
        },
        onTap: () async {
          try {
            if (widget.selectedlist.isNotEmpty) {
              //Payal Change this on 22/8/2023
              setState(() {
                isSelected = !isSelected;
              });

              widget.onSelectionChanged(!isSelected);
            } else {
              if (widget.messagejson.messageType == "pdf" ||
                  widget.messagejson.messageType == "xls" ||
                  widget.messagejson.messageType == "word" ||
                  widget.messagejson.messageType == "docx") {
                //  ProgressDialog.showProgressDialog(context, 'Opening file');
                try {
                  OpenFile(
                      widget.messagejson.messageText!,
                      widget.messagejson.filename,
                      widget.messagejson.messageType.toString());
                } catch (e) {
                  Navigator.pop(context);
                  print(e.toString());
                }
              }
            }
          } catch (e) {
            PrintMessage.printMessage(e.toString(), 'On Tap', 'Message Card');
          }
        },
        child: isMe ? sendMessage() : receivedMessage());
  }

  // Future<void> _downloadFile(String url) async {
  //   DownloadService downloadService =
  //       kIsWeb ? WebDownloadService() : MobileDownloadService();
  //   await downloadService.download(url: AppUtility.PathFile + url);
  // }

  Widget receivedMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(child: setType(widget.messagejson.messageType!, "sendmsg")),
        widget.messagejson.messageType == "incomingCall"
            ? Container()
            : Padding(
                padding: const EdgeInsets.only(left: 7, bottom: 5),
                child: Text(
                  MyDateUtil.getFormatedDate(
                      context, widget.messagejson.timestamp!.toString()),
                  style: const TextStyle(fontSize: 10, color: Colors.black54),
                ),
              )
      ],
    );
  }

  Widget setType(String type, String whoSendMsg) {
    try {
      switch (type) {
        case "call":
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.phone,
                color: Colors.red,
                size: 15,
              ),
              SizedBox(
                width: 1,
              ),
              Text(
                widget.messagejson.messageText!,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              )
            ],
          );
          break;
        case "text":
          return Container(
            margin: EdgeInsets.all(
                widget.messagejson.messageType == "text" ? 5 : 2),
            padding: EdgeInsets.all(
                widget.messagejson.messageType == "text" ? 10 : 5),
            decoration: BoxDecoration(
                color: widget.isSelected
                    ? Colors.grey.withOpacity(0.5)
                    : whoSendMsg == "receivemsg"
                        ? ColorFile().buttonColor
                        : Colors.white,
                borderRadius: whoSendMsg == 'receivemsg'
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15))
                    : const BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15))),
            child: Text(
              widget.messagejson.messageText!,
              style: TextStyle(
                  color:
                      whoSendMsg == "receivemsg" ? Colors.white : Colors.black,
                  fontSize: 14),
            ),
          );
        case "image":
          return ClipRRect(
            borderRadius: BorderRadius.circular(15), // More rounded corners
            child: Container(
              height: 200,
              width: 200,
              margin: EdgeInsets.symmetric(
                  vertical: 2, horizontal: 5), // Compact margins
              padding: EdgeInsets.all(2), // Minimal padding
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? Colors.grey.withOpacity(0.5)
                    : whoSendMsg == "receivemsg"
                        ? const Color(
                            0xFFECE5DD) // WhatsApp-like background for received images
                        : Colors.grey.shade300, // Light grey for sent images
                borderRadius: whoSendMsg == 'receivemsg'
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(15),
                      )
                    : const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(0),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return DetailScreen(
                      AppUtility.PathFile! + widget.messagejson.messageText!,
                    );
                  }));
                },
                child: CachedNetworkImage(
                  imageUrl:
                      AppUtility.PathFile! + widget.messagejson.messageText!,
                  width: 200,
                  fit: BoxFit.cover, // Cover image nicely within the container
                  errorWidget: (context, url, error) => const Icon(
                    Icons.image,
                    size: 70,
                    color: Colors.grey, // Grey icon for errors
                  ),
                ),
              ),
            ),
          );
        case "pdf":
          return Container(
            width: 220, // Slightly wider for better visibility
            margin: EdgeInsets.symmetric(
                vertical: 5, horizontal: 8), // WhatsApp-like margin
            padding: EdgeInsets.all(10), // Padding inside the bubble
            decoration: BoxDecoration(
              color: whoSendMsg == "receivemsg"
                  ? Color(0xFF128C7E) // WhatsApp's greenish tone for received
                  : Color(0xFFD9FDD3), // Light grey for sent
              borderRadius: whoSendMsg == 'receivemsg'
                  ? BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                      bottomRight:
                          Radius.circular(0)) // More rounded for received
                  : BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                      bottomRight: Radius.circular(18),
                      bottomLeft: Radius.circular(0)), // More rounded for sent
            ),
            child: Row(
              children: [
                // WhatsApp-style PDF Icon
                Icon(
                  LineIcons.pdfFile, // PDF file icon
                  color: Colors.red, // Red color like WhatsApp
                  size: 30, // Larger icon
                ),

                SizedBox(width: 8), // Space between icon and text

                // PDF File Name
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.messagejson.messageText!, // Display file name
                        overflow:
                            TextOverflow.ellipsis, // Truncate long file names
                        maxLines: 1, // Single line
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: whoSendMsg == "receivemsg"
                              ? Colors.white // Text color for received
                              : Colors.black, // Text color for sent
                        ),
                      ),
                      // Optional: Display file size like WhatsApp
                      Text(
                        "2.3 MB", // Placeholder for file size
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white, // Subtle grey for file size
                        ),
                      ),
                    ],
                  ),
                ),

                // Downloading Indicator (like WhatsApp)
                // downloading
                //     ? CircularProgressIndicator(
                //         strokeWidth: 2) // Show progress indicator
                //     : Icon(
                //         Icons
                //             .download_rounded, // Download icon when not downloading
                //         color: Colors.black54,
                //       ),
              ],
            ),
          );

        case "xls":
          return Container(
            width: 200, // Maintain compact width
            margin: EdgeInsets.symmetric(
                vertical: 4, horizontal: 6), // Minimal margins
            padding: EdgeInsets.all(8), // Compact padding
            decoration: BoxDecoration(
              color: whoSendMsg == "receivemsg"
                  ? Color(0xFF128C7E) // Light green for received messages
                  : Color(0xFF128C7E), // Light grey for sent messages
              borderRadius: whoSendMsg == 'receivemsg'
                  ? BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(0)) // Rounded for received
                  : BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                      bottomLeft: Radius.circular(0)), // Rounded for sent
            ),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Align icon and text vertically
              children: [
                // Minimal Excel File Icon
                Icon(
                  LineIcons.fileInvoice, // Excel file icon
                  color: Color(0xFF25D366), // WhatsApp green for the icon
                  size: 24, // Smaller icon for a minimal look
                ),

                SizedBox(width: 6), // Minimal spacing

                // File Name
                Expanded(
                  child: Text(
                    widget.messagejson.messageText!, // Display file name
                    overflow: TextOverflow.ellipsis, // Truncate if too long
                    maxLines: 1, // Single line
                    style: TextStyle(
                      fontSize: 14, // Smaller text size for minimal look
                      color: whoSendMsg == "receivemsg"
                          ? Colors.white // Dark text for received
                          : Colors.white, // Slightly muted for sent
                    ),
                  ),
                ),

                // Downloading Indicator
                // downloading
                //     ? SizedBox(
                //         width: 16,
                //         height: 16,
                //         child: CircularProgressIndicator(
                //           strokeWidth: 2, // Thinner progress bar for minimalism
                //           color: Colors.grey.shade600, // Muted color
                //         ),
                //       )
                //     : Icon(
                //         Icons.download_rounded, // Small download icon
                //         color: Colors.white, // Muted grey for minimalism
                //         size: 18, // Small icon size
                //       ),
              ],
            ),
          );

        case "word":
          return Container(
            width: 200,
            margin: EdgeInsets.all(
                widget.messagejson.messageType == "text" ? 5 : 2),
            padding: EdgeInsets.all(
                widget.messagejson.messageType == "text" ? 10 : 5),
            decoration: BoxDecoration(
                color: widget.isSelected
                    ? Colors.grey.withOpacity(0.5)
                    : whoSendMsg == "receivemsg"
                        ? ColorFile().buttonColor
                        : Colors.grey.shade300,
                borderRadius: whoSendMsg == 'receivemsg'
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15))
                    : const BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15))),
            child: Row(
              children: [
                Icon(
                  LineIcons.wordFile,
                  color: ColorFile().buttonColor,
                ),
                Expanded(
                  child: Text(
                    widget.messagejson.messageText!,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                        color: whoSendMsg == "receivemsg"
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
                downloading ? CircularProgressIndicator() : Container()
              ],
            ),
          );
        case "docx":
          return Container(
            width: 200,
            margin: EdgeInsets.all(
                widget.messagejson.messageType == "text" ? 5 : 2),
            padding: EdgeInsets.all(
                widget.messagejson.messageType == "text" ? 10 : 5),
            decoration: BoxDecoration(
                color: widget.isSelected
                    ? Colors.grey.withOpacity(0.5)
                    : whoSendMsg == "receivemsg"
                        ? ColorFile().buttonColor
                        : Colors.grey.shade300,
                borderRadius: whoSendMsg == 'receivemsg'
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15))
                    : const BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15))),
            child: Row(
              children: [
                Icon(
                  LineIcons.wordFile,
                  color: ColorFile().buttonColor,
                ),
                Expanded(
                  child: Text(
                    widget.messagejson.messageText!,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                        color: whoSendMsg == "receivemsg"
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
                downloading ? CircularProgressIndicator() : Container()
              ],
            ),
          );
        // for audio send
        case "audio":
          return Container(
            width: 200,
            margin: EdgeInsets.symmetric(
                vertical: 5, horizontal: 10), // Consistent margins
            padding: EdgeInsets.symmetric(
                vertical: 10, horizontal: 15), // Padding for better spacing
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? Colors.grey.withOpacity(0.5)
                  : whoSendMsg == "receivemsg"
                      ? ColorFile().buttonColor.withOpacity(
                          0.8) // Slightly transparent background for received messages
                      : Colors.grey.shade300,
              borderRadius: whoSendMsg == 'receivemsg'
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15))
                  : const BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // Subtle shadow
                  blurRadius: 5, // Soft blur effect
                  offset: Offset(0, 3), // Slightly raised effect
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.play_arrow, // Play button for the audio
                  color: Colors.white,
                ),
                SizedBox(width: 10), // Space between the icon and text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinearProgressIndicator(
                        value: 0.3, // Placeholder for audio progress
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "${widget.messagejson.duration} sec",
                        style: TextStyle(
                          color: Colors.white, // Text color for contrast
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );

        // for video send
        case "video":
          return Container(
            width: 200,
            height: 200,
            margin: EdgeInsets.all(
                widget.messagejson.messageType == "text" ? 5 : 2),
            padding: EdgeInsets.all(
                widget.messagejson.messageType == "text" ? 10 : 5),
            decoration: BoxDecoration(
                color: Colors.transparent, // Set background to transparent
                borderRadius: whoSendMsg == 'receivemsg'
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15))
                    : const BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15))),
            child: VideoMessageWidget(
              videoUrl: AppUtility.PathFile! +
                  widget.messagejson.messageText.toString(),
              videoname: widget.messagejson.messageText!,
              whosendmsg: whoSendMsg,
              audioController: audioController,
            ),
          );

        default:
          return Container();
      }
    } catch (e) {
      PrintMessage.printMessage(e.toString(), 'Set Type', 'Message Card');
      return Container();
    }
  }

  Widget sendMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          child: setType(
            widget.messagejson.messageType!,
            "receivemsg",
          ),
        ),
        widget.messagejson.messageType == "incomingCall"
            ? Container()
            : Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    MyDateUtil.getFormatedDate(
                        context, widget.messagejson.timestamp!.toString()),
                    style: const TextStyle(fontSize: 10, color: Colors.black54),
                  ),
                  if (widget.messagejson.isRead == "1")
                    Icon(Icons.done_all_rounded,
                        color: ColorFile().buttonColor, size: 15),
                  const SizedBox(
                    width: 2,
                  ),
                ],
              )
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    MyDateUtil.getFormatedDate(context, '');

    super.dispose();
  }

  Future<bool> checkfileexists(String filename) async {
    try {
      String dirloc = "";

      dirloc = (await getApplicationDocumentsDirectory()).path;

      var syncPath = await dirloc;
      File f = await File(syncPath);
      if (await f.exists()) {
        return true;
      }
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'check file exists', 'message card');
    }
    return false;
  }

  String FolderPath = "";
  Future<bool> checkFolderExiste(String filetype) async {
    try {
      FolderPath = (await getApplicationDocumentsDirectory()).path;

      var syncPath = await FolderPath + '/' + filetype;
      File f = await File(syncPath);
      if (await f.exists()) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), 'check file exists', 'message card');
      return false;
    }
  }

  Future OpenFile(String url, String filename, String fileType) async {
    try {
      final file = await downloadFile(url, filename, fileType);
      if (file == null) {
        // Navigator.pop(context);
        return;
      }
      print('Path:${file.path} ');
      if (fileType == 'Type.audio') {
      } else {
        //  Navigator.pop(context);
        final result = await OpenFilex.open(file.path);
        setState(() {
          var _openResult = "type=${result.type}  message=${result.message}";
          print(_openResult);
        });
      }
    } catch (e) {
      PrintMessage.printMessage(e.toString(), 'Open file', 'message card');
    }
  }

  Future<File?> downloadFile(
      String url, String filename, String fileType) async {
    // Dio dio = Dio();
    if (fileType == 'Type.audio') {
      fileType = "audio";
    } else if (fileType == 'Type.pdf' ||
        fileType == 'Type.word' ||
        fileType == 'Type.docx' ||
        fileType == 'Type.xls' ||
        fileType == 'Type.ppt') {
      fileType = "document";
    }

    if (!await checkFolderExiste(fileType)) {
      FileUtils.mkdir([FolderPath + '/' + fileType]);
    }

    try {
      final file = File('${FolderPath}/${fileType}/$url');
      final response = await Dio().get(
        AppUtility.PathFile + url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ),
      );
      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return file;
    } catch (e) {
      PrintMessage.printMessage(e.toString(), 'downloadFile', 'Message Card');
      return null;
    }
  }

  AudioController audioController = Get.put(AudioController());
  Widget _audio(
      {required String message, required String duration, required int index}) {
    AudioPlayer audioPlayer = AudioPlayer();
    // log('audioController.isRecordPlaying: ${audioController.getIsRecordPlaying}');
    // log('audioController.currentId: ${audioController.getCurrentId}');
    // log('index: $index');
    return Container(
      width: 300,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          GestureDetector(
            child: (audioController.getIsRecordPlaying &&
                    audioController.getCurrentId == index)
                ? IconButton(
                    onPressed: () async {
                      audioController.onPressedPlayButton(index, message);
                      // audioController
                      await audioPlayer.stop();
                    },
                    icon: const Icon(
                      Icons.cancel,
                      color: Colors.grey,
                    ))
                : IconButton(
                    onPressed: () {
                      /*if (audioController.isRecordPlaying) {
                        audioController.onPressedPlayButton(index, message);
                        // audioController.changeProg();
                      }*/
                      audioController.onPressedPlayButton(index, message);
                      // audioController.changeProg();
                    },
                    icon: Icon(
                      Icons.play_arrow,
                      color: Colors.grey,
                    )),
            // ),
          ),
          // Obx(
          //   () => Expanded(
          //     child: Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 0),
          //       child: Stack(
          //         clipBehavior: Clip.none,
          //         alignment: Alignment.center,
          //         children: [
          //           // Text(audioController.completedPercentage.value.toString(),style: TextStyle(color: Colors.white),),
          //           LinearProgressIndicator(
          //             minHeight: 5,
          //             backgroundColor: Colors.grey,
          //             valueColor: AlwaysStoppedAnimation<Color>(
          //               ColorFile().buttonColor,
          //             ),
          //             value: (audioController.isRecordPlaying &&
          //                     audioController.currentId == index)
          //                 ? audioController.completedPercentage.value
          //                 : audioController.totalDuration.value.toDouble(),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          SizedBox(
            width: 10,
          ),
          Text(
            duration,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _OptionItemWidget extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;
  const _OptionItemWidget(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 5, top: 15, bottom: 25),
        child: Row(children: [
          icon,
          Flexible(
              child: Text('   $name',
                  style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                      letterSpacing: 0.5))),
        ]),
      ),
    );
  }
}

class VideoMessageWidget extends StatefulWidget {
  final String videoUrl, videoname, whosendmsg;
  final AudioController audioController;
  const VideoMessageWidget(
      {required this.videoUrl,
      required this.videoname,
      required this.whosendmsg,
      required this.audioController});

  @override
  _VideoMessageWidgetState createState() => _VideoMessageWidgetState();
}

class _VideoMessageWidgetState extends State<VideoMessageWidget> {
  late VideoPlayerController _videoController;
  late Future<Widget> _thumbnailFuture;
  bool isVideoDownloaded = false;
  bool isLocalVideo = false;
  String localVideoPath = "";
  String downloadMessage = "";
  var percentage;
  @override
  void initState() {
    super.initState();
    // print("videoPath" + widget.videoUrl);
    _videoController = VideoPlayerController.network(
        isLocalVideo ? localVideoPath : widget.videoUrl);
    _thumbnailFuture = _generateThumbnail();
    _videoController.initialize().then((_) {
      //  setState(() {});//Payal change this on 22/8/2023
    });
    checkVideoDownloaded();
  }

  void checkVideoDownloaded() async {
    Future<bool> folderexist = checkFileExiste(widget.videoname);
    if (await folderexist) {
      setState(() {
        isVideoDownloaded = true;
        isLocalVideo = true;
      });
    } else {
      setState(() {
        isVideoDownloaded = false;
        isLocalVideo = false;
      });
    }
  }

  Future<Widget> _generateThumbnail() async {
    try {
      final thumbnailPath = isLocalVideo
          ? await VideoThumbnail.thumbnailFile(
              video: localVideoPath,
              thumbnailPath: (await getApplicationDocumentsDirectory()).path,
              imageFormat: ImageFormat.JPEG,
              quality: 10)
          : await VideoThumbnail.thumbnailFile(
              video: widget.videoUrl,
              thumbnailPath: (await getApplicationDocumentsDirectory()).path,
              imageFormat: ImageFormat.JPEG,
              quality: 10);

      return Image.file(File(thumbnailPath!));
    } catch (e) {
      print(e.toString());
      return Container();
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _thumbnailFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data != null) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 200,
                  width: 300,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      color: Colors.black,
                      child: _videoController.value.isInitialized
                          ? VideoPlayer(_videoController)
                          : Container(),
                    ),
                    // child: VideoPlayer(_videoController),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _videoController.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                    size: 48,
                  ),
                  onPressed: () {
                    setState(() {
                      isLocalVideo
                          ? OpenFile(localVideoPath, widget.videoname, "video",
                              true, widget.audioController)
                          : OpenFile(widget.videoUrl, widget.videoname, "video",
                              false, widget.audioController);
                    });
                  },
                ),
                Positioned(
                  left: 8,
                  bottom: 8,
                  child: Column(
                    children: [
                      if (!isVideoDownloaded)
                        IconButton(
                          icon: Icon(Icons.download),
                          color: Colors.white,
                          onPressed: () {
                            OpenFile(widget.videoUrl, widget.videoname, "video",
                                false, widget.audioController);
                            checkVideoDownloaded();
                          },
                        ),
                      if (!isVideoDownloaded)
                        if (percentage != 100)
                          Text(
                            downloadMessage,
                            style: TextStyle(color: Colors.white),
                          )
                    ],
                  ),
                ),
              ],
            );
          } else {
            // Handle case when thumbnail is not available
            return AspectRatio(
              aspectRatio: _videoController.value.aspectRatio,
              child: VideoPlayer(_videoController),
            );
          }
        } else {
          return Center(child: Container());
        }
      },
    );
  }

  String FolderPath = "";
  Future<bool> checkFolderExiste() async {
    FolderPath = (await getApplicationDocumentsDirectory()).path;

    var syncPath = await FolderPath;

    File f = await File(syncPath);
    if (await f.exists()) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkFileExiste(String filename) async {
    FolderPath = (await getApplicationDocumentsDirectory()).path;

    var syncPath = await FolderPath + "/" + filename;

// for a file
    File f = await File(syncPath);
    if (await f.exists()) {
      localVideoPath = syncPath;
      return true;
    } else {
      return false;
    }
  }

  Future<void> requestPermissions() async {
    // Map<Permission, PermissionStatus> statuses =
    await [
      Permission.storage,
    ].request();
  }

  Future OpenFile(String url, String filename, String fileType, bool play,
      AudioController audioController) async {
    requestPermissions();

    if (play) {
      if (audioController.getIsRecordPlaying) {
        SnackBarDesign('Please stop audio first', context);
        return;
      }
      await OpenFilex.open(url);
    } else {
      final file = await downloadFile(url, filename, fileType);

      if (file == null) return;
      // print('Path:${file.path} ');
      //
      await OpenFilex.open(file.path);
      setState(() {
        isLocalVideo = true;
        isVideoDownloaded = true;
      });
    }
  }

  Future<File?> downloadFile(
      String url, String filename, String fileType) async {
    if (!await checkFolderExiste()) {
      FileUtils.mkdir([FolderPath]);
    }

    try {
      final file = File('${FolderPath}/$filename');
      final response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ),
        onReceiveProgress: (actualbytes, totalbytes) {
          percentage = actualbytes / totalbytes * 100;
          setState(() {
            downloadMessage = ' ${percentage.floor()} %';
            print(downloadMessage);
          });
        },
      );
      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return file;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
