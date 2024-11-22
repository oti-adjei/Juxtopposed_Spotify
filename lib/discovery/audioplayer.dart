import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPageView extends StatelessWidget {
  final List<AudioData> audioDataList;

  const AudioPageView({super.key, required this.audioDataList});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView.builder(
        itemCount: audioDataList.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          final audioData = audioDataList[index];
          return AudioPlayerScreen(
            audioUrl: audioData.audioUrl,
            imageUrl: audioData.imageUrl,
          );
        },
      ),
    );
  }
}

class AudioData {
  final String audioUrl;
  final String imageUrl;

  const AudioData({required this.audioUrl, required this.imageUrl});
}

class AudioPlayerScreen extends StatefulWidget {
  final String audioUrl;
  final String imageUrl;

  const AudioPlayerScreen(
      {super.key, required this.audioUrl, required this.imageUrl});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late AudioPlayer _player;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _playAudio() async {
    await _player.play(UrlSource(widget.audioUrl));
    setState(() {
      _isPlaying = true;
    });
  }

  Future<void> _pauseAudio() async {
    await _player.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
            color: Colors.blue,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      // Handle back button press
                    },
                  ),
                  const Text(
                    'Song Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox()
                ],
              ),
              const SizedBox(height: 20),
              Stack(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: SoundWaveRectangles(),
                  ),
                  Positioned(
                    left: (MediaQuery.of(context).size.width) / 8,
                    child: GestureDetector(
                      onTap: () => _isPlaying ? _pauseAudio : _playAudio,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.height * 0.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey,
                          image: const DecorationImage(
                            image: NetworkImage(
                                'https://placehold.co/600x400/EEE/31343C'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Image(
                          image: NetworkImage(
                              "https://placehold.co/600x400/EEE/31343C",
                              scale: 1.0),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              Text('Image Not Found'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Text('#hashtag1'),
                              SizedBox(width: 10),
                              Text('#hashtag2'),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Text('Song Title'),
                              const SizedBox(width: 10),
                              const Text('Artist Name'),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const CircleAvatar(
                            backgroundImage: NetworkImage(
                                'https://placehold.co/600x400/EEE/31343C'),
                          ),
                          IconButton(
                            icon: const Icon(Icons.volume_up),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(Icons.share),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(Icons.more_vert),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const LinearProgressIndicator(),
                  const SizedBox(height: 15),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 10),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              color: Colors.green,
            ),
            width: MediaQuery.of(context).size.width,
          ),
        )
      ],
    );
  }
}

List<AudioData> audioDataListt = [
  AudioData(
      audioUrl:
          'https://freesound.org/s/58554/download/339468/preview-hq.mp3', // Replace with a specific sound effect URL
      imageUrl:
          'https://example.com/image1.jpg' // Replace with an appropriate image URL
      ),
  AudioData(
      audioUrl:
          'https://freemusicarchive.org/file/music/No_Doubt/New_Wave/ND_01-Take_On_Me', // Replace with a specific music track URL
      imageUrl:
          'https://example.com/image2.jpg' // Replace with an appropriate image URL
      ),
  // ... add more AudioData objects
];

class SoundWaveRectangles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Row(
        children: List.generate(
          77, // Adjust the number of rectangles as needed
          (index) => Container(
            width: 3,
            height: 20 *
                sin(index * 0.2)
                    .abs(), // Adjust the height based on a sine wave
            color: Colors.black,
            margin: EdgeInsets.only(right: 2),
          ),
        ),
      ),
    );
  }
}
