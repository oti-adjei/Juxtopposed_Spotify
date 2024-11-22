import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify_juxtopposed/discovery.dart';

class TabButton extends ConsumerWidget {
  final String label;
  final int index;

  TabButton({required this.label, required this.index});

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
