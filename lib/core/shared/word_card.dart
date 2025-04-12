
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_improve_vocabulary/core/shared/detail_card_widgets/banner_widget.dart';
import 'package:flutter_improve_vocabulary/features/gemini_ai/bloc/gemini_bloc.dart';
import 'package:flutter_improve_vocabulary/core/screens/word_details_screen.dart';
import 'package:gap/gap.dart';

import '../models/word.dart';
import '../theme/color_theme.dart';
import '../theme/cubit/theme_cubit.dart';


class WordCard extends StatelessWidget {
  final Word word;
  final String bannerName;
  const WordCard({required this.word, required this.bannerName, super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return BlocProvider.value(
            value: BlocProvider.of<GeminiBloc>(context),
            child: WordDetailsScreen(word: word, bannerName: bannerName,),
          );
        },),);
      },
      child: BlocBuilder<ThemeCubit, ThemeType>(
  builder: (context, state) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: colorScheme.primaryContainer,
          gradient: themes[state]!.containerGradient,
          boxShadow: [
            BoxShadow(offset: Offset(0, 4), blurRadius: 8, spreadRadius: 3, color: Color(0x40000000)),
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
                  Text(word.wordName, style: textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onPrimaryContainer)),
      
                  IconButton(onPressed: () {}, icon: Icon(Icons.volume_up_rounded, color: colorScheme.onPrimaryContainer,)),
                ],
              ),
              Gap(20),
      
              // black banner container
              BannerWidget(type:bannerName),
      
            // list all the partOfSpeech
              Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      word.partsOfSpeech.join(', '), // Join list items with a comma
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
      
              ...List.generate(word.definitions.length, (index) => _buildDefinitionContainer(context, word.definitions[index]))
      
            ],
          ),
        ),
      );
  },
),
    );
  }
}

Widget _buildDefinitionContainer(BuildContext context, String definition) {
  final textTheme = Theme.of(context).textTheme;
  final colorScheme = Theme.of(context).colorScheme;
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
          offset: Offset(0,1),

        )
      ],
    ),
    child: Text(definition, style: textTheme.bodyMedium?.copyWith(color: colorScheme.onPrimaryFixed
    ),),
  );
}




