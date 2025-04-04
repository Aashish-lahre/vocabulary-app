import 'package:better_skeleton/better_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_improve_vocabulary/features/gemini_ai/bloc/gemini_bloc.dart';
import 'package:flutter_improve_vocabulary/features/gemini_ai/data_model/ai_word.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';


class AiWordDetailsScreen extends StatefulWidget {
  final AiWord word;

  const AiWordDetailsScreen({required this.word, super.key});

  @override
  State<AiWordDetailsScreen> createState() => _AiWordDetailsScreenState();
}

class _AiWordDetailsScreenState extends State<AiWordDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          spacing: 30,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Gap(50),
            // WordName and definition
            AiTitleWidget(wordName: widget.word.wordName),

            AiBannerWidget(),

            AiDefinitionWidget(definitions: widget.word.definition),

            AiSynonymsWidget(synonyms: widget.word.synonyms, wordName: widget.word.wordName,),


            AiAntonymsWidget(antonyms: widget.word.antonyms, wordName: widget.word.wordName,),


            AiExampleWidget(wordName: widget.word.wordName, examples: widget.word.example,)

          ],
        ),
      ),
    );
  }
}

class AiTitleWidget extends StatelessWidget {
  final String wordName;

  const AiTitleWidget({required this.wordName, super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme
        .of(context)
        .textTheme;
    final colorScheme = Theme
        .of(context)
        .colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(wordName,
              style: textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold, color: colorScheme.onSurface))
        ],
      ),
    );
  }
}

class AiBannerWidget extends StatelessWidget {
  final String type;

  const AiBannerWidget({this.type = 'Word from AI', super.key});

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
      height: 50,
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
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

class AiDefinitionWidget extends StatelessWidget {
  const AiDefinitionWidget({required this.definitions, super.key});

  final List<String> definitions;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme
        .of(context)
        .textTheme;
    final colorScheme = Theme
        .of(context)
        .colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 20,
        children: [
          // "Definitions :" text
          Text(
            'Definitions :',
            style: textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w900, color: colorScheme.onSurface),
          ),
          ...List.generate(definitions.length, (index) {
            return _buildAiDefinitionContainer(context, definitions[index]);
          }),
        ],
      ),
    );
  }

  Widget _buildAiDefinitionContainer(BuildContext context,
      String definition) {
    final textTheme = Theme
        .of(context)
        .textTheme;
    final colorScheme = Theme
        .of(context)
        .colorScheme;
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(8),
      // alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme
            .of(context)
            .colorScheme
            .primaryFixedDim,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: Text(
        definition,
        style:
        textTheme.bodyMedium?.copyWith(color: colorScheme.onPrimaryFixed),
      ),
    );
  }
}

class AiSynonymsWidget extends StatefulWidget {
  final List<String> synonyms;
  final String wordName;

  const AiSynonymsWidget({required this.synonyms, required this.wordName, super.key});

  @override
  State<AiSynonymsWidget> createState() => _AiSynonymsWidgetState();
}

class _AiSynonymsWidgetState extends State<AiSynonymsWidget> {
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
    return BlocBuilder<GeminiBloc, GeminiState>(
  buildWhen: (_, currentState) {
    return [SynonymsLoadedState, SynonymsLoadingState].contains(currentState.runtimeType);
  },
  builder: (context, state) {
    generateMoreWithAi = ((widget.synonyms.length + context.read<GeminiBloc>().synonyms.length) <= 3) && state is! SynonymsLoadingState;
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

              _buildSynonymsFromAi(state, synonymsLimit - widget.synonyms.length),

              if (generateMoreWithAi)
                ElevatedButton(
                  style: ButtonStyle(shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))),
                  onPressed: () => context.read<GeminiBloc>().add(LoadSynonymsEvent(word: widget.wordName, limit: (synonymsLimit - widget.synonyms.length), filterOut: widget.synonyms)),
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


  Widget _buildSynonymsFromAi(GeminiState state, int loadingCount) {
    if(state.runtimeType == SynonymsLoadingState) {

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(loadingCount, (index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Shimmer.fromColors(
                baseColor: Theme.of(context).colorScheme.surfaceContainer,
                highlightColor: Theme.of(context).colorScheme.surfaceContainerHigh,
                child: Container(width: 100, height: 50,  decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainer, borderRadius: BorderRadius.circular(10)),)),
          );

        }),

      );
    }
    if(state is SynonymsLoadedState) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(state.synonyms.length, (index) {
          return ElevatedButton(onPressed: () {}, child: Text(state.synonyms[index]));

        }),

      );
    }

    return SizedBox.shrink();

  }
}


class AiAntonymsWidget extends StatefulWidget {
  final List<String> antonyms;
  final String wordName;

  const AiAntonymsWidget({required this.antonyms, required this.wordName, super.key});

  @override
  State<AiAntonymsWidget> createState() => _AiAntonymsWidgetState();
}

