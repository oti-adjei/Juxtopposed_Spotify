import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify_juxtopposed/discovery/audioplayer.dart';
import 'package:spotify_juxtopposed/discovery/tab_button.dart';

final discoverTabProvider = StateProvider<int>((ref) => 0);

class DiscoveryMenu extends ConsumerWidget {
  const DiscoveryMenu({super.key});

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
      TabButton(label: "Music", index: 0),
      TabButton(label: "Podcasts", index: 1),
      TabButton(label: "Audiobooks", index: 2),
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
      if (currentIndex == 1) MyWidget(),
      // if (currentIndex == 2) Center(child: Text("Audiobooks Content")),
      // if (currentIndex == 0) GenericPage(title: "Music"),
      // if (currentIndex == 1) GenericPage(title: "Podcasts"),
      if (currentIndex == 2)
        AudioPageView(
          audioDataList: audioDataListt,
        ),
      // if (currentIndex == 2) GenericPage(title: "Audiobooks"),
    ];
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
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
                    onTap: () {},
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.height * 0.3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey,
                        image: const DecorationImage(
                          image: NetworkImage(
                              'https://placehold.com/600x400/EEE/31343C'),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
