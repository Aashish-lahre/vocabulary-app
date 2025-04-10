import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final String wordName;

  const TitleWidget({required this.wordName, super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme
        .of(context)
        .textTheme;
    final colorScheme = Theme
        .of(context)
        .colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(wordName,
              style: textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold, color: colorScheme.onSurface))
        ],
      ),
    );
  }
}