import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify_juxtopposed/account.dart';
import 'package:spotify_juxtopposed/discovery.dart';
import 'package:spotify_juxtopposed/home.dart';
import 'package:spotify_juxtopposed/library.dart';
import 'package:spotify_juxtopposed/search.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  // const MyApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainApp(),
    );
  }
}

// Define a provider to manage current index
final currentIndexProvider = StateProvider<int>((ref) => 0);
Color _navColor = Color.fromRGBO(0, 0, 0, 0.1);

// Navigation bar widget with blur effect
class CustomNavigationBar extends ConsumerWidget {
  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentIndexProvider);

    return Positioned(
      bottom: 0,
      width: MediaQuery.of(context).size.width,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.07,
        color: _navColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // More buttons here...
            IconButton(
              icon: Icon(Icons.home),
              color: currentIndex == 0 ? Colors.white : Colors.grey,
              onPressed: () =>
                  ref.read(currentIndexProvider.notifier).state = 0,
            ),
            IconButton(
              icon: Icon(Icons.star),
              color: currentIndex == 1 ? Colors.white : Colors.grey,
              onPressed: () =>
                  ref.read(currentIndexProvider.notifier).state = 1,
            ),
            IconButton(
              icon: Icon(Icons.search),
              color: currentIndex == 2 ? Colors.white : Colors.grey,
              onPressed: () =>
                  ref.read(currentIndexProvider.notifier).state = 2,
            ),
            IconButton(
              icon: Icon(Icons.library_add),
              color: currentIndex == 3 ? Colors.white : Colors.grey,
              onPressed: () =>
                  ref.read(currentIndexProvider.notifier).state = 3,
            ),
            IconButton(
              icon: Icon(Icons.person),
              color: currentIndex == 4 ? Colors.white : Colors.grey,
              onPressed: () =>
                  ref.read(currentIndexProvider.notifier).state = 4,
            ),
          ],
        ),
      ),
    );
  }
}

// Main app structure with IndexedStack and CustomNavigationBar
class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentIndexProvider);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            IndexedStack(
              index: currentIndex,
              children: [
                SpotifyCloneHome(),
                DiscoveryMenu(),
                SearchMenu(),
                LibraryPage(),
                AccountPage()
              ],
            ),
            CustomNavigationBar(),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
