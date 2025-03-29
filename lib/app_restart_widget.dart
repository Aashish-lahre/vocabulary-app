import 'package:flutter/material.dart';

class AppRestartWidget extends StatefulWidget {
  final Widget child;
  const AppRestartWidget({super.key, required this.child});

  static void restartApp(BuildContext context) {
    final _AppRestartWidgetState? state =
    context.findAncestorStateOfType<_AppRestartWidgetState>();
    state?.restartApp();
  }

  @override
  State<AppRestartWidget> createState() => _AppRestartWidgetState();
}

class _AppRestartWidgetState extends State<AppRestartWidget> {
  Key _key = UniqueKey(); // Generates a new key for rebuilding the app

  void restartApp() {
    setState(() {
      _key = UniqueKey(); // Assign a new key, forcing the app to rebuild
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _key,
      child: widget.child,
    );
  }
}