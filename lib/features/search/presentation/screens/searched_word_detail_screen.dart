import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_improve_vocabulary/core/utility/syno_anto_shimmer.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/models/word.dart';
import '../../../../core/shared/detail_card_widgets/detail_card_widgets.dart' show TitleWidget, BannerWidget, DefinitionWidget;
import '../../../gemini_ai/bloc/gemini_bloc.dart';


class SearchedWordDetailScreen extends StatefulWidget {
  final Word word;
  const SearchedWordDetailScreen({required this.word, super.key});

  @override
  State<SearchedWordDetailScreen> createState() => _SearchedWordDetailScreenState();
}

class _SearchedWordDetailScreenState extends State<SearchedWordDetailScreen> {
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
            TitleWidget(wordName: widget.word.wordName),

            BannerWidget(type: 'Word from AI'),

            DefinitionWidget(definitions: widget.word.definitions),

            _buildSynonyms(context, widget.word.synonyms, widget.word),

            _buildAntonyms(context, widget.word.antonyms, widget.word),


            _buildExample(context, widget.word, widget.word.examples),



          ],
        ),
      ),
    );
  }
}



Widget _buildSynonyms(BuildContext context, List<String> synonyms, Word word) {
  late bool generateMoreWithAi;
  int synonymsLimit = 4;
  final textTheme = Theme
      .of(context)
      .textTheme;
  final colorScheme = Theme
      .of(context)
      .colorScheme;
  generateMoreWithAi = synonyms.length < synonymsLimit ;
  return BlocBuilder<GeminiBloc, GeminiState>(
      buildWhen: (_, currentState) {
        return [SynonymsLoadedState, SynonymsLoadingState].contains(currentState.runtimeType);
      },
      builder: (context, state) {
        if(state is SynonymsLoadingState) {
          generateMoreWithAi = false;
        }

        if(state is SynonymsLoadedState) {
          generateMoreWithAi = (synonyms.length + state.synonyms.length) < synonymsLimit;
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            spacing: 20,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // "synonyms" text
              Text(
                'Synonyms :',
                style: textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w900, color: colorScheme.onSurface),
              ),

              // All synonyms
              buildSynonymsSwitchWidget(context, word, synonymsLimit, state, synonyms),


              if (generateMoreWithAi)
                ElevatedButton(
                  style: ButtonStyle(shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))),
                  onPressed: () {
                    print('limit : ${(synonymsLimit - synonyms.length)}');
                    context.read<GeminiBloc>().add(LoadSynonymsEvent(word: word, limit: (synonymsLimit - synonyms.length), filterOut: synonyms));

                  },
                  child: Text(
                    'Generate with AI',
                    style: textTheme.bodyMedium!
                        .copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ),
            ],
          ),
        );
      }

  );
}

Widget buildSynonymsSwitchWidget(BuildContext context, Word word, int synonymsLimit, GeminiState state, List<String> synonyms) {
  switch(state) {

    case AiWordSearchCompleteState _ :
      return Wrap(
        spacing: 20,
        alignment: WrapAlignment.start,
        children: List.generate(synonyms.length, (index) {
          return ElevatedButton(
              onPressed: () {}, child: Text(synonyms[index]));
        }),
      );



    case SynonymsLoadingState _ :
      return Wrap(
        spacing: 20,
        alignment: WrapAlignment.start,
        children: [
          ...List.generate(synonyms.length, (index) {
            return ElevatedButton(
                onPressed: () {}, child: Text(synonyms[index]));
          }),


          buildSynonymsAntonymsShimmer(context, state, (synonymsLimit - synonyms.length)),
        ],
      );





    case SynonymsLoadedState _ :

      return Wrap(
        spacing: 20,
        alignment: WrapAlignment.start,
        children: List.generate((word.synonyms.length), (index) {
          print('synonyms count : $index');
          return ElevatedButton(
              onPressed: () {}, child: Text(word.synonyms[index]));
        }),
      );







    default : return SizedBox.shrink();
  }
}







