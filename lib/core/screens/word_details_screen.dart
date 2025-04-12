import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../models/word.dart';
import '../shared/detail_card_widgets/detail_card_widgets.dart';



class WordDetailsScreen extends StatefulWidget {
  final Word word;
  final String bannerName;

   const WordDetailsScreen({required this.word, required this.bannerName, super.key});

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
            TitleWidget(wordName: widget.word.wordName),

            BannerWidget(type: widget.bannerName),

            DefinitionWidget(definitions: widget.word.definitions),

            SynonymsWidget(word: widget.word,),


            AntonymsWidget(word: widget.word,),


            ExampleWidget(word: widget.word)

          ],
        ),
      ),
    );
  }
}

