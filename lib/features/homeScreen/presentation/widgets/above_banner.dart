import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

OverlayEntry? _overlayEntry; // Track the current overlay banner

void showOverlayBanner(
    BuildContext context, {
      String? title,
      String? message,
      required ContentType contentType,
      Duration removeAfterDuration = const Duration(seconds: 2),
    }) {
  // Remove any existing banner before showing a new one
  _overlayEntry?.remove();
  _overlayEntry = null;

  final overlay = Overlay.of(context);
  _overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 50, // Adjust the position as needed
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: AwesomeSnackbarContent(
          title: title ?? '',
          message: message ?? '',
          contentType: contentType,
          inMaterialBanner: true,
        ),
      ),
    ),
  );

  overlay.insert(_overlayEntry!);

  // Remove after specified duration
  Future.delayed(removeAfterDuration, () {
    _overlayEntry?.remove();
    _overlayEntry = null;
  });
}
