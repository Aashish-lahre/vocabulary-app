import 'package:flutter_improve_vocabulary/core/utility/base_class.dart';
import 'package:json_annotation/json_annotation.dart';
import 'meaning.dart';

part 'word.g.dart';



@JsonSerializable(explicitToJson: true)
class Word extends BaseWord{

   Word(
    {
      required this.word,
      required this.meanings,
      required this.allDefinitions,
      required this.allSynonyms,
      required this.allAntonyms,
      required this.allExamples,
    }
  );




  // this empty word will be used when there is no word(initially when app starts for the first time) and when their is a failure.
  static final empty = Word(
    word: "",
    meanings: [],
    allAntonyms: [],
    allDefinitions: [],
    allExamples: [],
    allSynonyms: [],
  );

  final String word;
  final List<Meaning> meanings;
  List<String> allDefinitions;
  List<String> allSynonyms;
  List<String> allAntonyms;
  List<String> allExamples;



  factory Word.fromJson(Map<String, dynamic> json) {
    return _$WordFromJson(json);
  }
}