import 'package:json_annotation/json_annotation.dart';

part 'definition.g.dart';



@JsonSerializable()
class Definition {
final String definition;
@JsonKey(defaultValue: [''])
final List<String> synonyms;
@JsonKey(defaultValue: [''])
final List<String> antonyms;
@JsonKey(defaultValue: '')
final String example;



Definition({
  required this.definition,
  this.synonyms = const [],
  this.antonyms = const [],
  this.example = '',

});


factory Definition.fromJson(Map<String, dynamic> json) => _$DefinitionFromJson(json);





}