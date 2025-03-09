import 'package:flutter/material.dart';

class WordEmpty extends StatelessWidget {
  const WordEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('🏙️', style: TextStyle(fontSize: 64)),
        Text(
          'Please Search a Word!',
          style: theme.textTheme.headlineSmall,
        ),
      ],
    );
  }
}