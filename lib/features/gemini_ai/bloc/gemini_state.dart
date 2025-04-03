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