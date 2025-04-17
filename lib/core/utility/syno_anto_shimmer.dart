import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../features/gemini_ai/bloc/gemini_bloc.dart';

Widget buildSynonymsAntonymsShimmer(
    BuildContext context, GeminiState state, int loadingCount) {
  if (state is AntonymsLoadingState || state is SynonymsLoadingState) {
    Widget column = Column(
      mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(loadingCount, (index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Shimmer.fromColors(
              baseColor: Theme.of(context).colorScheme.surfaceContainer,
              highlightColor:
                  Theme.of(context).colorScheme.surfaceContainerHigh,
              child: Container(
                width: 100,
                height: 50,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(10)),
                child: SizedBox.expand(),
              )),
        );
      }),
    );

    return column;
  }

  return SizedBox.shrink();
}
