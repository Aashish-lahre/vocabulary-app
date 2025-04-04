part of 'gemini_bloc.dart';

sealed class GeminiEvent extends Equatable {
  const GeminiEvent();
}

final class ToggleGenerateWordsWithAiSwitchEvent extends GeminiEvent {

  final bool isOn;

  const ToggleGenerateWordsWithAiSwitchEvent({required this.isOn});

  @override
  List<Object?> get props => [isOn];


}

final class LoadAiWordsEvent extends GeminiEvent {

  final int noOfAiWordsToLoad;
  const LoadAiWordsEvent({required this.noOfAiWordsToLoad});

  @override
  List<Object?> get props =>[noOfAiWordsToLoad];

}

final class LoadSingleAiWordEvent extends GeminiEvent {
  @override
  List<Object?> get props => [];

}


final class LaterLoadAiWordsEvent extends GeminiEvent {

  final laterLoadAiWordsCount;

  const LaterLoadAiWordsEvent({required this.laterLoadAiWordsCount});

  @override
  List<Object?> get props => [laterLoadAiWordsCount];

}

final class LoadExamplesEvent extends GeminiEvent {

  final String wordName;
  final int limit;
  final List<String> filterOut;

  const LoadExamplesEvent({required this.wordName, required this.limit, required this.filterOut});

  @override
  List<Object?> get props => [limit, wordName, filterOut];

}

final class LoadSynonymsEvent extends GeminiEvent {


  final String word;
  final int limit;
  final List<String> filterOut;

  const LoadSynonymsEvent({required this.word, required this.limit, required this.filterOut});


  @override
  List<Object?> get props => [word, limit, filterOut];

}

final class LoadAntonymsEvent extends GeminiEvent {


  final String word;
  final int limit;
  final List<String> filterOut;

  const LoadAntonymsEvent({required this.word, required this.limit, required this.filterOut});


  @override
  List<Object?> get props => [word, limit, filterOut];

}

final class ChangeGeminiModelEvent extends GeminiEvent {

  final GeminiModels modelType;

  const ChangeGeminiModelEvent({required this.modelType});


  @override
  List<Object?> get props => [modelType];

}