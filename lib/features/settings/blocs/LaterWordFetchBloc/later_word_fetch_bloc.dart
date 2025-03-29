import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'later_word_fetch_event.dart';
part 'later_word_fetch_state.dart';

class LaterWordFetchBloc extends Bloc<LaterWordFetchEvent, LaterWordFetchState> {

   int laterWordFetchLimit;


  LaterWordFetchBloc({required this.laterWordFetchLimit}) : super(LaterWordFetchInitialState(count: laterWordFetchLimit)) {

    on<InitialLaterWordFetchCount>((event, emit) {
      emit(LaterWordFetchInitialState(count: event.count));
    });

    on<ChangeLaterWordFetchCount>((event, emit) {

      laterWordFetchLimit = event.changedCount;
      emit(LaterWordFetchCountChanged(count: event.changedCount));
    });
  }
}
