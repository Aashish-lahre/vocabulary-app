import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Column errorWidget(BuildContext context, String errorMessage, ElevatedButton? elevatedButton) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    spacing: 20,
    children: [
      Text(
        'Oops!',
        style: Theme.of(context)
            .copyWith(
            textTheme:
            GoogleFonts.eaterTextTheme())
            .textTheme
            .displayLarge!
            .copyWith(
            fontSize: 70,
            color: Theme.of(context)
                .colorScheme
                .onSurface),
      ),
      Text(
        errorMessage,
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(
            color: Theme.of(context)
                .colorScheme
                .onSurface),
      ),
      elevatedButton ?? SizedBox.shrink(),
    ],
  );
}