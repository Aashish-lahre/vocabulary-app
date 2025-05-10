import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_improve_vocabulary/core/utility/syno_anto_shimmer.dart';

import '../../../features/gemini_ai/word/bloc/gemini_bloc.dart';
import '../../models/word.dart';
import '../../utility/above_banner.dart';

class AntonymsWidget extends StatefulWidget {

  final Word word;

  const AntonymsWidget({required this.word, super.key});

  @override
  State<AntonymsWidget> createState() => _AntonymsWidgetState();
}

class _AntonymsWidgetState extends State<AntonymsWidget>{
  late Word word;
  late bool generateMoreWithAi;
  int antonymsLimit = 4;

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
    generateMoreWithAi = word.antonyms.length < antonymsLimit ;

    return BlocConsumer<GeminiBloc, GeminiState>(
      listener: (context, state) {
        if(state is GeminiInvalidApiKeyState) {
          String message = 'Cannot Generate Antonyms with Invalid API Key.';
                            ContentType contentType = ContentType.failure;

                            showOverlayBanner(context,
                                message: message, contentType: contentType);
        }
      },
      listenWhen: (_, currentState) {
        return [GeminiInvalidApiKeyState].contains(currentState.runtimeType);
      },
      buildWhen: (_, currentState) {
        return [AntonymsLoadedState, AntonymsLoadingState, GeminiInvalidApiKeyState].contains(currentState.runtimeType);
      },
      builder: (context, state) {
        if(state is AntonymsLoadingState) {
          generateMoreWithAi = false;
        }

        if(state is AntonymsLoadedState) {
          generateMoreWithAi = word.antonyms.length < antonymsLimit;
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
                  ...List.generate(word.antonyms.length, (index) {
                    return ElevatedButton(
                        onPressed: () {}, child: Text(word.antonyms[index]));
                  }),

                  buildSynonymsAntonymsShimmer(context, state, antonymsLimit - word.antonyms.length),


                  if (generateMoreWithAi)
                    ElevatedButton(
                      style: ButtonStyle(shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))),
                      onPressed: () {
                        context.read<GeminiBloc>().add(LoadAntonymsEvent(word: word, limit: (antonymsLimit - word.antonyms.length), filterOut: word.antonyms));


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