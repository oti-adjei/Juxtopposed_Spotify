import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify_juxtopposed/discovery.dart';
import 'package:spotify_juxtopposed/home.dart';
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

/*class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'You have pushed the button this many times:',
          ),
          Text(
            '$_counter',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          //Show the navigation bar at the bottom
          CustomNavigationBar(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
*/

// Define a provider to manage current index
final currentIndexProvider = StateProvider<int>((ref) => 0);
Color _navColor = Color.fromRGBO(0, 0, 0, 0.1);

// Navigation bar widget with blur effect
class CustomNavigationBar extends ConsumerWidget {
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
      // appBar: AppBar(
      //   title: Text("FLutter Demo"),
      // ),
      body: SafeArea(
        child: Stack(
          children: [
            IndexedStack(
              index: currentIndex,
              children: [
                // HomeScreen(),
                // SearchScreen(),
                // LibraryScreen(),
                SpotifyCloneHome(),
                DiscoveryMenu(),
                SearchMenu(),
                Center(child: Text('Library')),
                //A list view to show a list of contacts
                ListView.builder(
                  itemCount: 30,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Contact ${index + 1}'),
                    );
                  },
                ),
              ],
            ),
            CustomNavigationBar(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
