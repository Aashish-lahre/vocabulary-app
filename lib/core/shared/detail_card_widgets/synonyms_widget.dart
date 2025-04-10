import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_improve_vocabulary/core/utility/syno_anto_shimmer.dart';

import '../../../features/gemini_ai/bloc/gemini_bloc.dart';
import '../../utility/base_class.dart';

class SynonymsWidget extends StatefulWidget {
  final List<String> synonyms;
  final BaseWord word;

  const SynonymsWidget({required this.synonyms, required this.word, super.key});

  @override
  State<SynonymsWidget> createState() => _SynonymsWidgetState();
}

class _SynonymsWidgetState extends State<SynonymsWidget> {
  late bool generateMoreWithAi;
  int synonymsLimit = 4;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme
        .of(context)
        .textTheme;
    final colorScheme = Theme
        .of(context)
        .colorScheme;

    generateMoreWithAi = widget.synonyms.length < synonymsLimit ;

    return BlocBuilder<GeminiBloc, GeminiState>(
      buildWhen: (_, currentState) {
        return [SynonymsLoadedState, SynonymsLoadingState].contains(currentState.runtimeType);
      },
      builder: (context, state) {
        if(state is SynonymsLoadingState) {
          generateMoreWithAi = false;
        }

        if(state is SynonymsLoadedState) {
          generateMoreWithAi = (widget.synonyms.length + state.synonyms.length) < synonymsLimit;
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            spacing: 20,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // "Synonyms" text
              Text(
                'Synonyms :',
                style: textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w900, color: colorScheme.onSurface),
              ),
              Wrap(
                spacing: 20,
                alignment: WrapAlignment.start,
                children: [
                  ...List.generate(widget.synonyms.length, (index) {
                    return ElevatedButton(
                        onPressed: () {}, child: Text(widget.synonyms[index]));
                  }),

                  buildSynonymsAntonymsShimmer(context, state, synonymsLimit - widget.synonyms.length),

                  if (generateMoreWithAi)
                    ElevatedButton(
                      style: ButtonStyle(shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))),
                      onPressed: () => context.read<GeminiBloc>().add(LoadSynonymsEvent(word: widget.word, limit: (synonymsLimit - widget.synonyms.length), filterOut: widget.synonyms)),
                      child: Text(
                        'Generate with AI',
                        style: textTheme.bodyMedium!
                            .copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                    ),
                ],
              ),


            ],
          ),
        );
      },
    );
  }


}