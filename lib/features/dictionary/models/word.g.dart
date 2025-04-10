// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Word _$WordFromJson(Map<String, dynamic> json) => Word(
      word: json['word'] as String,
      meanings: (json['meanings'] as List<dynamic>)
          .map((e) => Meaning.fromJson(e as Map<String, dynamic>))
          .toList(),
      allDefinitions: (json['allDefinitions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      allSynonyms: (json['allSynonyms'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      allAntonyms: (json['allAntonyms'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      allExamples: (json['allExamples'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

// Map<String, dynamic> _$WordToJson(Word instance) => <String, dynamic>{
//       'word': instance.word,
//       'meanings': instance.meanings.map((e) => e.toJson()).toList(),
//       'allDefinitions': instance.allDefinitions,
//       'allSynonyms': instance.allSynonyms,
//       'allAntonyms': instance.allAntonyms,
//       'allExamples': instance.allExamples,
//     };
