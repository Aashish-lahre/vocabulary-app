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

final class WordLoadSuccess extends WordState {

  final List<Word> words;

  const WordLoadSuccess({required this.words});


  @override
  List<Object?> get props => [words];

}

final class WordSearchFailed extends WordState {
  @override
  // TODO: implement props
  List<Object?> get props => [];

}


final class InternetFailure extends WordState {

  final List<Word>? words;

  const InternetFailure([this.words]);

  @override
  List<Object?> get props => [];

}