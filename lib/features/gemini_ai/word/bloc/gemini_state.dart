part of 'gemini_bloc.dart';

sealed class GeminiState extends Equatable {
  const GeminiState();
}

final class GeminiInitial extends GeminiState {
  @override
  List<Object> get props => [];
}


/// when Gemini Ai switch in settings page gets toggled.
final class AiWordsSwitchChangedState extends GeminiState {

  final bool isOn;
  const AiWordsSwitchChangedState({required this.isOn});

  @override
  List<Object?> get props => [isOn];

}


/// state emitted when Gemini AI is loading words.
final class AiWordsLoadingState extends GeminiState {
  @override
  List<Object?> get props => [];

}


/// state emitted when Gemini AI loads words successfully. also contains the list of words.
final class AiWordsLoadedState extends GeminiState {

  final List<Word> words;

  const AiWordsLoadedState({required this.words});

  @override
  List<Object?> get props => [words];

}


/// state emitted when requested to fetch a single word to show on the home screen from the allWords list.
final class SingleAiWordFetchState extends GeminiState {

  final Word word;

  const SingleAiWordFetchState({required this.word});

  @override
  List<Object?> get props => [word];

}

/// state emitted when searched for a single word.
final class AiWordSearchCompleteState extends GeminiState {

  final Word word;

  const AiWordSearchCompleteState({required this.word});

  @override
  List<Object?> get props => [word];

}


/// state emitted when Gemini AI is searching for a word.
final class AiWordSearchingState extends GeminiState {


  @override
  List<Object?> get props => [];

}


/// General Gemini Failure
final class GeminiFailureState extends GeminiState {
  final String errorMessage;

  const GeminiFailureState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}


/// state emitted when invalid api key is provided.
final class GeminiInvalidApiKeyState extends GeminiState {
  final String errorMessage;

  const GeminiInvalidApiKeyState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

/// state emitted when failure occurred when searching for a single word.
final class GeminiSingleWordLoadFailureState extends GeminiState {
  final String errorMessage;

  const GeminiSingleWordLoadFailureState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}


/// state emitted when user swiped out all the Words from screen.
final class NoMoreAiWordsAvailableState extends GeminiState {
  @override
  List<Object?> get props => [];

}


/// state emitted when Gemini AI is loading examples for a word.
final class ExamplesLoadingState extends GeminiState {

  @override
  List<Object?> get props => [];

}


/// state emitted when Gemini AI loads examples for a word successfully.
final class ExamplesLoadedState extends GeminiState {

  final Word word;
  final List<String> examples;

  const ExamplesLoadedState({required this.examples, required this.word});

  @override
  List<Object?> get props => [examples, word];

}


/// state emitted when Gemini AI is loading synonyms for a word.
final class SynonymsLoadingState extends GeminiState {
  @override
  List<Object?> get props => [];
}


/// state emitted when Gemini AI loads synonyms for a word successfully.
final class SynonymsLoadedState extends GeminiState {
  final Word word;

  final List<String> synonyms;

  const SynonymsLoadedState({required this.synonyms, required this.word});
  @override
  List<Object?> get props => [synonyms, word];
}


/// state emitted when Gemini AI is loading antonyms for a word.
final class AntonymsLoadingState extends GeminiState {
  @override
  List<Object?> get props => [];
}

/// state emitted when Gemini AI loads antonyms for a word successfully.
final class AntonymsLoadedState extends GeminiState {
  final Word word;
  final List<String> antonyms;

  const AntonymsLoadedState({required this.antonyms, required this.word});
  @override
  List<Object?> get props => [antonyms, word];
}

/// state emitted when Gemini AI model is changed.
final class GeminiModelChangedState extends GeminiState {
  final GeminiModels model;

  const GeminiModelChangedState({required this.model});

  @override
  List<Object?> get props => [model];
}

