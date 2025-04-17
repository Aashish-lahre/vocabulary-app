part of 'word_bloc.dart';

sealed class WordState extends Equatable {
  const WordState();
}

final class WordInitial extends WordState {

  final int moreWordFetchLimit;

  const WordInitial({required this.moreWordFetchLimit});

  @override
  List<Object> get props => [moreWordFetchLimit];
}


// State when initial and more words are being loaded
final class WordsLoadingState extends WordState {
  @override
  List<Object?> get props => [];

}



final class WordsLoadingSuccessState extends WordState {
  @override
  List<Object?> get props => [];

}


final class MoreWordsLoadingState extends WordState {
  @override
  List<Object?> get props => [];
}


final class MoreWordsLoadingSuccessState extends WordState {
  @override
  List<Object?> get props => [];
}


// State when a single word is successfully loaded via search
final class WordSearchLoadSuccess extends WordState {

  final Word word;

  const WordSearchLoadSuccess({required this.word});


  @override
  List<Object?> get props => [word];

}



// State when a single word is being loaded via search
final class WordSearchLoadingState extends WordState {
  @override
  List<Object?> get props => [];
}


// State when a single word is requested to show in the UI(Home Screen) from the allWords list.
final class FetchedSingleWordState extends WordState {

  final Word word;

  const FetchedSingleWordState({required this.word});



  @override
  List<Object?> get props => [word];

}


// State when no more words are available to load from the allWords list. User swiped all the words. now must fetch more words from the API.
final class NoMoreWordAvailableState extends WordState {
  @override
  List<Object?> get props => [];

}


// State when the word is not found in the dictionary API
final class WordSearchUnavailabilityState extends WordState {
  @override

  List<Object?> get props => [];

}

// State when the internet connection is lost while fetching words from the dictionary API
final class InternetFailureState extends WordState {

  final int wordNotSearched;
  final int wordRetrived;
  final int wordSkipped;

  const InternetFailureState({required this.wordNotSearched, required this.wordSkipped, required this.wordRetrived});

  @override
  List<Object?> get props => [wordSkipped, wordRetrived, wordNotSearched];

}




final class MoreWordsFetchLimitChangedState extends WordState {
  final int changedLimit;

  const MoreWordsFetchLimitChangedState({required this.changedLimit});

  @override
  List<Object?> get props => [changedLimit];
}


// State when an unexpected error occurs while fetching words from the dictionary API
final class UnexpectedState extends WordState {
  final String errorMessage;

  const UnexpectedState({required this.errorMessage});
  @override
  List<Object?> get props => [errorMessage];
}

// State when partial data is fetched from the dictionary API
final class PartialDataState extends WordState {

  final int wordFailedCount;
  final int wordFetchedCount;

  const PartialDataState({required this.wordFailedCount, required this.wordFetchedCount});

  @override
  List<Object?> get props => [wordFailedCount, wordFetchedCount];

}