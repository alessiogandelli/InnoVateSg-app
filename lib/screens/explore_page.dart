import 'package:flutter/material.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.explore, size: 80, color: Colors.blueAccent),
          const SizedBox(height: 16),
          Text(
            'Explore',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          const Text(
            'Discover new AI features and capabilities',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
