part of 'later_word_fetch_bloc.dart';

sealed class LaterWordFetchState extends Equatable {
  const LaterWordFetchState();
}

final class LaterWordFetchInitialState extends LaterWordFetchState {

  final int count;

  const LaterWordFetchInitialState({required this.count});

  @override
  List<Object> get props => [];
}



final class LaterWordFetchCountChanged extends LaterWordFetchState {

  final int count;

  const LaterWordFetchCountChanged({required this.count});

  @override
  List<Object?> get props => [];
}
