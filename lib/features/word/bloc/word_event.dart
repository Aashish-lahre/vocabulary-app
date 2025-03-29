part of 'word_bloc.dart';

sealed class WordEvent extends Equatable {
  const WordEvent();
}

class LoadWords extends WordEvent {

  final int noOfWordToSearch;
  const LoadWords({required this.noOfWordToSearch});

  @override
  List<Object?> get props => [noOfWordToSearch];
}

class LaterLoadWords extends WordEvent {
  final int noOfWordsToLoad;

  const LaterLoadWords({required this.noOfWordsToLoad});

  @override

  List<Object?> get props => [noOfWordsToLoad];


}


class SearchWord extends WordEvent {

  final String wordToSearch;

  const SearchWord({required this.wordToSearch});

  @override
  List<Object?> get props => [wordToSearch];


}

class LoadSingleWordInOrder extends WordEvent {
  @override
  List<Object?> get props => [];
}
