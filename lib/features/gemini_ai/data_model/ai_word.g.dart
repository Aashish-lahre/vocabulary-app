// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_word.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AiPartOfSpeech _$AiPartOfSpeechFromJson(Map<String, dynamic> json) =>
    AiPartOfSpeech(
      partOfSpeech: (json['partOfSpeech'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$AiPartOfSpeechToJson(AiPartOfSpeech instance) =>
    <String, dynamic>{
      'partOfSpeech': instance.partOfSpeech,
    };

AiWordName _$AiWordNameFromJson(Map<String, dynamic> json) => AiWordName(
      wordName: json['wordName'] as String,
    );

Map<String, dynamic> _$AiWordNameToJson(AiWordName instance) =>
    <String, dynamic>{
      'wordName': instance.wordName,
    };

AiDefinition _$AiDefinitionFromJson(Map<String, dynamic> json) => AiDefinition(
      definitions: (json['definitions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$AiDefinitionToJson(AiDefinition instance) =>
    <String, dynamic>{
      'definitions': instance.definitions,
    };

AiSynonyms _$AiSynonymsFromJson(Map<String, dynamic> json) => AiSynonyms(
      synonyms:
          (json['synonyms'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$AiSynonymsToJson(AiSynonyms instance) =>
    <String, dynamic>{
      'synonyms': instance.synonyms,
    };

AiAntonyms _$AiAntonymsFromJson(Map<String, dynamic> json) => AiAntonyms(
      antonyms:
          (json['antonyms'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$AiAntonymsToJson(AiAntonyms instance) =>
    <String, dynamic>{
      'antonyms': instance.antonyms,
    };

AiExample _$AiExampleFromJson(Map<String, dynamic> json) => AiExample(
      examples:
          (json['examples'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$AiExampleToJson(AiExample instance) => <String, dynamic>{
      'examples': instance.examples,
    };

AiWord _$AiWordFromJson(Map<String, dynamic> json) => AiWord(
      wordName: json['wordName'] as String,
      partOfSpeech: (json['partOfSpeech'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      definition: (json['definition'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      synonyms:
          (json['synonyms'] as List<dynamic>).map((e) => e as String).toList(),
      antonyms:
          (json['antonyms'] as List<dynamic>).map((e) => e as String).toList(),
      example:
          (json['example'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$AiWordToJson(AiWord instance) => <String, dynamic>{
      'wordName': instance.wordName,
      'partOfSpeech': instance.partOfSpeech,
      'definition': instance.definition,
      'synonyms': instance.synonyms,
      'antonyms': instance.antonyms,
      'example': instance.example,
    };
