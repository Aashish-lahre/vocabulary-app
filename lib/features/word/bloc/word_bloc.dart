import 'package:bloc/bloc.dart';
import 'package:dictionary_api/dictionary_api.dart';
import 'package:dictionary_repository/dictionary_repository.dart';
import 'package:equatable/equatable.dart';

part 'word_event.dart';
part 'word_state.dart';

class WordBloc extends Bloc<WordEvent, WordState> {

  final DictionaryRepository _repository;

  // this word will be shown on homeScreen first, than as "wordIndex" increments, following words will be shown.
  int wordIndex = 0;
  final List<Word> allWords = [];

  WordBloc({DictionaryRepository? repository}) : _repository = repository ?? DictionaryRepository(), super(WordInitial()) {

    on<LoadWords>((event, emit) async {
      try {
        emit(WordLoadingState());
        final Map<int, Word> receivedWords = await _repository.fetchRandomWords(event.noOfWordToSearch);
        // emit(WordLoadSuccess(words: receivedWords.values.toList()));
        allWords.addAll(receivedWords.values);
        if(wordIndex == 0) {
          emit(FetchingSingleWordState(word: allWords[wordIndex]));
        }
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


    on<LoadSingleWordInOrder>((event, emit) {
      wordIndex++;
      if(wordIndex < allWords.length) {
        print('entered here');
        emit(FetchingSingleWordState(word: allWords[wordIndex]));
      } else {
        // wordIndex exceeds allWords.length
        print('wordIndex exceeds allwords length');
        emit(InternetFailure());
      }



    });



  }
}
