import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

abstract class MediaController {}

class VideoPlayerControllerWrapper extends MediaController {
  final VideoPlayerController controller;

  VideoPlayerControllerWrapper(this.controller);
}

class YoutubePlayerControllerWrapper extends MediaController {
  final YoutubePlayerController controller;

  YoutubePlayerControllerWrapper(this.controller);
}

class GenericPage extends StatefulWidget {
  final String title;

  GenericPage({super.key, required this.title});

  @override
  _GenericPageState createState() => _GenericPageState();
}

class _GenericPageState extends State<GenericPage> {
  final List<String> videoUrls = [
    'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    'https://videos.pexels.com/video-files/5528328/5528328-hd_1920_1080_25fps.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
  ];

  final List<MediaController> _mediaControllers = [];

  final RegExp _youtubeRegExp = RegExp(
    r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([a-zA-Z0-9_-]{11})$",
  );

  final PageController _pageController = PageController();
  List<VideoPlayerController> _videoControllers = [];
  List<YoutubePlayerController> _youtubeControllers = [];
  int activeIndex = 0;

  @override
  void initState() {
    super.initState();

    // Initialize controllers based on URL type (YouTube or MP4)
    /*for (var url in videoUrls) {
      if (_youtubeRegExp.hasMatch(url)) {
        final youtubeId = _youtubeRegExp.firstMatch(url)?.group(1);
        if (youtubeId != null) {
          final controller = YoutubePlayerController(
            initialVideoId: youtubeId,
            flags: YoutubePlayerFlags(
              autoPlay: true,
              mute: false,
            ),
          );
          _youtubeControllers.add(controller);
        }
      } else {
        final controller = VideoPlayerController.networkUrl(Uri.parse(url))
          ..addListener(() => setState(() {}))
          // ..setLooping(true)
          ..initialize();
        _videoControllers.add(controller);
      }
    }*/

    for (var url in videoUrls) {
      if (_youtubeRegExp.hasMatch(url)) {
        final youtubeId = _youtubeRegExp.firstMatch(url)?.group(1);
        if (youtubeId != null) {
          final controller = YoutubePlayerController(
            initialVideoId: youtubeId,
            flags: YoutubePlayerFlags(
              autoPlay: true,
              mute: false,
            ),
          );
          _mediaControllers
              .add(YoutubePlayerControllerWrapper(controller)); // Use wrapper
        }
      } else {
        final controller = VideoPlayerController.networkUrl(Uri.parse(url))
          ..addListener(() => setState(() {}))
          // ..setLooping(true)
          ..initialize();
        _mediaControllers
            .add(VideoPlayerControllerWrapper(controller)); // Use wrapper
      }
    }
    // Play the first video
    /* if (_youtubeControllers.isNotEmpty) {
      _youtubeControllers.first.play();
    } else {
      _videoControllers.first.play();
    }*/

    if (_mediaControllers.isNotEmpty) {
      final firstController = _mediaControllers.first;

      if (firstController is VideoPlayerControllerWrapper) {
        firstController.controller.play();
      } else if (firstController is YoutubePlayerControllerWrapper) {
        firstController.controller.play();
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _videoControllers) {
      controller.dispose();
    }
    for (final controller in _youtubeControllers) {
      controller.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  void _playVideo(int index) {
    // Pause all videos and play the selected one
    for (int i = 0; i < _videoControllers.length; i++) {
      if (i == index) {
        _videoControllers[i].play();
      } else {
        _videoControllers[i].pause();
      }
    }

    for (int i = 0; i < _youtubeControllers.length; i++) {
      if (i == index) {
        _youtubeControllers[i].play();
      } else {
        _youtubeControllers[i].pause();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView.builder(
        controller: _pageController,
        itemCount: videoUrls.length,
        scrollDirection: Axis.vertical,
        onPageChanged: (index) {
          setState(() {
            activeIndex = index;
          });
          _playVideo(index);
        },
        itemBuilder: (context, index) {
          final url = videoUrls[index];
          final controller = _mediaControllers[index];

          // Check controller type
          if (controller is VideoPlayerControllerWrapper) {
            final videoController =
                controller.controller; // Access VideoPlayerController

            // MP4 player logic using videoController
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                margin: EdgeInsets.only(bottom: 20.0),
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: videoController.value.isInitialized
                    ? GestureDetector(
                        onTap: () {
                          if (videoController.value.isPlaying) {
                            videoController.pause();
                          } else {
                            videoController.play();
                          }
                        },
                        child: AspectRatio(
                          aspectRatio: videoController.value.aspectRatio,
                          child: VideoPlayer(videoController),
                        ),
                      )
                    : Center(child: CircularProgressIndicator()),
              ),
            );
          } else if (controller is YoutubePlayerControllerWrapper) {
            final youtubeController =
                controller.controller; // Access YoutubePlayerController

            // YouTube player logic using youtubeController
            return Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: YoutubePlayer(
                  controller: youtubeController,
                  showVideoProgressIndicator: true,
                  onReady: () {
                    youtubeController.play();
                  },
                ),
              ),
            );
          } else {
            // Handle unexpected controller type (optional)
            return Text('Unknown controller type');
          }
        },
        /* itemBuilder: (context, index) {
          final url = videoUrls[index];
          final isYoutube = _youtubeRegExp.hasMatch(url);
          if (isYoutube) {
            // YouTube player
            final controller = _youtubeControllers[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: YoutubePlayer(
                  controller: controller,
                  showVideoProgressIndicator: true,
                  onReady: () {
                    controller.play();
                  },
                ),
              ),
            );
          } else {
            // MP4 player
            final controller = _videoControllers[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: controller.value.isInitialized
                    ? GestureDetector(
                        onTap: () {
                          if (controller.value.isPlaying) {
                            controller.pause();
                          } else {
                            controller.play();
                          }
                        },
                        child: AspectRatio(
                          aspectRatio: controller.value.aspectRatio,
                          child: VideoPlayer(controller),
                        ),
                      )
                    : Center(child: CircularProgressIndicator()),
              ),
            );
          }
        },*/
      ),
    );
  }
}
