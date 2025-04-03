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

