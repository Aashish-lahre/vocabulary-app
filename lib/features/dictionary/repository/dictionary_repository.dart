import 'package:dictionary_api/dictionary_api.dart';
import 'package:flutter_improve_vocabulary/core/utility/result.dart';
import '../utility/get_random_words.dart';
import 'package:flutter/material.dart';


class DictionaryRepository {


  final DictionaryApiClient _dictionaryApiClient;

  final Map<int, Word>  wordsAvailableOnApi = {};

  DictionaryRepository._({DictionaryApiClient? dictionaryApiClient}) : _dictionaryApiClient = dictionaryApiClient ?? DictionaryApiClient();

  static DictionaryRepository? _instance;

  factory DictionaryRepository({DictionaryApiClient? apiClient}) {

    return _instance ??=  DictionaryRepository._(dictionaryApiClient: apiClient);


   }


  Future<Result<Word, DictionaryFailure>> fetchWord(String queryWord) async {
    try {
      final retrivedWord = await _dictionaryApiClient.searchWord(queryWord);
      return Result<Word, DictionaryFailure>(data: retrivedWord);
    } on NoInternetFailure {
        return Result<Word, DictionaryFailure>(failure: NoInternetFailure(wordsRetrived: 0, wordsSkipped: 0, wordsNotSearched: 1));
    } on WordNotFoundFailure {
      return Result<Word, DictionaryFailure>(failure: WordNotFoundFailure());

    } on UnexpectedFailure catch (err){
      return Result<Word, DictionaryFailure>(failure: UnexpectedFailure(errorMessage: err.errorMessage));

    }

  }


  Future<Result<List<Word>, DictionaryFailure>> fetchRandomWords(int count) async {
    assert(count > 0);
    int wordSkipped = 0;

    final List<Word> receivedWords = [];
    // get "count" no. of random words from "getRandomWords" class.
    final List<({int index, String wordName})> randomWords = GetRandomWords().generateRandomWords(count: count);

    // for loop all the words and search each word one by one.
    // if successfully retrived the word, store it in "words" map.
    for (var entry in randomWords) {
      try {
        final retrivedWord = await _dictionaryApiClient.searchWord(entry.wordName);
        wordsAvailableOnApi[wordsAvailableOnApi.length + 1] = retrivedWord;
        GetRandomWords().wordsAvailableInApi(entry);
        receivedWords.add(retrivedWord);

      } on WordNotFoundFailure {

        // word is not available in dictionary Api

        // make this word does not come again in [generateRandomWords].
        GetRandomWords().wordNotAvailableInApi(entry);


        // Retry mechanism with max attempts for 1 new random word get from
        // "GetRandomWord" class.
        int maxRetries = 5;

        for (int i = 0; i < maxRetries; i++) {
          try {
            final List<({int index, String wordName})> newRandomWord = GetRandomWords().generateRandomWords(count: 1);
            final retrivedWord = await _dictionaryApiClient.searchWord(newRandomWord.first.wordName);

            // If successful, add the word in "words" map and exit retry loop
            wordsAvailableOnApi[wordsAvailableOnApi.length + 1] = retrivedWord;
            GetRandomWords().wordsAvailableInApi(newRandomWord.first);
            receivedWords.add(retrivedWord);
            break;

          } on WordNotFoundFailure {
            // Continue retrying in the same loop
            if (i == maxRetries - 1) {
              debugPrint("Skipping word after $maxRetries failed attempts.");
              wordSkipped++;
            }

            // we come here when we encounter NoInternetFailure when executing retry word block.
          } on NoInternetFailure {

            // If WordRequestFailure occurs, stop the entire function and
            // this method"fetchRandomWords" returns the updated "words" map.
            int wordsNotSearched = count - (receivedWords.length + wordSkipped);

            return Result<List<Word>, DictionaryFailure>(
              data: receivedWords,
              failure: NoInternetFailure(wordsRetrived: receivedWords.length, wordsSkipped: wordSkipped, wordsNotSearched: wordsNotSearched),
            );
          } on UnexpectedFailure catch(unExpectedFailureObject) {
            debugPrint('printing error from dictionary_repository.dart, '
                'this error is bubbled up to here(dictionary_repository.dart) from dictionary_api_client.dart');

            return Result(data: receivedWords, failure: UnexpectedFailure(errorMessage: unExpectedFailureObject.errorMessage));
          }
        }
      }
      // no Internet failure when code didn't enter retry block.

      // when we starts executing this whole function are immediately received no internet failure, we come here.
      on NoInternetFailure
      {

        // If WordRequestFailure occurs, stop the entire function and
        // this method"fetchRandomWords" returns the updated "words" map.
        int wordsNotSearched = count - (receivedWords.length + wordSkipped);

        return Result<List<Word>, DictionaryFailure>(
          data: receivedWords,
          failure: NoInternetFailure(wordsRetrived: receivedWords.length, wordsSkipped: wordSkipped, wordsNotSearched: wordsNotSearched),
        );
      }
      on UnexpectedFailure catch(unExpectedFailureObject) {
        debugPrint('printing error from dictionary_repository.dart, '
            'this error is bubbled up to here(dictionary_repository.dart) from dictionary_api_client.dart');

        return Result(data: receivedWords, failure: UnexpectedFailure(errorMessage: unExpectedFailureObject.errorMessage));
      }
    }
    return Result<List<Word>, DictionaryFailure>(data: receivedWords, failure: wordSkipped > 0 ? PartialDataFailure(fetchedWordCount: receivedWords.length, failedWordsCount: wordSkipped) : null);
  }


  void dispose() {
    _dictionaryApiClient.dispose();
  }

}