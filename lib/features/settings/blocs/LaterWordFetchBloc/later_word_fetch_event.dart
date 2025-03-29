part of 'later_word_fetch_bloc.dart';

sealed class LaterWordFetchEvent extends Equatable {
  const LaterWordFetchEvent();
}


final class InitialLaterWordFetchCount extends LaterWordFetchEvent {

  final int count;

  const InitialLaterWordFetchCount({required this.count});


  @override
  List<Object?> get props => [];

}


final class ChangeLaterWordFetchCount extends LaterWordFetchEvent {
  final int changedCount;

  const ChangeLaterWordFetchCount({required this.changedCount});

  @override
  // TODO: implement props
  List<Object?> get props => [];


}