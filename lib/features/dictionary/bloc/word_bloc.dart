import 'package:bloc/bloc.dart';

import '../../../core/shared_preference/word_fetch_limit.dart';
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


  // this word will be shown on homeScreen first, than as "wordIndex" increments, following words will be shown from the allWords list.
  int wordIndex = 0;
  final List<Word> allWords = [];
  int moreWordFetchLimit;


  // Throttle the events to prevent spamming the API
  EventTransformer<E> throttleRestartable<E>() {
    return (events, mapper) {
      return events
          .throttleTime(Duration(seconds: 3), trailing: false) // ✅ Allow first event, block others for 3 sec
          .asyncExpand(mapper);
    };
  }








  WordBloc({ required this.repository, required this.moreWordFetchLimit}) : super(WordInitial(moreWordFetchLimit: moreWordFetchLimit)) {




    // Load words from the dictionary API
    on<LoadWords>(
      
      transformer: throttleRestartable(),
      (event, emit) async {

        if(allWords.isEmpty) {
          emit(WordsLoadingState());
        } else {
          emit(MoreWordsLoadingState());
        }
        final Result<List<Word>, DictionaryFailure> receivedWords = await repository.fetchRandomWords(event.noOfWordToSearch);

        if(receivedWords.isSuccess) {


          if(allWords.isEmpty) {
            emit(WordsLoadingSuccessState());
          } else {
            emit(MoreWordsLoadingSuccessState());
          }



          allWords.addAll(receivedWords.data!);
          
          
                  
          // intially when user opens the app, the first word will be shown, without requesting to fetch first word, if autoLoad is true.
          if(event.autoLoad) {
            emit(FetchedSingleWordState(word: allWords[wordIndex]));
          } else {
            // else block represents the case where user requested to fetch more words from the Dictionary API.


            /// user starts the app, and [isAiWordsGenerationOn] is true, app will fetch specified number of words from the Gemini AI.
            /// now user switches [isAiWordsGenerationOn] to false, now the next words will be fetched from the Dictionary API.
            /// when we add event toload more Dictionary API words then we enter this else block.

            ///  if wordIndex is 0, we switch it to -1, so that when we add event [LoadSingleWordInOrderEvent] 
            /// we turn wordIndex to 0 via [++wordIndex], and fetch the first word from the allWords list.

            /// when will wordIndex be 0?
            /// If initial words are from Gemini AI then we switch it off(isAiWordsGenerationOn = false) then Dictionary API words will be loaded (in this case wordIndex will be 0).
            /// If initial words are from Dictionary API, wordIndex will be 0, but we won't enter this block, because event.autoLoad is true.

            if(wordIndex == 0) {
              wordIndex = -1;

            }
          }
        } else {
          final failure = receivedWords.failure!;

          if(failure is NoInternetFailure) {
            // any partial data we received from the Dictionary API before internet connection is lost, will be added to the allWords list.
            allWords.addAll(receivedWords.data ?? []);
            emit(InternetFailureState(wordNotSearched: failure.wordsNotSearched, wordSkipped: failure.wordsSkipped, wordRetrived: failure.wordsRetrieved));


          }

          if(failure is UnexpectedFailure) {
            emit(UnexpectedState(errorMessage: failure.errorMessage));
          }

          if (failure is PartialDataFailure) {

            // No actual error occurred, but we just couldn't fetch expected number of words from the Dictionary API.
            allWords.addAll(receivedWords.data!);
            emit(PartialDataState(wordFailedCount: failure.failedWordsCount, wordFetchedCount: failure.fetchedWordCount));
          }
          
          
          
        }
    });


    



    on<MoreWordsFetchLimitChangedEvent>((event, emit) {
      moreWordFetchLimit = event.changedLimit;
      WordFetchLimit.instance.changeWordFetchLimit(moreWordFetchLimit);
      emit(MoreWordsFetchLimitChangedState(changedLimit: moreWordFetchLimit));
    });


    // on<LaterLoadWords>(
    //   _onLaterLoadWords,
    //   transformer: throttleRestartable(),
    // );

    // on<GeminiFailureWordEvent>((event, emit) {
    //   emit(GeminiFailureWordState(errorMessage: event.errorMessage));
    // });



    on<SearchWord>((event, emit) async {

        emit(WordSearchLoadingState());
        // fetch a single word from the Dictionary API
        final Result<Word, DictionaryFailure> receivedWord = await repository.fetchWord(event.wordToSearch);

        if(receivedWord.isSuccess) {

          emit(WordSearchLoadSuccess(word: receivedWord.data!));

        } else {
          _mapFailuresToStates(receivedWord.failure!, emit);
        }

    });


    on<LoadSingleWordInOrderEvent>((event, emit) {
      // we increment wordIndex, and fetch the next word from the allWords list.
      if(++wordIndex < allWords.length) {
        emit(FetchedSingleWordState(word: allWords[wordIndex]));
      } else {
        // index for words exceeds allWords items
        emit(NoMoreWordAvailableState());
      }
    });



  }


  // Map the failures to the states
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


  // Future<void> _onLaterLoadWords(LaterLoadWords event, Emitter<WordState> emit) async {

  //     emit(LaterWordsLoading());
  //     final Result<List<Word>, DictionaryFailure> receivedWords = await repository.fetchRandomWords(event.noOfWordsToLoad);


  //     if(receivedWords.isSuccess) {
  //       allWords.addAll(receivedWords.data!);
  //       emit(LaterWordsLoadingSuccess());

  //     } else {
  //       if(receivedWords.failure!.runtimeType == PartialDataFailure) {
  //         allWords.addAll(receivedWords.data!);
  //       }

  //       if(receivedWords.failure!.runtimeType == NoInternetFailure) {
  //         allWords.addAll(receivedWords.data!);

  //       }

  //       _mapFailuresToStates(receivedWords.failure!, emit);
  //     }

  // }





}
