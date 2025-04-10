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


/// loaded state for initial words fetch, brings list of AiWords
final class AiWordsLoadedState extends GeminiState {

  final List<AiWord> aiWords;

  const AiWordsLoadedState({required this.aiWords});

  @override
  List<Object?> get props => [aiWords];

}


/// state emitted when searched for a single word.
final class SingleAiWordFetchedState extends GeminiState {

  final AiWord word;

  const SingleAiWordFetchedState({required this.word});

  @override
  List<Object?> get props => [word];

}


final class SingleAiWordLoadingState extends GeminiState {


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


/// state emitted when i swiped out all the AiWords from screen.
final class NoMoreAiWordsAvailableState extends GeminiState {
  @override
  List<Object?> get props => [];

}


final class ExamplesLoadingState extends GeminiState {

  @override
  List<Object?> get props => [];

}


final class ExamplesLoadedState extends GeminiState {

  final BaseWord word;
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
  final BaseWord word;

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
  final BaseWord word;
  final List<String> antonyms;

  const AntonymsLoadedState({required this.antonyms, required this.word});
  @override
  List<Object?> get props => [antonyms, word];
}

