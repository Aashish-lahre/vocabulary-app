import 'package:bloc/bloc.dart';
import 'package:dictionary_api/dictionary_api.dart';
import 'package:dictionary_repository/dictionary_repository.dart';
import 'package:equatable/equatable.dart';

part 'word_event.dart';
part 'word_state.dart';

class WordBloc extends Bloc<WordEvent, WordState> {

  final DictionaryRepository _repository;

  WordBloc({DictionaryRepository? repository}) : _repository = repository ?? DictionaryRepository(), super(WordInitial()) {

    on<LoadWords>((event, emit) async {
      try {
        emit(WordLoadingState());
        final Map<int, Word> receivedWords = await _repository.fetchRandomWords(event.noOfWordToSearch);
        emit(WordLoadSuccess(words: receivedWords.values.toList()));
      } on WordRequestFailure {
        emit(InternetFailure());
      }

      catch(err) {
        print('error catch on bloc : $err');
        rethrow;
      }
    });



    on<SearchWord>((event, emit) async {
      try {
        emit(WordLoadingState());
        final Word receivedWord = await _repository.fetchWord(event.wordToSearch);
        emit(WordLoadSuccess(words: [receivedWord]));
      } catch(err) {
        emit(WordSearchFailed());
      }
    });






  }
}
