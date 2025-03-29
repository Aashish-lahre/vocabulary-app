
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dictionary_api/dictionary_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_improve_vocabulary/features/homeScreen/presentation/widgets/fading_typerwriter_text.dart';
import 'package:gap/gap.dart';

class WordCard extends StatelessWidget {
  final Word word;
  const WordCard({required this.word, super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
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
                // AnimatedTextKit(
                //     isRepeatingAnimation: false,
                //     displayFullTextOnTap: true,
                //
                //     animatedTexts: [
                //
                //       TyperAnimatedText(word.word, textStyle: textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                //     ],
                // ),
                Text(word.word, style: textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),

                IconButton(onPressed: () {}, icon: Icon(Icons.volume_up_rounded, color: colorScheme.onSurface,)),
              ],
            ),
            Gap(20),

            // black banner container
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: colorScheme.primary,
              ),
              padding: EdgeInsets.all(8),
              child: Row(
                spacing: 30,
                children: [
                  Icon(Icons.arrow_downward_rounded, color: colorScheme.onPrimary,),
                  Text('Chose Definition to learn.', style: textTheme.bodyMedium?.copyWith(color: colorScheme.onPrimary),),
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
  }
}

Widget _buildDefinitionContainer(BuildContext context, Definition definition) {
  final textTheme = Theme.of(context).textTheme;
  final colorScheme = Theme.of(context).colorScheme;
  return Container(
    padding: EdgeInsets.all(8),
    margin: EdgeInsets.all(8),
    // alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.primaryContainer,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Color(0x40000000),
          blurRadius: 2,
          offset: Offset(0,1),

        )
      ],
    ),
    child: Text(definition.definition, style: textTheme.bodyMedium?.copyWith(color: colorScheme.onPrimaryContainer),),
  );
}

class Definitions extends StatelessWidget {
   Definitions({required this.meaning, super.key});

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
          Text(meaning.partOfSpeech, style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface),),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: meaning.definitions.length,
              itemBuilder: (_, index) {
                return _buildDefinitionContainer(context, meaning.definitions[index]);
              }),
        ],
      ),
    );
  }
  

}


