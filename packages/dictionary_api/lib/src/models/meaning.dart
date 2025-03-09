import "package:json_annotation/json_annotation.dart";
import "./definition.dart"; // Ensure the correct import for Definition

part 'meaning.g.dart';

@JsonSerializable(explicitToJson: true)
class Meaning {
  final String partOfSpeech;
  final List<Definition> definitions;

  @JsonKey(defaultValue: [])
  final List<String> synonyms;

  @JsonKey(defaultValue: [])
  final List<String> antonyms;

  Meaning({
    required this.partOfSpeech,
    required this.definitions,
    this.synonyms = const [],
    this.antonyms = const [],
  });

  factory Meaning.fromJson(Map<String, dynamic> json) => _$MeaningFromJson(json);


}
