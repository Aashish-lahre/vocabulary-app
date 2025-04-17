part of 'gemini_bloc.dart';

sealed class GeminiEvent extends Equatable {
  const GeminiEvent();
}

/// event fired when user toggles the gemini AI switch in settings page to
/// generate words using gemini AI.
final class ToggleGenerateWordsWithAiSwitchEvent extends GeminiEvent {

  final bool isOn;

  const ToggleGenerateWordsWithAiSwitchEvent({required this.isOn});

  @override
  List<Object?> get props => [isOn];


}

/// event fired to fetch [noOfAiWordsToLoad] words from Gemini AI.
final class LoadAiWordsEvent extends GeminiEvent {

  final int noOfAiWordsToLoad;
  /// if autoLoad is true, we show the first word on the home screen, without requesting to fetch first word.
  final bool autoLoad;
  const LoadAiWordsEvent({required this.noOfAiWordsToLoad, required this.autoLoad});

  @override
  List<Object?> get props =>[noOfAiWordsToLoad];

}

/// event fired to load the next word from [allWords] list.
final class LoadSingleAiWordInOrderEvent extends GeminiEvent {
  @override
  List<Object?> get props => [];

}




/// event fired to search a [word] from Gemini AI.
final class SearchWordWithAiEvent extends GeminiEvent {

  final String wordName;

  const SearchWordWithAiEvent({required this.wordName});


  @override
  List<Object?> get props => [wordName];

}


/// fetches examples for a [word]
final class LoadExamplesEvent extends GeminiEvent {

  final Word word;
  final int limit;
  final List<String> filterOut;

  const LoadExamplesEvent({required this.word, required this.limit, required this.filterOut});

  @override
  List<Object?> get props => [limit, word, filterOut];

}


/// fetches Synonyms for a [word]
final class LoadSynonymsEvent extends GeminiEvent {


  final Word word;
  final int limit;
  final List<String> filterOut;

  const LoadSynonymsEvent({required this.word, required this.limit, required this.filterOut});


  @override
  List<Object?> get props => [word, limit, filterOut];

}


/// fetches Antonyms for a [word]
final class LoadAntonymsEvent extends GeminiEvent {


  final Word word;
  final int limit;
  final List<String> filterOut;

  const LoadAntonymsEvent({required this.word, required this.limit, required this.filterOut});


  @override
  List<Object?> get props => [word, limit, filterOut];

}


/// Gemini API provides multiple ai models to select from.
final class ChangeGeminiModelEvent extends GeminiEvent {

  final GeminiModels modelType;

  const ChangeGeminiModelEvent({required this.modelType});


  @override
  List<Object?> get props => [modelType];

}