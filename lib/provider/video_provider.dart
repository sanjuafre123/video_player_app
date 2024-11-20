import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_app/helper/api_helper.dart';
import 'package:video_player_app/modal/video_modal.dart';

class VideoProvider extends ChangeNotifier {
  VideoPlayerModal? videoPlayerModal;
  ApiHelper apiHelper = ApiHelper();

  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;

  Future<VideoPlayerModal?> fetchApiData() async {
    final data = await apiHelper.fetchApiData();
    videoPlayerModal = VideoPlayerModal.fromJson(data);
    return videoPlayerModal;
  }

  Future<void> videoControllerInitializer(String videoUrl) async {
    videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(
        videoUrl.split('http').join('https'),
      ),
    );
    await videoPlayerController.initialize();
  }

  Future<void> initializePlayer(String videoUrl) async {
    await videoControllerInitializer(videoUrl);
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: false,
      aspectRatio: videoPlayerController.value.aspectRatio,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red,
        handleColor: Colors.red,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.white.withOpacity(0.5),
      ),
    );
    notifyListeners();
  }

  VideoProvider() {
    fetchApiData();
  }
}
