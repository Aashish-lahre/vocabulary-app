import 'package:json_annotation/json_annotation.dart';

part 'word.g.dart';



@JsonSerializable(explicitToJson: true)
class Word{

   Word(
    {
      required this.wordName,
      required this.partsOfSpeech,
      required this.definitions,
      required this.synonyms,
      required this.antonyms,
      required this.examples,
    }
  );




  // this empty word will be used when there is no word(initially when app starts for the first time) and when their is a failure.
  static final empty = Word(
    wordName: "",
    partsOfSpeech: [],
    antonyms: [],
    definitions: [],
    examples: [],
    synonyms: [],
  );

  final String wordName;
  final List<String> partsOfSpeech;
  List<String> definitions;
  List<String> synonyms;
  List<String> antonyms;
  List<String> examples;



  factory Word.fromJson(Map<String, dynamic> json) {
    return _$WordFromJson(json);
  }
}