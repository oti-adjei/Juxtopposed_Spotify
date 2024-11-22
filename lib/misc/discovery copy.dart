import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

final discoverTabProvider = StateProvider<int>((ref) => 0);

class DiscoveryMenuu extends ConsumerWidget {
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

class GenericPage extends StatelessWidget {
  final String title;
  GenericPage({super.key, required this.title});

  final List<Short> shortsData = [
    Short(videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'),
    Short(videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'),
    Short(videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'),
    Short(
        videoUrl:
            'https://videos.pexels.com/video-files/5528328/5528328-hd_1920_1080_25fps.mp4'),
    Short(
        videoUrl:
            'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'),
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView.builder(
        controller:
            PageController(viewportFraction: 0.85), // Allows for paging control
        itemCount: shortsData.length,
        scrollDirection: Axis.vertical, // For vertical snapping
        itemBuilder: (context, index) {
          final short = shortsData[index];
          return Padding(
            padding: const EdgeInsets.only(
                bottom:
                    20.0), // Only add padding to the bottom to show the next page
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                // color: Color((Random().nextDouble() * 0xFFFFFF).toInt())
                // .withOpacity(1.0),
              ),

              // height: MediaQuery.of(context)
              //     .size
              //     .height, // Adjusted to give space for the next page to peek
              width: MediaQuery.of(context).size.width,
              child: ShortVideoWidget(videoUrl: short.videoUrl, title: title),
            ),
          );
        },
      ),
    );
  }
}

class Short {
  String videoUrl;
  Short({required this.videoUrl});
}

// class ShortVideoWidget extends StatelessWidget {
//   final String videoUrl;
//   final String title;

//   ShortVideoWidget({required this.videoUrl, required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         DecoratedBox(
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: NetworkImage(videoUrl),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         Positioned(
//           bottom: 0,
//           left: 0,
//           child: Text(title),
//         ),
//       ],
//     );
//   }
// }

class ShortVideoWidget extends StatefulWidget {
  final String videoUrl;
  final String title;

  const ShortVideoWidget({required this.videoUrl, required this.title});

  @override
  _ShortVideoWidgetState createState() => _ShortVideoWidgetState();
}

class _ShortVideoWidgetState extends State<ShortVideoWidget> {
  late VideoPlayerController _videoController;
  late YoutubePlayerController _youtubeController;

  final RegExp _youtubeRegExp = RegExp(
    r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([a-zA-Z0-9_-]{11})$",
  );

  bool _isYoutubeVideo(String url) {
    return _youtubeRegExp.hasMatch(url);
  }

  Widget _buildVideo() {
    if (_isYoutubeVideo(widget.videoUrl)) {
      return YoutubePlayer(
        controller: _youtubeController,
        showVideoProgressIndicator: true,
        onReady: () {
          _youtubeController.play();
        },
      );
    } else {
      return AspectRatio(
        aspectRatio: _videoController.value.aspectRatio,
        child: VideoPlayer(_videoController),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (_isYoutubeVideo(widget.videoUrl)) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: _youtubeRegExp.firstMatch(widget.videoUrl)![1]!,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      );
    } else {
      _videoController =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
            ..initialize().then((_) {
              setState(() {});
              _videoController.play(); // Auto-play
              _videoController.setLooping(true); // Loop the video
            });
    }
  }

  @override
  void dispose() {
    if (_isYoutubeVideo(widget.videoUrl)) {
      _youtubeController.dispose();
    } else {
      _videoController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isYoutubeVideo(widget.videoUrl)
        ? _buildVideo()
        : _videoController.value.isInitialized
            ? Stack(
                children: [
                  _buildVideo(),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Text(widget.title),
                  ),
                ],
              )
            : SizedBox(
                width: double.infinity,
                height: 200,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              );
  }
}