class _AiAntonymsWidgetState extends State<AiAntonymsWidget>{
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
    return BlocBuilder<GeminiBloc, GeminiState>(
      buildWhen: (_, currentState) {
        return [AntonymsLoadedState, AntonymsLoadingState].contains(currentState.runtimeType);
      },
  builder: (context, state) {
    generateMoreWithAi = ((widget.antonyms.length + context.read<GeminiBloc>().antonyms.length) <= 3) && state is! AntonymsLoadingState;

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

              _buildAntonymsFromAi(state, antonymsLimit - widget.antonyms.length),

              if (generateMoreWithAi)
                ElevatedButton(
                  style: ButtonStyle(shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))),
                  onPressed: () => context.read<GeminiBloc>().add(LoadAntonymsEvent(word: widget.wordName, limit: (antonymsLimit - widget.antonyms.length), filterOut: widget.antonyms)),
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

  Widget _buildAntonymsFromAi(GeminiState state, int loadingCount) {
    if(state.runtimeType == AntonymsLoadingState) {

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(loadingCount, (index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Shimmer.fromColors(
                baseColor: Theme.of(context).colorScheme.surfaceContainer,
                highlightColor: Theme.of(context).colorScheme.surfaceContainerHigh,
                child: Container(width: 100, height: 50,  decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainer, borderRadius: BorderRadius.circular(10)),)),
          );

        }),

      );
    }
    if(state is AntonymsLoadedState) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(state.antonyms.length, (index) {
          return ElevatedButton(onPressed: () {}, child: Text(state.antonyms[index]));

        }),

      );
    }

    return SizedBox.shrink();

  }
}


class AiExampleWidget extends StatefulWidget {
  final String wordName;
  final List<String> examples;
  const AiExampleWidget({required this.wordName, required this.examples, super.key});

  @override
  State<AiExampleWidget> createState() => _AiExampleWidgetState();
}

class _AiExampleWidgetState extends State<AiExampleWidget> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme
        .of(context)
        .textTheme;
    final colorScheme = Theme
        .of(context)
        .colorScheme;
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Column(
        spacing: 20,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // "Examples :" text
          Text(
            'Examples :',
            style: textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w900, color: colorScheme.onSurface),
          ),

          ...List.generate(widget.examples.length, (index) {
            return _buildExampleContainer(context, widget.examples[index]);
    }),


          BlocConsumer<GeminiBloc, GeminiState>(
            listenWhen: (previousState, currentState) {
              return [GeminiFailureState].contains(currentState.runtimeType);
            },
            listener:(context, state) {},
            buildWhen: (previousState, currentState) {
              return [ExamplesLoadedState, ExamplesLoadingState, GeminiFailureState].contains(currentState.runtimeType);
            },
            builder:(context, state) {
              switch (state) {
                case ExamplesLoadedState _ :
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(context.read<GeminiBloc>().examples.length, (index) {
                      return _buildExampleContainer(context, context.read<GeminiBloc>().examples[index]);
                    }),
                  );

                case ExamplesLoadingState _ :
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 10,
                    children: [
                      ...List.generate(context.read<GeminiBloc>().examples.length, (index) {
                        return _buildExampleContainer(context, context.read<GeminiBloc>().examples[index]);
                      }),


                      ...List.generate(3, (index) {
                        return Shimmer.fromColors(
                            baseColor: Theme.of(context).colorScheme.surfaceContainer,
                            highlightColor: Theme.of(context).colorScheme.surfaceContainerHigh,
                            child: Container(width: double.infinity, height: 30, decoration: BoxDecoration(color: colorScheme.surfaceContainer, borderRadius: BorderRadius.circular(10)),));
                      }),
                    ],
                  );
                case GeminiFailureState _ :
                  return SizedBox(
                    width: double.infinity,
                    height: 100,
                    child: Text(state.errorMessage, style: textTheme.bodyLarge!.copyWith(color: colorScheme.onSurface),),
                  );
                default :
                  return SizedBox();
              }
            },

          ),
          GestureDetector(
            onTap: () => context.read<GeminiBloc>().add(LoadExamplesEvent(wordName: widget.wordName, limit: 3, filterOut: context.read<GeminiBloc>().examples)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: colorScheme.primaryContainer,
              ),
              padding: EdgeInsets.all(8),
              child: Text('Generate examples with AI',
                style: textTheme.bodyMedium!.copyWith(
                    color: colorScheme.onPrimaryContainer),),
            ),
          ),
        ],
      ),

    );
  }

  Widget _buildExampleContainer(BuildContext context,
      String example,) {
    final textTheme = Theme
        .of(context)
        .textTheme;
    final colorScheme = Theme
        .of(context)
        .colorScheme;
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(8),
      // alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme
            .of(context)
            .colorScheme
            .surfaceContainer,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: Text(
        example,
        style:
        textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
      ),
    );
  }
}

