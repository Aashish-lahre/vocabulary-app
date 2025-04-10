import 'package:flutter/material.dart';
import 'package:flutter_improve_vocabulary/features/gemini_ai/data_model/ai_word.dart';
import 'package:gap/gap.dart';
import '../../../core/shared/detail_card_widgets/detail_card_widgets.dart';



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
            TitleWidget(wordName: widget.word.wordName),

            BannerWidget(type: 'Word from AI'),

            DefinitionWidget(definitions: widget.word.definition),

            SynonymsWidget(synonyms: widget.word.synonyms, word: widget.word,),


            AntonymsWidget(antonyms: widget.word.antonyms, word: widget.word,),


            ExampleWidget(word: widget.word, examples: widget.word.example,)

          ],
        ),
      ),
    );
  }
}

