import 'package:json_annotation/json_annotation.dart';
import './meaning.dart';

part 'word.g.dart';



@JsonSerializable(explicitToJson: true)
class Word {

  const Word(
    {
      required this.word,
      required this.meanings,
    }
  );




  // this empty word will be used when there is no word(initially when app starts for the first time) and when their is a failure.
  static final empty = Word(
    word: "",
    meanings: []
  );

  final String word;
  final List<Meaning> meanings;



  factory Word.fromJson(Map<String, dynamic> json) {
    return _$WordFromJson(json);
  }
}