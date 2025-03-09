

import 'package:dictionary_api/dictionary_api.dart';
import 'package:flutter/material.dart';

class WordPopulate extends StatelessWidget {
  const WordPopulate({required this.word, super.key});

  final Word word;

  @override
  Widget build(BuildContext context) {
    
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
  children: [

    Text(word.word), // Display the word
    SizedBox(height: 50),
    for (var meaning in word.meanings) 
      for (var definition in meaning.definitions) 
        Text(definition.definition), // Display each definition
  ],
)
    );
  }
}