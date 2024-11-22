import 'package:flutter/material.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  bool isGridView = false; // State variable to track layout type

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max, // Column takes full height
      children: [
        Row(
          // First Row with search bar and icon
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 7,
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
                ),
              ), // Search bar takes 70% of the width
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () => print("Search Button Pressed"),
            ),
          ],
        ),
        Row(
          // Second Row with filters and layout icon
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Group"),
            Text("Recents"),
            IconButton(
              icon: Icon(isGridView ? Icons.list : Icons.grid_view),
              onPressed: () => setState(() => isGridView = !isGridView),
            ),
          ],
        ),
        Expanded(
          // Area A: List or Grid based on state
          child: isGridView
              ? GridView.count(
                  // Grid view with 2 columns
                  crossAxisCount: 2,
                  children: List.generate(
                    20, // Replace with your data source
                    (index) => Container(
                      child: Text("Item $index"),
                      color: Colors.grey[200],
                    ),
                  ),
                )
              : ListView.separated(
                  // Separated list view
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: 20, // Replace with your data source
                  itemBuilder: (context, index) => ListTile(
                    title: Text("Item $index"),
                  ),
                ),
        ),
      ],
    );
  }
}
