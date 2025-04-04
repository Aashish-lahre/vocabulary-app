part of 'gemini_bloc.dart';

sealed class GeminiState extends Equatable {
  const GeminiState();
}

final class GeminiInitial extends GeminiState {
  @override
  List<Object> get props => [];
}


final class AiWordsSwitchChangedState extends GeminiState {

  final bool isOn;
  const AiWordsSwitchChangedState({required this.isOn});

  @override
  List<Object?> get props => [isOn];

}



final class AiWordsLoadingState extends GeminiState {
  @override
  List<Object?> get props => [];

}


final class AiWordsLoadedState extends GeminiState {

  final List<AiWord> aiWords;

  const AiWordsLoadedState({required this.aiWords});

  @override
  List<Object?> get props => [aiWords];

}


final class SingleAiWordFetchedState extends GeminiState {

  final AiWord word;

  const SingleAiWordFetchedState({required this.word});

  @override
  List<Object?> get props => [word];

}

final class GeminiFailureState extends GeminiState {
  final String errorMessage;

  const GeminiFailureState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

final class NoMoreAiWordsAvailableState extends GeminiState {
  @override
  List<Object?> get props => [];

}


final class ExamplesLoadingState extends GeminiState {

  @override
  List<Object?> get props => [];

}


final class ExamplesLoadedState extends GeminiState {

  final List<String> examples;

  const ExamplesLoadedState({required this.examples});

  @override
  List<Object?> get props => [examples];

}


final class SynonymsLoadingState extends GeminiState {
  @override
  List<Object?> get props => [];
}


final class SynonymsLoadedState extends GeminiState {
  final List<String> synonyms;

  const SynonymsLoadedState({required this.synonyms});
  @override
  List<Object?> get props => [synonyms];
}



final class AntonymsLoadingState extends GeminiState {
  @override
  List<Object?> get props => [];
}

final class AntonymsLoadedState extends GeminiState {
  final List<String> antonyms;

  const AntonymsLoadedState({required this.antonyms});
  @override
  List<Object?> get props => [antonyms];
}

