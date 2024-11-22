import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchMenu extends ConsumerWidget {
  const SearchMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final searchQuery = ref.watch(searchQueryProvider).state;
    // final songs = ref.watch(songsProvider(searchQuery)).data?.value ?? [];

    // return Scaffold(
    //   body: Padding(
    //     padding: const EdgeInsets.all(16.0),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Text('Search for $searchQuery'),
    //         Expanded(
    //           child: ListView.builder(
    //             itemCount: songs.length,
    //             itemBuilder: (context, index) {
    //               final song = songs[index];
    //               return ListTile(
    //                 title: Text(song.title),
    //                 subtitle: Text(song.artist),
    //               );
    //             },
    //           ),
    //         ),

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    //NAvigate to search page
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchPage(),
                        ));
                  },
                  child: SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('What do you want to play'),
                          Icon(Icons.search)
                        ],
                      )),
                )),
                SizedBox(width: 8),
                Icon(Icons.camera_alt),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Browse all',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Discover',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: List.generate(10, (index) => DiscoverTile()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DiscoverTile extends StatelessWidget {
  const DiscoverTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 50,
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(child: Text("Mix")),
    );
  }
}

class SearchPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String searchResults = '';
    // final searchResults = ref.watch(searchResultsProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Search')),
      body: Column(
        children: [
          // TextField to type queries
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Search...',
                  ),
                  onChanged: (value) {
                    if (value.isEmpty) {
                      if (kDebugMode) {
                        searchResults = value;
                        print('Clearing search results');
                      }
                      // Clear results and show recent searches
                      // ref.read(searchResultsProvider.notifier).state = [];
                    } else {
                      // Simulate a search result fetch
                      searchResults = value;
                      if (kDebugMode) {
                        print('Searching for "$value"');
                      }
                      // ref.read(searchResultsProvider.notifier).state = [
                      //   'Result for "$value" 1',
                      //   'Result for "$value" 2',
                      //   'Result for "$value" 3',
                      // ];
                    }
                  },
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
              ],
            ),
          ),
          Expanded(
            child: searchResults.isEmpty
                ? _buildRecentSearches() // Show recent searches
                : Center(
                    child: Text(
                        'Searching for $searchResults')), // Show search results
            // : _buildSearchResults(searchResults), // Show search results
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearches() {
    // Replace this with your actual recent searches logic
    final recentSearches = ['Flutter', 'Riverpod', 'State Management'];
    return ListView.builder(
      itemCount: recentSearches.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(recentSearches[index]),
        );
      },
    );
  }

  Widget _buildSearchResults(List<String> results) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index]),
        );
      },
    );
  }
}
