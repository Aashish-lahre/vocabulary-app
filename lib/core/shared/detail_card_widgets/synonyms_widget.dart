import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_improve_vocabulary/core/utility/syno_anto_shimmer.dart';

import '../../../features/gemini_ai/bloc/gemini_bloc.dart';
import '../../models/word.dart';
import '../../utility/above_banner.dart';

class SynonymsWidget extends StatefulWidget {

  final Word word;

  const SynonymsWidget({required this.word, super.key});

  @override
  State<SynonymsWidget> createState() => _SynonymsWidgetState();
}

class _SynonymsWidgetState extends State<SynonymsWidget> {
  late Word word;
  late bool generateMoreWithAi;
  int synonymsLimit = 4;

  @override
  void initState() {
    word = widget.word;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    final textTheme = Theme
        .of(context)
        .textTheme;
    final colorScheme = Theme
        .of(context)
        .colorScheme;

    generateMoreWithAi = word.synonyms.length < synonymsLimit ;

    return BlocConsumer<GeminiBloc, GeminiState>(
      listener: (context, state) {
        if(state is GeminiInvalidApiKeyState) {
          String message = 'Cannot Generate Synonyms with Invalid API Key.';
                            ContentType contentType = ContentType.failure;

                            showOverlayBanner(context,
                                message: message, contentType: contentType);
        }
      },
      listenWhen: (_, currentState) {
        return [GeminiInvalidApiKeyState].contains(currentState.runtimeType);
      },
      buildWhen: (_, currentState) {
        return [SynonymsLoadedState, SynonymsLoadingState, GeminiInvalidApiKeyState].contains(currentState.runtimeType);
      },
      builder: (context, state) {
        if(state is SynonymsLoadingState) {
          generateMoreWithAi = false;
        }

        if(state is SynonymsLoadedState) {
          generateMoreWithAi = word.synonyms.length < synonymsLimit;
        }
        if(state is GeminiInvalidApiKeyState) {
         generateMoreWithAi = false;
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
                  ...List.generate(word.synonyms.length, (index) {
                    return ElevatedButton(
                        onPressed: () {}, child: Text(word.synonyms[index]));
                  }),

                  buildSynonymsAntonymsShimmer(context, state, synonymsLimit - word.synonyms.length),

                  if (generateMoreWithAi)
                    ElevatedButton(
                      style: ButtonStyle(shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))),
                      onPressed: () => context.read<GeminiBloc>().add(LoadSynonymsEvent(word: word, limit: (synonymsLimit - word.synonyms.length), filterOut: word.synonyms)),
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