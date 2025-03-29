part of 'latter_word_fetch_bloc.dart';

sealed class LatterWordFetchState extends Equatable {
  const LatterWordFetchState();
}

final class LatterWordFetchInitial extends LatterWordFetchState {
  @override
  List<Object> get props => [];
}
