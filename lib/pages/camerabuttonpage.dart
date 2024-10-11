import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Utility/apis.dart';
import '../Utility/apputility.dart';
import '../Utility/printmessage.dart';
import '../customisedesign.dart/snackbardesign.dart';

bool _isUploading = false;

class CameraButtonPage extends StatefulWidget {
  String id;
  CameraButtonPage(this.id);

  @override
  _CameraButtonPageState createState() => _CameraButtonPageState();
}

class _CameraButtonPageState extends State<CameraButtonPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late File? _capturedImage;
  late File? _capturedVideo;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _captureImage() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.camera);
      String filename = DateTime.now().millisecondsSinceEpoch.toString();
      if (pickedImage != null) {
        final ext = pickedImage.path.split('.').last;
        filename = filename + '.' + ext;

        setState(() {
          _capturedImage = File(pickedImage.path);
          _capturedVideo = null;
        });
        // setState(() {
        //   _isUploading = true;
        // });

        await APIs.sendChatFile(widget.id.toString(), File(pickedImage.path),
                AppUtility.ID, filename, "", pickedImage.readAsBytes())
            .then((value) {
          setState(() {
            _isUploading = false;
          });
          SnackBarDesign('Image send sucessfully', context);
          Navigator.of(context).pop();
        });
      }
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), '_captureImage', 'Camera Button Page');
    }
  }

  Future<void> _captureVideo() async {
    try {
      final pickedVideo =
          await ImagePicker().pickVideo(source: ImageSource.camera);
      String filename = DateTime.now().millisecondsSinceEpoch.toString();
      if (pickedVideo != null) {
        if (kIsWeb) {
          final ext = pickedVideo.name.split('.').last;
          filename = filename + '.' + ext;
        } else {
          final ext = pickedVideo.path.split('.').last;
          filename = filename + '.' + ext;
        }
        setState(() {
          _capturedVideo = File(pickedVideo.path);
          _capturedImage = null;
        });
        setState(() {
          _isUploading = true;
        });
        APIs.sendChatFile(
                widget.id.toString(),
                File(pickedVideo.path),
                AppUtility.ID,
                filename,
                '',
                pickedVideo.readAsBytes()) //Have to pass durartion
            .then((value) {
          setState(() {
            _isUploading = false;
          });
          SnackBarDesign('Video send sucessfully', context);
          Navigator.of(context).pop();
        });
      }
    } catch (e) {
      PrintMessage.printMessage(
          e.toString(), '_captureVideo', 'Camera Button Page');
    }
  }

  @override
  void dispose() {
    try {
      _tabController.dispose();
      super.dispose();
    } catch (e) {
      PrintMessage.printMessage(e.toString(), 'dispose', 'Camera Button Page');
    }
  }

  int _currentIndex = 0;

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.photo_camera),
          label: 'Photo',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.videocam),
          label: 'Video',
        ),
      ],
    );
  }

  Widget getBody() {
    switch (_currentIndex) {
      case 0:
        return _buildCameraView(_captureImage);
      case 1:
        return _buildCameraView(_captureVideo);
      default:
        return _buildCameraView(_captureImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      extendBodyBehindAppBar: true,
      body: getBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildCameraView(Function() captureFunction) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(
              Icons.camera_alt,
              size: 48,
              color: Colors.grey[400],
            ),
            onPressed: captureFunction,
          ),
          SizedBox(height: 16),
          Text(
            captureFunction == _captureImage
                ? 'Tap to Capture'
                : 'Tap to Record',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[400],
            ),
          ),
          if (_isUploading)
            Align(
                alignment: Alignment.center,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                    ))),
        ],
      ),
    );
  }
}
