import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

final discoverTabProvider = StateProvider<int>((ref) => 0);

class DiscoveryMenuuu extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(discoverTabProvider);
    final tabs = _getTabButtons(context, ref);
    final children = _getChildren(context, currentIndex);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: tabs,
              ),
            ),
            Icon(Icons.settings, color: Colors.grey),
          ],
        ),
      ),
      body: Container(
          // color: Colors.yellow,
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.07),
          child: Column(children: children)),
    );
  }

  List<Widget> _getTabButtons(BuildContext context, WidgetRef ref) {
    return [
      _TabButton(label: "Music", index: 0),
      _TabButton(label: "Podcasts", index: 1),
      _TabButton(label: "Audiobooks", index: 2),
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.1,
        child: IconButton(
          onPressed: () {},
          icon: Icon(Icons.filter_list),
        ),
      )
    ];
  }

  List<Widget> _getChildren(BuildContext context, int currentIndex) {
    return [
      if (currentIndex == 0) Center(child: Text("Music Content")),
      if (currentIndex == 1) Center(child: Text("Podcasts Content")),
      // if (currentIndex == 2) Center(child: Text("Audiobooks Content")),
      // if (currentIndex == 0) GenericPage(title: "Music"),
      // if (currentIndex == 1) GenericPage(title: "Podcasts"),
      if (currentIndex == 2) GenericPage(title: "Audiobooks"),
    ];
  }
}

class _TabButton extends ConsumerWidget {
  final String label;
  final int index;

  _TabButton({required this.label, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(discoverTabProvider);

    return GestureDetector(
      onTap: () => ref.read(discoverTabProvider.notifier).state = index,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: currentIndex == index ? Colors.white : Colors.grey,
        ),
      ),
    );
  }
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
    'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    'https://videos.pexels.com/video-files/5528328/5528328-hd_1920_1080_25fps.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
  ];

  final RegExp _youtubeRegExp = RegExp(
    r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([a-zA-Z0-9_-]{11})$",
  );

  final PageController _pageController = PageController(viewportFraction: 0.85);
  List<VideoPlayerController> _videoControllers = [];
  List<YoutubePlayerController> _youtubeControllers = [];
  int activeIndex = 0;

  @override
  void initState() {
    super.initState();

    // Initialize controllers based on URL type (YouTube or MP4)
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
          _youtubeControllers.add(controller);
        }
      } else {
        final controller = VideoPlayerController.networkUrl(Uri.parse(url))
          ..addListener(() => setState(() {}))
          // ..setLooping(true)
          ..initialize();
        _videoControllers.add(controller);
      }
    }

    // Play the first video
    if (_youtubeControllers.isNotEmpty) {
      _youtubeControllers.first.play();
    } else {
      _videoControllers.first.play();
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
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Container(
                decoration: BoxDecoration(
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
        },
      ),
    );
  }
}
