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


class SearchWord extends WordEvent {

  final String wordToSearch;

  const SearchWord({required this.wordToSearch});

  @override
  List<Object?> get props => [wordToSearch];


}
