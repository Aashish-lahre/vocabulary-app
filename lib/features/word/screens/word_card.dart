import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_improve_vocabulary/core/theme/color_theme.dart';
import 'package:flutter_improve_vocabulary/core/theme/cubit/theme_cubit.dart';
import 'package:flutter_improve_vocabulary/features/word/screens/word_details_screen.dart';
import 'package:gap/gap.dart';

import '../../dictionary/models/definition.dart';
import '../../dictionary/models/meaning.dart';
import '../../dictionary/models/word.dart';
import '../../gemini_ai/bloc/gemini_bloc.dart';

class WordCard extends StatelessWidget {
  final Word word;

  const WordCard({required this.word, super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: BlocProvider.of<GeminiBloc>(context),
              child: WordDetailsScreen(word: word),
            ),
          ),
        );
      },
      child: BlocBuilder<ThemeCubit, ThemeType>(
  builder: (context, state) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: colorScheme.primaryContainer,
          gradient: themes[state]!.containerGradient,

        boxShadow: [
            BoxShadow(
                offset: Offset(0, 4),
                blurRadius: 8,
                spreadRadius: 3,
                color: Color(0x40000000)),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(50),
              // wordName and volume icon
              Wrap(
                // mainAxisAlignment: MainAxisAlignment.start,

                alignment: WrapAlignment.start,

                spacing: 20,
                children: [
                  Gap(10),
                  Text(word.word,
                      style: textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimaryContainer)),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.volume_up_rounded,
                        color: colorScheme.onPrimaryContainer,
                      )),
                ],
              ),
              Gap(20),

              // banner container
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: colorScheme.secondary,
                ),
                padding: EdgeInsets.all(8),
                child: Row(
                  spacing: 30,
                  children: [
                    Icon(
                      Icons.arrow_downward_rounded,
                      color: colorScheme.onSecondary,
                    ),
                    Text(
                      'Chose Definition to learn.',
                      style: textTheme.bodyMedium
                          ?.copyWith(color: colorScheme.onSecondary),
                    ),
                  ],
                ),
              ),

              // Noun and Verb definitions....
              ...List.generate(word.meanings.length, (index) {
                return Definitions(meaning: word.meanings[index]);
              }),
            ],
          ),
        ),
      );
  },
),
    );
  }
}

Widget _buildDefinitionContainer(BuildContext context, Definition definition) {
  final textTheme = Theme.of(context).textTheme;
  final colorScheme = Theme.of(context).colorScheme;
  return BlocBuilder<ThemeCubit, ThemeType>(
  builder: (context, state) {
    return Container(
    padding: EdgeInsets.all(8),
    margin: EdgeInsets.all(8),
    // alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.primaryFixedDim,
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
      style: textTheme.bodyMedium?.copyWith(color: colorScheme.onPrimaryFixed),
    ),
  );
  },
);
}

class Definitions extends StatelessWidget {
  const Definitions({required this.meaning, super.key});

  final Meaning meaning;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            meaning.partOfSpeech,
            style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onPrimaryContainer),
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: meaning.definitions.length,
              itemBuilder: (_, index) {
                return _buildDefinitionContainer(
                    context, meaning.definitions[index]);
              }),
        ],
      ),
    );
  }
}
