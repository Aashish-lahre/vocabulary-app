import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_improve_vocabulary/features/dictionary/models/meaning.dart';
import 'package:flutter_improve_vocabulary/features/gemini_ai/bloc/gemini_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

import '../../dictionary/models/definition.dart';
import '../../dictionary/models/word.dart';

class WordDetailsScreen extends StatefulWidget {
  final Word word;

  const WordDetailsScreen({required this.word, super.key});

  @override
  State<WordDetailsScreen> createState() => _WordDetailsScreenState();
}

class _WordDetailsScreenState extends State<WordDetailsScreen> {
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
            TitleWidget(wordName: widget.word.word),

            BannerWidget(),

            DefinitionWidget(meanings: widget.word.meanings),

            SynonymsWidget(wordName: widget.word.word, synonyms: widget.word.meanings.first.synonyms),


            AntonymsWidget(wordName: widget.word.word, antonyms: widget.word.meanings.first.antonyms),


            ExampleWidget(wordName: widget.word.word)

          ],
        ),
      ),
    );
  }
}

class TitleWidget extends StatelessWidget {
  final String wordName;

  const TitleWidget({required this.wordName, super.key});

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

class BannerWidget extends StatelessWidget {
  final String type;

  const BannerWidget({this.type = 'Word from API', super.key});

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
        padding: const EdgeInsets.symmetric(horizontal:20.0),
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

class DefinitionWidget extends StatelessWidget {
  const DefinitionWidget({required this.meanings, super.key});

  final List<Meaning> meanings;


  @override
  Widget build(BuildContext context) {
    final textTheme = Theme
        .of(context)
        .textTheme;
    final colorScheme = Theme
        .of(context)
        .colorScheme;
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 20,
        children: List.generate(meanings.length, (indexForMeaning) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            // spacing: 20,
            children: [
              Text(
                meanings[indexForMeaning].partOfSpeech,
                style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimaryContainer),
              ),



              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: meanings[indexForMeaning].definitions.length,
                  itemBuilder: (_, indexForDefinition) {
                    return _buildDefinitionContainer(
                        context, meanings[indexForMeaning].definitions[indexForDefinition]);
                  }),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildDefinitionContainer(BuildContext context,
      Definition definition) {
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
        definition.definition,
        style:
        textTheme.bodyMedium?.copyWith(color: colorScheme.onPrimaryFixed),
      ),
    );
  }
}

class SynonymsWidget extends StatefulWidget {
  final List<String> synonyms;
  final String wordName;

  const SynonymsWidget({required this.synonyms, required this.wordName, super.key});

  @override
  State<SynonymsWidget> createState() => _SynonymsWidgetState();
}

class _SynonymsWidgetState extends State<SynonymsWidget> with SingleTickerProviderStateMixin {
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
        generateMoreWithAi = ((widget.synonyms.length + context.read<GeminiBloc>().synonyms.length) <= 3) && state is! SynonymsLoadedState;
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


                  if(state is! GeminiFailureState)
                  if (generateMoreWithAi)
                    ElevatedButton(
                      style: ButtonStyle(shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))),
                      onPressed: () {
                        context.read<GeminiBloc>().add(LoadSynonymsEvent(word: widget.wordName, limit: (synonymsLimit - widget.synonyms.length), filterOut: widget.synonyms));

                      setState(() {
                        generateMoreWithAi = false;
                      });

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


  Widget _buildSynonymsFromAi(GeminiState state, int loadingCount) {
    if(state.runtimeType == SynonymsLoadingState) {

      return Column(
        mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(loadingCount, (index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Shimmer.fromColors(
                baseColor: Theme.of(context).colorScheme.surfaceContainer,
                highlightColor: Theme.of(context).colorScheme.surfaceContainerHigh,
                child: Container(width: 100, height: 30,  decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainer, borderRadius: BorderRadius.circular(10)), child: SizedBox.expand(),)),
          );

        }),

      );
    }
    if(state is SynonymsLoadedState) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(context.read<GeminiBloc>().synonyms.length, (index) {
          return ElevatedButton(onPressed: () {}, child: Text(context.read<GeminiBloc>().synonyms[index]));

        }),

      );
    }

    if(state is GeminiFailureState) {
      return Text(state.errorMessage, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onSurface),);
    }

    return SizedBox.shrink();

  }
}

class AntonymsWidget extends StatefulWidget {
  final List<String> antonyms;
  final String wordName;

  const AntonymsWidget({required this.antonyms, required this.wordName, super.key});

  @override
  State<AntonymsWidget> createState() => _AntonymsWidgetState();
}

class _AntonymsWidgetState extends State<AntonymsWidget> with SingleTickerProviderStateMixin{
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
        generateMoreWithAi = ((widget.antonyms.length + context.read<GeminiBloc>().antonyms.length) <= 3) && state is! AntonymsLoadingState ;

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

                  if(state is! GeminiFailureState)
                  if (generateMoreWithAi)
                    ElevatedButton(
                      style: ButtonStyle(shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))),
                      onPressed: () {
                        context.read<GeminiBloc>().add(LoadAntonymsEvent(word: widget.wordName, limit: (antonymsLimit - widget.antonyms.length), filterOut: widget.antonyms));


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

  Widget _buildAntonymsFromAi(GeminiState state, int loadingCount) {
    if(state.runtimeType == AntonymsLoadingState) {

      Widget column =  Column(
        mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(loadingCount, (index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Shimmer.fromColors(
                baseColor: Theme.of(context).colorScheme.surfaceContainer,
                highlightColor: Theme.of(context).colorScheme.surfaceContainerHigh,
                child: Container(width: 100, height: 50,  decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainer, borderRadius: BorderRadius.circular(10)), child: SizedBox.expand(),)),
          );

        }),

      );

      return column;


    }
    if(state is AntonymsLoadedState) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(context.read<GeminiBloc>().antonyms.length, (index) {
          return ElevatedButton(onPressed: () {}, child: Text(context.read<GeminiBloc>().antonyms[index]));

        }),

      );
    }

    if(state is GeminiFailureState) {
      return Text(state.errorMessage, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onSurface),);
    }

    return SizedBox.shrink();

  }
}


class ExampleWidget extends StatefulWidget {
final String wordName;
  const ExampleWidget({required this.wordName, super.key});

  @override
  State<ExampleWidget> createState() => _ExampleWidgetState();
}

class _ExampleWidgetState extends State<ExampleWidget> with SingleTickerProviderStateMixin{

  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 800))..forward()..repeat();
    super.initState();
  }

  @override
  void dispose() {
    debugPrint('dispose called in synonyms widget');
    _animationController..stop()..dispose();
    super.dispose();
  }


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

