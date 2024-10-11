import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

// class AudioController extends GetxController {
/// for lifecycle method in getx
class AudioController extends  FullLifeCycleController with FullLifeCycleMixin {
  final isRecordPlaying = false.obs,
      isRecording = false.obs,
      isSending = false.obs,
      isUploading = false.obs;
  final currentId = 999999.obs;
  final start = DateTime.now().obs;
  final end = DateTime.now().obs;
  String total = "";
  String get getTotal => total;
  var completedPercentage = 0.0.obs;
  var currentDuration = 0.obs;
  var totalDuration = 0.obs;

  bool get getIsRecordPlaying => isRecordPlaying.value;
  bool get isRecordingValue => isRecording.value;
  late final AudioPlayerService _audioPlayerService;
  int get getCurrentId => currentId.value;
  @override
  void onInit() {
    _audioPlayerService = AudioPlayerAdapter();

    _audioPlayerService.getAudioPlayer.onDurationChanged.listen((duration) {
      totalDuration.value = duration.inMicroseconds;
    });

    _audioPlayerService.getAudioPlayer.onPositionChanged.listen((duration) {
      currentDuration.value = duration.inMicroseconds;
      completedPercentage.value =
          currentDuration.value.toDouble() / totalDuration.value.toDouble();
    });

    _audioPlayerService.getAudioPlayer.onPlayerComplete.listen((event) async {
      await _audioPlayerService.getAudioPlayer.seek(Duration.zero);
      isRecordPlaying.value = false;
    });

    super.onInit();
  }

  @override
  void onClose() async {
    if(getIsRecordPlaying){
      await _audioPlayerService.pause();
    }
    _audioPlayerService.dispose();
    super.onClose();
  }

  Future<void> changeProg() async {
    if (getIsRecordPlaying) {
      _audioPlayerService.getAudioPlayer.onDurationChanged.listen((duration) {
        totalDuration.value = duration.inMicroseconds;
      });

      _audioPlayerService.getAudioPlayer.onPositionChanged.listen((duration) {
        currentDuration.value = duration.inMicroseconds;
        completedPercentage.value =
            currentDuration.value.toDouble() / totalDuration.value.toDouble();
      });
    }
  }

  void onPressedPlayButton(int id, var content) async {
    currentId.value = id;
    if (getIsRecordPlaying) {
      await pauseRecord();
    } else {
      isRecordPlaying.value = true;
      await _audioPlayerService.play(content);
    }
  }

  calcDuration() {
    var a = end.value.difference(start.value).inSeconds;
    format(Duration d) => d.toString().split('.').first.padLeft(8, "0");
    total = format(Duration(seconds: a));
  }

  Future<void> pauseRecord() async {
    isRecordPlaying.value = false;
    await _audioPlayerService.pause();
  }

  @override
  Future<void> onDetached() async {
    // TODO: implement onDetached
   /* if(_isRecordPlaying.value == true){
      _isRecordPlaying.value = false;
      await _audioPlayerService.pause();
    }*/
  }

  @override
  Future<void> onInactive() async {
    // TODO: implement onInactive
    /*if(_isRecordPlaying.value == true){
      _isRecordPlaying.value = false;
      await _audioPlayerService.pause();
    }*/
  }

  @override
  Future<void> onPaused() async {
    // TODO: implement onPaused
    if(isRecordPlaying.value == true){
      isRecordPlaying.value = false;
      await _audioPlayerService.pause();
    }
  }

  @override
  Future<void> onResumed() async {
    // TODO: implement onResumed
    /*if(_isRecordPlaying.value == true){
      _isRecordPlaying.value = false;
      await _audioPlayerService.pause();
    }*/
  }
  
  @override
  void onHidden() {
    // TODO: implement onHidden
  }
}

abstract class AudioPlayerService {
  void dispose();
  Future<void> play(String url);
  Future<void> resume();
  Future<void> pause();
  Future<void> release();

  AudioPlayer get getAudioPlayer;
}

class AudioPlayerAdapter implements AudioPlayerService {
  late AudioPlayer _audioPlayer;

  @override
  AudioPlayer get getAudioPlayer => _audioPlayer;

  AudioPlayerAdapter() {
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() async {
    await _audioPlayer.dispose();
  }

  @override
  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  @override
  Future<void> play(String url) async {
    await _audioPlayer.play(UrlSource(url));
  }

  @override
  Future<void> release() async {
    await _audioPlayer.release();
  }

  @override
  Future<void> resume() async {
    await _audioPlayer.resume();
  }
}

class AudioDuration {
  static double calculate(Duration soundDuration) {
    if (soundDuration.inSeconds > 60) {
      return 70.w;
    } else if (soundDuration.inSeconds > 50) {
      return 65.w;
    } else if (soundDuration.inSeconds > 40) {
      return 60.w;
    } else if (soundDuration.inSeconds > 30) {
      return 55.w;
    } else if (soundDuration.inSeconds > 20) {
      return 50.w;
    } else if (soundDuration.inSeconds > 10) {
      return 45.w;
    } else {
      return 40.w;
    }
  }
}
