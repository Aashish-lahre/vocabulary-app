

import 'package:json_annotation/json_annotation.dart';

import '../../../core/utility/base_class.dart';

part "ai_word.g.dart";




@JsonSerializable(explicitToJson: true)
class AiPartOfSpeech {
final List<String> partOfSpeech;

  AiPartOfSpeech({required this.partOfSpeech});
factory AiPartOfSpeech.fromJson(Map<String, dynamic> json) => _$AiPartOfSpeechFromJson(json);

}

@JsonSerializable(explicitToJson: true)
class AiWordName {
  final String wordName;

  AiWordName({required this.wordName});
  factory AiWordName.fromJson(Map<String, dynamic> json) => _$AiWordNameFromJson(json);

}


@JsonSerializable(explicitToJson: true)
class AiDefinition {
  List<String> definitions;

  AiDefinition({required this.definitions});
  factory AiDefinition.fromJson(Map<String, dynamic> json) => _$AiDefinitionFromJson(json);

}


@JsonSerializable(explicitToJson: true)
class AiSynonyms {
  List<String> synonyms;

  AiSynonyms({required this.synonyms});
  factory AiSynonyms.fromJson(Map<String, dynamic> json) => _$AiSynonymsFromJson(json);


}

@JsonSerializable(explicitToJson: true)
class AiAntonyms {
  List<String> antonyms;
  AiAntonyms({required this.antonyms});

  factory AiAntonyms.fromJson(Map<String, dynamic> json) => _$AiAntonymsFromJson(json);
}

@JsonSerializable(explicitToJson: true)
class AiExample {
  List<String> examples;

  AiExample({required this.examples});

  factory AiExample.fromJson(Map<String, dynamic> json) => _$AiExampleFromJson(json);
}

@JsonSerializable(explicitToJson: true)
class AiWord extends BaseWord {
  final String wordName;
  final List<String> partOfSpeech;
  final List<String> definition;
  final List<String> synonyms;
  final List<String> antonyms;
  final List<String> example;

  AiWord({
    required this.wordName,
    required this.partOfSpeech,
    required this.definition,
    required this.synonyms,
    required this.antonyms,
    required this.example,
  });

  factory AiWord.fromJson(Map<String, dynamic> json) => _$AiWordFromJson(json);

  Map<String, dynamic> toJson() => _$AiWordToJson(this);

}