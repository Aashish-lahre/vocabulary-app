import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../core/shared/detail_card_widgets/detail_card_widgets.dart';
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

            BannerWidget(type: 'Word From Dictionary API',),

            DefinitionWidget(definitions: widget.word.allDefinitions),

            SynonymsWidget(word: widget.word, synonyms: widget.word.allSynonyms),


            AntonymsWidget(word: widget.word, antonyms: widget.word.allAntonyms),


            ExampleWidget(word: widget.word, examples: widget.word.allExamples,)

          ],
        ),
      ),
    );
  }
}