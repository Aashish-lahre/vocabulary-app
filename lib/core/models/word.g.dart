// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Word _$WordFromJson(Map<String, dynamic> json) => Word(
      wordName: json['wordName'] as String,
      partsOfSpeech: (json['partsOfSpeech'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      definitions: (json['definitions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      synonyms:
          (json['synonyms'] as List<dynamic>).map((e) => e as String).toList(),
      antonyms:
          (json['antonyms'] as List<dynamic>).map((e) => e as String).toList(),
      examples:
          (json['examples'] as List<dynamic>).map((e) => e as String).toList(),
    );


