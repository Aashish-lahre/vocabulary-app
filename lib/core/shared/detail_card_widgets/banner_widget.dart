import 'package:flutter/material.dart';

class BannerWidget extends StatelessWidget {
  final String type;

  const BannerWidget({this.type = 'Word from API', super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme
        .of(context)
        .textTheme;
    final colorScheme = Theme
        .of(context)
        .colorScheme;
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal:20.0),
        child: Row(
          spacing: 30,
          children: [
            Icon(
              Icons.arrow_downward_rounded,
              color: colorScheme.onSecondaryContainer,
            ),
            Text(type,
                style: textTheme.bodyMedium
                    ?.copyWith(color: colorScheme.onSecondaryContainer)),
          ],
        ),
      ),
    );
  }
}