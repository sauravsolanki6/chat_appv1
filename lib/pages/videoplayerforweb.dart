// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class VideoPlayerForWeb extends StatefulWidget {
// String videoUrl;
// VideoPlayerForWeb(this.videoUrl);

//   @override
//   State<VideoPlayerForWeb> createState() => VideoPlayerForWebState();
// }

// class VideoPlayerForWebState extends State<VideoPlayerForWeb> {
//   late VideoPlayerController controller;
//   // String videoUrl =
//   //     'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';

//   @override
//   void initState() {
//     super.initState();
//     controller = VideoPlayerController.network(widget.videoUrl);

//     controller.addListener(() {
//       setState(() {});
//     });
//     controller.setLooping(true);
//     controller.initialize().then((_) => setState(() {}));
//     controller.play();
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent.withOpacity(0.1),
//         elevation: 0,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(CupertinoIcons.back),
//           color: Colors.black,
//         ),
//       ),
//       body: Center(
//         child: InkWell(
//           onTap: () {
//             if (controller.value.isPlaying) {
//               controller.pause();
//             } else {
//               controller.play();
//             }
//           },
//           child: AspectRatio(
//             aspectRatio: controller.value.aspectRatio,
//             child: VideoPlayer(controller),
//           ),
//         ),
//       ),
//     );
//   }
// }
// import 'package:video_player/video_player.dart';
// import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerForWeb extends StatefulWidget {
  String videoUrl;
  VideoPlayerForWeb(this.videoUrl);
  @override
  State createState() => VideoPlayerForWebState();
}

class VideoPlayerForWebState extends State<VideoPlayerForWeb> {
  late VideoPlayerController _controller;
  late Duration videoLength;
  late Duration videoPosition;
  double volume = 0.5;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      // _controller = VideoPlayerController.network(widget.videoUrl)
      ..addListener(() => setState(() {
            videoPosition = _controller.value.position;
          }))
      ..initialize().then((_) => setState(() {
            videoLength = _controller.value.duration;
          }))
      ..play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              CupertinoIcons.back,
              color: Colors.black,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(100.0),
        child: Column(
          children: <Widget>[
            if (_controller.value.isInitialized) ...[
              Container(
                  width: 300, height: 200, child: VideoPlayer(_controller)),
              VideoProgressIndicator(
                _controller,
                allowScrubbing: true,
                padding: EdgeInsets.all(10),
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    },
                  ),
                  // Text(
                  //     '${convertToMinutesSeconds(videoPosition)} / ${convertToMinutesSeconds(videoLength)}'),
                  Text('${convertToMinutesSeconds(videoPosition)} '),
                  SizedBox(width: 10),
                  Icon(animatedVolumeIcon(volume)),
                  Slider(
                    value: volume,
                    min: 0,
                    max: 1,
                    onChanged: (_volume) => setState(() {
                      volume = _volume;
                      _controller.setVolume(_volume);
                    }),
                  ),
                  Spacer(),
                  // IconButton(
                  //     icon: Icon(
                  //       Icons.loop,
                  //       color: _controller.value.isLooping
                  //           ? Colors.green
                  //           : Colors.black,
                  //     ),
                  //     onPressed: () {
                  //       setState(() {
                  //         _controller.setLooping(!_controller.value.isLooping);
                  //       });
                  //     }),
                ],
              )
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

String convertToMinutesSeconds(Duration duration) {
  final parsedMinutes = duration.inMinutes < 10
      ? '0${duration.inMinutes}'
      : duration.inMinutes.toString();

  final seconds = duration.inSeconds % 60;

  final parsedSeconds =
      seconds < 10 ? '0${seconds % 60}' : (seconds % 60).toString();
  return '$parsedMinutes:$parsedSeconds';
}

IconData animatedVolumeIcon(double volume) {
  if (volume == 0)
    return Icons.volume_mute;
  else if (volume < 0.5)
    return Icons.volume_down;
  else
    return Icons.volume_up;
}
