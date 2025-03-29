import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'latter_word_fetch_event.dart';
part 'latter_word_fetch_state.dart';

class LatterWordFetchBloc extends Bloc<LatterWordFetchEvent, LatterWordFetchState> {
  LatterWordFetchBloc() : super(LatterWordFetchInitial()) {
    on<LatterWordFetchEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
