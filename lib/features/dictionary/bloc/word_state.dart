part of 'word_bloc.dart';

sealed class WordState extends Equatable {
  const WordState();
}

final class WordInitial extends WordState {
  @override
  List<Object> get props => [];
}


// In Dart, a final class is a class that cannot be extended (inherited)
// by other classes. This means that other classes cannot create subclasses from it.

final class WordLoadingState extends WordState {
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

final class WordSearchLoadSuccess extends WordState {

  final Word word;

  const WordSearchLoadSuccess({required this.word});


  @override
  List<Object?> get props => [word];

}


final class FetchedSingleWordState extends WordState {

  final Word word;

  const FetchedSingleWordState({required this.word});



  @override
  List<Object?> get props => [word];

}

final class NoMoreWordAvailableState extends WordState {
  @override
  List<Object?> get props => [];

}


final class LaterWordsLoading extends WordState {

  @override
  List<Object?> get props => [];

}

final class LaterWordsLoadingSuccess extends WordState {

  @override
  List<Object?> get props => [];

}

final class WordSearchUnavailabilityState extends WordState {
  @override

  List<Object?> get props => [];

}


final class InternetFailureState extends WordState {

  final int wordNotSearched;
  final int wordRetrived;
  final int wordSkipped;

  const InternetFailureState({required this.wordNotSearched, required this.wordSkipped, required this.wordRetrived});

  @override
  List<Object?> get props => [wordSkipped, wordRetrived, wordNotSearched];

}

final class HomeErrorScreenState extends WordState {
  final HomeErrorType homeErrorType;

  const HomeErrorScreenState({required this.homeErrorType});

  @override
  // TODO: implement props
  List<Object?> get props => [homeErrorType];


}

final class GeminiFailureWordState extends WordState {

  final String errorMessage;

  const GeminiFailureWordState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];

}

final class UnexpectedState extends WordState {
  final String errorMessage;

  const UnexpectedState({required this.errorMessage});
  @override
  List<Object?> get props => [errorMessage];
}

final class PartialDataState extends WordState {

  final int wordFailedCount;
  final int wordFetchedCount;

  const PartialDataState({required this.wordFailedCount, required this.wordFetchedCount});

  @override
  List<Object?> get props => [wordFailedCount, wordFetchedCount];

}