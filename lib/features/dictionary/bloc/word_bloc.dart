import 'package:bloc/bloc.dart';
import 'package:flutter_improve_vocabulary/features/gemini_ai/bloc/gemini_bloc.dart';

import 'package:flutter_improve_vocabulary/app/home_error_types_enum.dart';
import '../../../core/utility/result.dart';
import '../data/dictionary_failures.dart';
import '../../../core/models/word.dart';
import '../repository/dictionary_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';




part 'word_event.dart';
part 'word_state.dart';

class WordBloc extends Bloc<WordEvent, WordState> {

  final DictionaryRepository repository;


  // this word will be shown on homeScreen first, than as "wordIndex" increments, following words will be shown.
  int wordIndex = 0;
  final List<Word> allWords = [];


  EventTransformer<E> throttleRestartable<E>() {
    return (events, mapper) {
      return events
          .throttleTime(Duration(seconds: 3), trailing: false) // ✅ Allow first event, block others for 3 sec
          .asyncExpand(mapper);
    };
  }








  WordBloc({ required this.repository}) : super(WordInitial()) {




    on<LoadWords>((event, emit) async {

        emit(WordLoadingState());
        final Result<List<Word>, DictionaryFailure> receivedWords = await repository.fetchRandomWords(event.noOfWordToSearch);

        if(receivedWords.isSuccess) {
          allWords.addAll(receivedWords.data!);
          if(event.autoLoad) {
            print('wordBloc event autoLoad');
            emit(FetchedSingleWordState(word: allWords[wordIndex]));
          } else {
            print('wordBloc event not autoLoad');

            if(wordIndex == 0) {
              wordIndex = -1;

            }
          }
        } else {
          final failure = receivedWords.failure!;

          if(failure is NoInternetFailure) {
            allWords.addAll(receivedWords.data ?? []);
            emit(InternetFailureState(wordNotSearched: failure.wordsNotSearched, wordSkipped: failure.wordsSkipped, wordRetrived: failure.wordsRetrieved));


          }

          if(failure is UnexpectedFailure) {
            emit(HomeErrorScreenState(homeErrorType: HomeErrorType.unexpected));
          }

          if (failure is PartialDataFailure) {
            // allWords.addAll(receivedWords.data!);
            emit(PartialDataState(wordFailedCount: failure.failedWordsCount, wordFetchedCount: failure.fetchedWordCount));
          }
          
          
          
        }
    });

    on<LaterLoadWords>(
      _onLaterLoadWords,
      transformer: throttleRestartable(),
    );

    on<GeminiFailureWordEvent>((event, emit) {
      emit(GeminiFailureWordState(errorMessage: event.errorMessage));
    });



    on<SearchWord>((event, emit) async {

        emit(WordLoadingState());
        final Result<Word, DictionaryFailure> receivedWord = await repository.fetchWord(event.wordToSearch);

        if(receivedWord.isSuccess) {

          emit(WordSearchLoadSuccess(word: receivedWord.data!));

        } else {
          _mapFailuresToStates(receivedWord.failure!, emit);
        }

    });


    on<LoadSingleWordInOrderEvent>((event, emit) {
      if(++wordIndex < allWords.length) {
        print('emitting fetchedsingle word state....');
        emit(FetchedSingleWordState(word: allWords[wordIndex]));
      } else {
        // index for words exceeds allWords items
        print('emitting no words available state state....');
        emit(NoMoreWordAvailableState());
      }
    });



  }

  void _mapFailuresToStates(DictionaryFailure failure, Emitter<WordState> emit) {
    switch(failure) {
      case NoInternetFailure _:
        emit(InternetFailureState(wordRetrived: failure.wordsRetrieved, wordNotSearched: failure.wordsNotSearched, wordSkipped: failure.wordsSkipped));
        break;
      case WordNotFoundFailure _:
        emit(WordSearchUnavailabilityState());
        break;
      case PartialDataFailure _:
        emit(PartialDataState(wordFailedCount: failure.failedWordsCount, wordFetchedCount: failure.fetchedWordCount));
        break;
      case UnexpectedFailure _:

        emit(UnexpectedState(errorMessage: failure.errorMessage));
        break;
    }
  }


  Future<void> _onLaterLoadWords(LaterLoadWords event, Emitter<WordState> emit) async {

      emit(LaterWordsLoading());
      final Result<List<Word>, DictionaryFailure> receivedWords = await repository.fetchRandomWords(event.noOfWordsToLoad);


      if(receivedWords.isSuccess) {
        allWords.addAll(receivedWords.data!);
        emit(LaterWordsLoadingSuccess());

      } else {
        if(receivedWords.failure!.runtimeType == PartialDataFailure) {
          allWords.addAll(receivedWords.data!);
        }

        if(receivedWords.failure!.runtimeType == NoInternetFailure) {
          allWords.addAll(receivedWords.data!);

        }

        _mapFailuresToStates(receivedWords.failure!, emit);
      }

  }
}
