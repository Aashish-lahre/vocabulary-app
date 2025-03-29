// // import 'package:bloc/bloc.dart';
// // import 'package:meta/meta.dart';
// import 'package:dictionary_api/dictionary_api.dart' show Word;
// import 'package:equatable/equatable.dart';
// import 'package:hydrated_bloc/hydrated_bloc.dart';
// import "package:json_annotation/json_annotation.dart";
// import 'package:dictionary_repository/dictionary_repository.dart';
//
//
// part 'word_cubit.g.dart';
// part 'word_state.dart';
//
// class WordCubit extends Cubit<WordState> {
//   WordCubit({
//     DictionaryRepository? dictionary_repository
//   }) : _repository = dictionary_repository ?? DictionaryRepository(), super(WordState());
//
//
//
//   final DictionaryRepository _repository;
//
//
//   Future<void> getWord(String queryWord) async {
//
//     if(queryWord.isEmpty) return;
//
//     emit(state.copyWith(wordStatus: WordStatus.loading));
//
//     try {
// final word = await _repository.fetchWord(queryWord);
//
//   emit(state.copyWith(wordStatus: WordStatus.success, word: word));
//     } on Exception catch(err) {
//       print("error : $err");
//   emit(state.copyWith(wordStatus: WordStatus.failure));
//
//     }
//
//
//
//
//
//
//   }
//
//   // @override
//   // fromJson(Map<String, dynamic> json) {
//   //   return WordState.fromJson(json);
//   // }
//
//   // @override
//   // Map<String, dynamic>? toJson(WordState state) {
//   //   return state.toJson();
//   // }
//
// }
