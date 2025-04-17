part of 'word_bloc.dart';

sealed class WordEvent extends Equatable {
  const WordEvent();
}


// Load words from the dictionary API
class LoadWords extends WordEvent {

  final int noOfWordToSearch;
  final bool autoLoad;
  const LoadWords({required this.noOfWordToSearch, required this.autoLoad});

  @override
  List<Object?> get props => [noOfWordToSearch, autoLoad];
}

// class LaterLoadWords extends WordEvent {
//   final int noOfWordsToLoad;

//   const LaterLoadWords({required this.noOfWordsToLoad});

//   @override

//   List<Object?> get props => [noOfWordsToLoad];


// }



final class MoreWordsFetchLimitChangedEvent extends WordEvent {
  final int changedLimit;

  const MoreWordsFetchLimitChangedEvent({required this.changedLimit});

  @override
  List<Object?> get props => [changedLimit];
}



// Search for a word in the dictionary API
class SearchWord extends WordEvent {

  final String wordToSearch;

  const SearchWord({required this.wordToSearch});

  @override
  List<Object?> get props => [wordToSearch];


}

// Load a single word in order from the allWords list in the WordBloc
class LoadSingleWordInOrderEvent extends WordEvent {
  @override
  List<Object?> get props => [];
}


// class GeminiFailureWordEvent extends WordEvent {
  
//   final String errorMessage;
  
//   const GeminiFailureWordEvent({required this.errorMessage});
  
//   @override
//   List<Object?> get props => [errorMessage];
  
// }