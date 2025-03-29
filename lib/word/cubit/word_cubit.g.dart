// // GENERATED CODE - DO NOT MODIFY BY HAND
//
// part of 'word_cubit.dart';
//
// // **************************************************************************
// // JsonSerializableGenerator
// // **************************************************************************
//
// WordState _$WordStateFromJson(Map<String, dynamic> json) => WordState(
//       wordStatus:
//           $enumDecodeNullable(_$WordStatusEnumMap, json['wordStatus']) ??
//               WordStatus.initial,
//       word: json['word'] == null
//           ? null
//           : Word.fromJson(json['word'] as Map<String, dynamic>),
//     );
//
// Map<String, dynamic> _$WordStateToJson(WordState instance) => <String, dynamic>{
//       'wordStatus': _$WordStatusEnumMap[instance.wordStatus]!,
//       'word': instance.word,
//     };
//
// const _$WordStatusEnumMap = {
//   WordStatus.initial: 'initial',
//   WordStatus.loading: 'loading',
//   WordStatus.success: 'success',
//   WordStatus.failure: 'failure',
// };
