import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tabProvider = StateProvider<int>((ref) => 0);

class SpotifyCloneHome extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(tabProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                ],
              ),
            ),
            Icon(Icons.settings, color: Colors.white),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (currentIndex == 0) MusicPage(),
              if (currentIndex == 1) PodcastsPage(),
              if (currentIndex == 2) AudiobooksPage(),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabButton extends ConsumerWidget {
  final String label;
  final int index;

  _TabButton({required this.label, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(tabProvider);

    return GestureDetector(
      onTap: () => ref.read(tabProvider.notifier).state = index,
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

class MusicPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle("Your Mixes"),
        SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(6, (index) => MixItem()),
          ),
        ),
        SizedBox(height: 20),
        SectionTitle("Made For You"),
        SizedBox(height: 8),
        Container(
          height: 180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: List.generate(5, (index) => LargeMixItem()),
          ),
        ),
        SizedBox(height: 20),
        SectionTitle("Your Top Mixes"),
        SizedBox(height: 8),
        Container(
          height: 180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: List.generate(5, (index) => LargeMixItem()),
          ),
        ),
        SizedBox(height: 20),
        SectionTitle("New Releases"),
        SizedBox(height: 8),
        Container(
          height: 180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: List.generate(5, (index) => LargeMixItem()),
          ),
        ),
      ],
    );
  }
}

// Placeholder for other pages, can add custom widgets or more details as needed
class PodcastsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Podcasts Content"));
  }
}

class AudiobooksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Audiobooks Content"));
  }
}

// Same SectionTitle, MixItem, and LargeMixItem as before
class SectionTitle extends StatelessWidget {
  final String title;
  SectionTitle(this.title);
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}

class MixItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(child: Text("Mix")),
    );
  }
}

class LargeMixItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Center(child: Text("Image")),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Discover Weekly",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Your weekly mix of fresh music"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
