import 'package:flutter/material.dart';
import 'package:flutter_improve_vocabulary/core/shared/word_card_shimmer.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
        left: 30,
        right: 30,
        top: 50,
        bottom: 50,
        child: WordCardShimmer());
  }
}
