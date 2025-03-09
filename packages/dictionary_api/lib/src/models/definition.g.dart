// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'definition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Definition _$DefinitionFromJson(Map<String, dynamic> json) => Definition(
      definition: json['definition'] as String,
      synonyms: (json['synonyms'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [''],
      antonyms: (json['antonyms'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [''],
      example: json['example'] as String? ?? '',
    );

// Map<String, dynamic> _$DefinitionToJson(Definition instance) =>
//     <String, dynamic>{
//       'definition': instance.definition,
//       'synonyms': instance.synonyms,
//       'antonyms': instance.antonyms,
//       'example': instance.example,
//     };
