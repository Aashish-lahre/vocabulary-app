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


/// loading state for initial words fetch.
final class AiWordsLoadingState extends GeminiState {
  @override
  List<Object?> get props => [];

}


/// loaded state for initial words fetch, brings list of Words
final class AiWordsLoadedState extends GeminiState {

  final List<Word> words;

  const AiWordsLoadedState({required this.words});

  @override
  List<Object?> get props => [words];

}


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


/// state emitted when fetching of multiple words failed.
final class GeminiWordsLoadFailureState extends GeminiState {
  final String errorMessage;

  const GeminiWordsLoadFailureState({required this.errorMessage});

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


/// state emitted when i swiped out all the Words from screen.
final class NoMoreAiWordsAvailableState extends GeminiState {
  @override
  List<Object?> get props => [];

}


final class ExamplesLoadingState extends GeminiState {

  @override
  List<Object?> get props => [];

}


final class ExamplesLoadedState extends GeminiState {

  final Word word;
  final List<String> examples;

  const ExamplesLoadedState({required this.examples, required this.word});

  @override
  List<Object?> get props => [examples, word];

}


final class SynonymsLoadingState extends GeminiState {
  @override
  List<Object?> get props => [];
}


final class SynonymsLoadedState extends GeminiState {
  final Word word;

  final List<String> synonyms;

  const SynonymsLoadedState({required this.synonyms, required this.word});
  @override
  List<Object?> get props => [synonyms, word];
}



final class AntonymsLoadingState extends GeminiState {
  @override
  List<Object?> get props => [];
}

final class AntonymsLoadedState extends GeminiState {
  final Word word;
  final List<String> antonyms;

  const AntonymsLoadedState({required this.antonyms, required this.word});
  @override
  List<Object?> get props => [antonyms, word];
}

