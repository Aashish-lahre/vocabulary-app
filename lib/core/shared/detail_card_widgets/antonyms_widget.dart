import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_improve_vocabulary/core/utility/syno_anto_shimmer.dart';

import '../../../features/gemini_ai/bloc/gemini_bloc.dart';
import '../../utility/base_class.dart';

class AntonymsWidget extends StatefulWidget {
  final List<String> antonyms;
  final BaseWord word;

  const AntonymsWidget({required this.antonyms, required this.word, super.key});

  @override
  State<AntonymsWidget> createState() => _AntonymsWidgetState();
}

class _AntonymsWidgetState extends State<AntonymsWidget>{
  late bool generateMoreWithAi;
  int antonymsLimit = 4;



  @override
  Widget build(BuildContext context) {
    final textTheme = Theme
        .of(context)
        .textTheme;
    final colorScheme = Theme
        .of(context)
        .colorScheme;
    generateMoreWithAi = widget.antonyms.length < antonymsLimit ;

    return BlocBuilder<GeminiBloc, GeminiState>(
      buildWhen: (_, currentState) {
        return [AntonymsLoadedState, AntonymsLoadingState].contains(currentState.runtimeType);
      },
      builder: (context, state) {
        if(state is AntonymsLoadingState) {
          generateMoreWithAi = false;
        }

        if(state is AntonymsLoadedState) {
          generateMoreWithAi = (widget.antonyms.length + state.antonyms.length) < antonymsLimit;
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            spacing: 20,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // "antonyms" text
              Text(
                'Antonyms :',
                style: textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w900, color: colorScheme.onSurface),
              ),

              // All antonyms
              Wrap(
                spacing: 20,
                alignment: WrapAlignment.start,
                children: [
                  ...List.generate(widget.antonyms.length, (index) {
                    return ElevatedButton(
                        onPressed: () {}, child: Text(widget.antonyms[index]));
                  }),

                  buildSynonymsAntonymsShimmer(context, state, antonymsLimit - widget.antonyms.length),


                  if (generateMoreWithAi)
                    ElevatedButton(
                      style: ButtonStyle(shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))),
                      onPressed: () {
                        context.read<GeminiBloc>().add(LoadAntonymsEvent(word: widget.word, limit: (antonymsLimit - widget.antonyms.length), filterOut: widget.antonyms));


                      },
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