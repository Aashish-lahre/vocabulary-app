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
    );

// Map<String, dynamic> _$WordToJson(Word instance) => <String, dynamic>{
//       'word': instance.word,
//       'meanings': instance.meanings.map((e) => e.toJson()).toList(),
//     };
