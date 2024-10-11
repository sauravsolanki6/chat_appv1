// import 'dart:html' as html;
// import 'dart:io';
// import 'dart:typed_data';

// import 'package:camera/camera.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// import '../Utility/apis.dart';
// import '../Utility/apputility.dart';
// import '../customisedesign.dart/colorfile.dart';
// import '../customisedesign.dart/snackbardesign.dart';

// class CameraApp extends StatefulWidget {
//   String id;
//   CameraApp(this.id);
//   @override
//   _CameraAppState createState() => _CameraAppState();
// }

// class _CameraAppState extends State<CameraApp> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         home: Scaffold(
//       appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           leading: IconButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               icon: Icon(
//                 CupertinoIcons.back,
//                 color: Colors.black,
//               ))),
//       body: AppBody(widget.id),
//     ));
//   }
// }

// class AppBody extends StatefulWidget {
//   String id;
//   AppBody(this.id);
//   @override
//   _AppBodyState createState() => _AppBodyState();
// }

// class _AppBodyState extends State<AppBody> {
//   bool cameraAccess = false;
//   String? error;
//   List<CameraDescription>? cameras;

//   @override
//   void initState() {
//     getCameras();
//     super.initState();
//   }

//   Future<void> getCameras() async {
//     try {
//       await html.window.navigator.mediaDevices!
//           .getUserMedia({'video': true, 'audio': false});
//       setState(() {
//         cameraAccess = true;
//       });
//       final cameras = await availableCameras();
//       setState(() {
//         this.cameras = cameras;
//       });
//     } on html.DomException catch (e) {
//       setState(() {
//         error = '${e.name}: ${e.message}';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (error != null) {
//       return Center(child: Text('Error: $error'));
//     }
//     if (!cameraAccess) {
//       return Center(child: Text('Camera access not granted yet.'));
//     }
//     if (cameras == null) {
//       return Center(child: Text('Reading cameras'));
//     }
//     return CameraView(cameras!, widget.id);
//   }
// }

// class CameraView extends StatefulWidget {
//   final List<CameraDescription> cameras;
//   String id;
//   CameraView(this.cameras, this.id);

//   @override
//   _CameraViewState createState() => _CameraViewState();
// }

// class _CameraViewState extends State<CameraView> {
//   String? error;
//   CameraController? controller;
//   late CameraDescription cameraDescription = widget.cameras[0];

//   Future<void> initCam(CameraDescription description) async {
//     setState(() {
//       controller = CameraController(description, ResolutionPreset.max);
//     });

//     try {
//       await controller!.initialize();
//     } catch (e) {
//       setState(() {
//         error = e.toString();
//       });
//     }

//     setState(() {});
//   }

//   @override
//   void initState() {
//     super.initState();
//     initCam(cameraDescription);
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   bool visibleStop = false;
//   bool visibleStart = true;
//   @override
//   Widget build(BuildContext context) {
//     if (error != null) {
//       // return Center(
//       //   child: Text('Initializing error: $error\nCamera list:'),
//       // );
//       return Container();
//     }
//     if (controller == null) {
//       return Container();
//       //return Center(child: Text('Loading controller...'));
//     }
//     if (!controller!.value.isInitialized) {
//       return Container();
//       // return Center(child: Text('Initializing camera...'));
//     }

//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             AspectRatio(aspectRatio: 2.0, child: CameraPreview(controller!)),
//             SizedBox(
//               height: 20,
//             ),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 visibleStart
//                     ? ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                             side: BorderSide(color: ColorFile().buttonColor),
//                             backgroundColor: Colors.white),
//                         onPressed: controller == null
//                             ? null
//                             : () async {
//                                 await controller!.startVideoRecording();
//                                 setState(() {
//                                   visibleStop = true;
//                                   visibleStart = false;
//                                 });
//                               },
//                         child: Text(
//                           'Tap to start record',
//                           style: TextStyle(color: Colors.black),
//                         ),
//                       )
//                     : Container(),
//                 visibleStop
//                     ? ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                             side: BorderSide(color: ColorFile().buttonColor),
//                             backgroundColor: Colors.white),
//                         onPressed: controller == null
//                             ? null
//                             : () async {
//                                 String filename = DateTime.now()
//                                     .millisecondsSinceEpoch
//                                     .toString();
//                                 final file =
//                                     await controller!.stopVideoRecording();
//                                 final bytes1 = await file.readAsBytes();
//                                 filename = filename + '.webm';
//                                 final bytes = Future.value(bytes1);
//                                 await APIs.sendChatFile(
//                                         widget.id.toString(),
//                                         File(file.path),
//                                         AppUtility.ID,
//                                         filename,
//                                         "",
//                                         bytes)
//                                     .then((value) {
//                                   setState(() {});
//                                   visibleStop = false;
//                                   visibleStart = true;
//                                   SnackBarDesign(
//                                       'Video send sucessfully', context);
//                                 });
//                               },
//                         child: Text(
//                           'Tap to stop record',
//                           style: TextStyle(color: Colors.black),
//                         ),
//                       )
//                     : Container()
//               ],
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                   side: BorderSide(color: ColorFile().buttonColor),
//                   backgroundColor: Colors.white),
//               onPressed: controller == null
//                   ? null
//                   : () async {
//                       final file = await controller!.takePicture();
//                       final bytes1 = await file.readAsBytes();
//                       String filename =
//                           DateTime.now().millisecondsSinceEpoch.toString();
//                       // final link = html.AnchorElement(
//                       // href: Uri.dataFromBytes(bytes1, mimeType: 'image/png')
//                       //     .toString());
//                       //  link.download = 'picture.png';
//                       //link.click();
//                       // link.remove();
//                       filename = filename + '.png';
//                       final bytes = Future.value(bytes1);
//                       await APIs.sendChatFile(
//                               widget.id.toString(),
//                               File(file.path),
//                               AppUtility.ID,
//                               filename,
//                               "",
//                               bytes)
//                           .then((value) {
//                         setState(() {});
//                         SnackBarDesign('Image send sucessfully', context);
//                         Navigator.of(context).pop();
//                         Navigator.of(context).pop();
//                       });
//                     },
//               child: Text(
//                 'Tap to capture',
//                 style: TextStyle(color: Colors.black),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