Widget _buildAntonyms(BuildContext context, List<String> antonyms, Word word) {
  late bool generateMoreWithAi;
  int antonymsLimit = 4;
  final textTheme = Theme
      .of(context)
      .textTheme;
  final colorScheme = Theme
      .of(context)
      .colorScheme;
  generateMoreWithAi = antonyms.length < antonymsLimit ;
  return BlocBuilder<GeminiBloc, GeminiState>(
      buildWhen: (_, currentState) {
        return [AntonymsLoadedState, AntonymsLoadingState].contains(currentState.runtimeType);
      },
      builder: (context, state) {
        if(state is AntonymsLoadingState) {
          generateMoreWithAi = false;
        }

        if(state is AntonymsLoadedState) {
          generateMoreWithAi = (antonyms.length + state.antonyms.length) < antonymsLimit;
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
              buildAntonymsSwitchWidget(context, word, antonymsLimit, state, antonyms),


              if (generateMoreWithAi)
                ElevatedButton(
                  style: ButtonStyle(shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))),
                  onPressed: () {
                    context.read<GeminiBloc>().add(LoadAntonymsEvent(word: word, limit: (antonymsLimit - antonyms.length), filterOut: antonyms));


                  },
                  child: Text(
                    'Generate with AI',
                    style: textTheme.bodyMedium!
                        .copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ),
            ],
          ),
        );
      }

  );
}


Widget buildAntonymsSwitchWidget(BuildContext context, Word word, int antonymsLimit, GeminiState state, List<String> antonyms) {
  switch(state) {

    case AiWordSearchCompleteState _ :
      return Wrap(
      spacing: 20,
      alignment: WrapAlignment.start,
      children: List.generate(antonyms.length, (index) {
        return ElevatedButton(
            onPressed: () {}, child: Text(antonyms[index]));
      }),
    );


    case AntonymsLoadingState _ :
      return Wrap(
      spacing: 20,
      alignment: WrapAlignment.start,
      children: [
        ...List.generate(antonyms.length, (index) {
          return ElevatedButton(
              onPressed: () {}, child: Text(antonyms[index]));
        }),


        buildSynonymsAntonymsShimmer(context, state, (antonymsLimit - antonyms.length)),



      ],
    );





    case AntonymsLoadedState _ :

      return Wrap(
      spacing: 20,
      alignment: WrapAlignment.start,
      children: List.generate((word.antonyms.length), (index) {
        return ElevatedButton(
            onPressed: () {}, child: Text(word.antonyms[index]));
      }),
    );







    default : return SizedBox.shrink();
  }
}









Widget _buildExample(BuildContext context, Word word, List<String> examples) {
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
            return buildExampleSwitchWidget(
              context, state, word, examples,
            );

          },

        ),
        GestureDetector(
          onTap: () => context.read<GeminiBloc>().add(LoadExamplesEvent(word: word, limit: 3, filterOut: word.examples)),
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


Widget buildExampleSwitchWidget(BuildContext context, GeminiState state, Word word, List<String> examples) {
  final textTheme = Theme
      .of(context)
      .textTheme;
  final colorScheme = Theme
      .of(context)
      .colorScheme;
  switch (state) {
    case ExamplesLoadedState _ :
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: List.generate(word.examples.length, (index) {
          return _buildExampleContainer(context, word.examples[index]);
        }),
      );
    case AiWordSearchCompleteState _ :
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: List.generate(examples.length, (index) {
          return _buildExampleContainer(context, examples[index]);
        }),
      );

    case ExamplesLoadingState _ :
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          // ...List.generate(examples.length, (index) {
          //   return _buildExampleContainer(context, examples[index]);
          // }),
          ...List.generate(word.examples.length, (index) {
            return _buildExampleContainer(context, word.examples[index]);
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