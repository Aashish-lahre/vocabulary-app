import '../data/dictionary_api_client.dart';
import 'package:flutter_improve_vocabulary/core/utility/result.dart';
import '../data/dictionary_failures.dart';
import '../../../core/models/word.dart';
import '../utility/get_random_words.dart';
import 'package:flutter/material.dart';

/// A repository that talks to the Dictionary API to get word data.
///
/// This class uses a single instance of DictionaryApiClient to fetch words.
/// It can fetch a single word or a list of random words. It also
/// keeps a map of words we have already fetched from the API.
class DictionaryRepository {
  /// The API client that does the actual HTTP calls.
  final DictionaryApiClient _dictionaryApiClient;

  /// A map of all words we have fetched so far.
  /// The key is an auto-incrementing index, and the value is the Word object.
  final Map<int, Word> wordsAvailableOnApi = {};

  /// Private constructor to allow passing in a custom API client for testing.
  DictionaryRepository._({DictionaryApiClient? dictionaryApiClient})
      : _dictionaryApiClient = dictionaryApiClient ?? DictionaryApiClient();

  static DictionaryRepository? _instance;

  /// Factory constructor to return a single shared instance (singleton).
  /// You can optionally pass in a custom DictionaryApiClient.
  factory DictionaryRepository({DictionaryApiClient? apiClient}) {
    return _instance ??= DictionaryRepository._(
      dictionaryApiClient: apiClient,
    );
  }

  /// Fetch a single word from the API by its text.
  ///
  /// [queryWord] is the word to look up. Returns a Result object:
  /// - On success, data is the Word object.
  /// - On failure, failure is one of:
  ///   * NoInternetFailure: no network connection.
  ///   * WordNotFoundFailure: API does not know this word.
  ///   * UnexpectedFailure: some other error happened.
  Future<Result<Word, DictionaryFailure>> fetchWord(String queryWord) async {
    try {
      // Ask the API client to search for the word.
      final retrievedWord = await _dictionaryApiClient.searchWord(queryWord);
      return Result<Word, DictionaryFailure>(data: retrievedWord);
    } on NoInternetFailure {
      // We could not reach the server at all. This means:
      // - wordsRetrieved: how many words we got before the failure (here 0).
      // - wordsSkipped: how many words were skipped because they were not found (here 0).
      // - wordsNotSearched: how many words we did not even try to fetch because the internet was down (here 1).
      return Result<Word, DictionaryFailure>(
        failure: NoInternetFailure(
          wordsRetrieved: 0,      // number of words successfully retrieved before failure
          wordsSkipped: 0,       // number of words skipped due to not found
          wordsNotSearched: 1,   // number of words not searched due to no internet
        ),
      );
    } on WordNotFoundFailure {
      // The API responded but the word was not found.
      return Result<Word, DictionaryFailure>(
        failure: WordNotFoundFailure(),
      );
    } on UnexpectedFailure catch (err) {
      // Some other error happened. Pass the message along.
      return Result<Word, DictionaryFailure>(
        failure: UnexpectedFailure(errorMessage: err.errorMessage),
      );
    }
  }

  /// Fetch a list of [count] random words from the API.
  ///
  /// This method:
  /// 1. Generates [count] random strings.
  /// 2. Tries to fetch each one from the API.
  /// 3. If a word is not found, it retries up to 5 times with new random words.
  /// 4. If there is a network error, it stops and returns what it has so far.
  ///
  /// Returns a Result containing:
  /// - data: list of Word objects that were found.
  /// - failure: if some words were skipped or a network error occurred.
  Future<Result<List<Word>, DictionaryFailure>> fetchRandomWords(
      int count) async {
    // Make sure the caller asked for at least 1 word.
    if (count <= 0) {
      return Result(
        failure: UnexpectedFailure(
          errorMessage: 'Count must be greater than zero.',
        ),
      );
    }

    // How many words we could not find even after retries.
    int wordSkipped = 0;

    // List of words we successfully got from the API.
    final List<Word> receivedWords = [];

    // Ask for [count] random strings to look up.
    final List<String> randomWords =
    GetRandomWords().generateRandomWords(count: count);

    // For each random string, try to fetch it.
    for (var word in randomWords) {
      try {
        final retrievedWord = await _dictionaryApiClient.searchWord(word);
        // Store in our map and list.
        wordsAvailableOnApi[wordsAvailableOnApi.length + 1] = retrievedWord;
        GetRandomWords().wordsAvailableInApi(word);
        receivedWords.add(retrievedWord);
      } on WordNotFoundFailure {
        // Word is not in the API.
        // This word will not be requested again from generateRandomWords.
        GetRandomWords().wordNotAvailableInApi(word);

        // Retry up to 5 times with new words.
        const int maxRetries = 5;
        for (int i = 0; i < maxRetries; i++) {
          try {
            final newWordList =
            GetRandomWords().generateRandomWords(count: 1);
            final newWord = newWordList.first;
            final retrievedWord =
            await _dictionaryApiClient.searchWord(newWord);
            // If found, add and break out of retry loop.
            wordsAvailableOnApi[wordsAvailableOnApi.length + 1] =
                retrievedWord;
            GetRandomWords().wordsAvailableInApi(newWord);
            receivedWords.add(retrievedWord);
            break;
          } on WordNotFoundFailure {
            // If this was the last retry, count it as skipped.
            if (i == maxRetries - 1) {
              debugPrint('Skipping word after $maxRetries failed attempts.');
              wordSkipped++;
            }
            // Otherwise, try again.
          } on NoInternetFailure {
            // Network error during retry: stop everything and return.
            int wordsNotSearched =
                count - (receivedWords.length + wordSkipped);
            return Result<List<Word>, DictionaryFailure>(
              data: receivedWords,
              failure: NoInternetFailure(
                wordsRetrieved: receivedWords.length,
                wordsSkipped: wordSkipped,
                wordsNotSearched: wordsNotSearched,
              ),
            );
          } on UnexpectedFailure catch (err) {
            // Some other error happened: stop and return.
            print('entered here in unexpected error');
            return Result(
              data: receivedWords,
              failure: UnexpectedFailure(errorMessage: err.errorMessage),
            );
          }
        }
      } on NoInternetFailure {
        // Network error on the first attempt: stop and return.
        // Internet was down when this function was called.
        int wordsNotSearched = count - (receivedWords.length + wordSkipped);
        return Result<List<Word>, DictionaryFailure>(
          data: receivedWords,
          failure: NoInternetFailure(
            wordsRetrieved: receivedWords.length,
            wordsSkipped: wordSkipped,
            wordsNotSearched: wordsNotSearched,
          ),
        );
      } on UnexpectedFailure catch (err) {
        // Some other error happened on the first attempt: stop and return.
        debugPrint(
          'Error in fetchRandomWords: ${err.errorMessage}',
        );
        return Result(
          data: receivedWords,
          failure: UnexpectedFailure(errorMessage: err.errorMessage),
        );
      }
    }

    // All done: return what we have.
    // If any words were skipped, use PartialDataFailure to explain.
    return Result<List<Word>, DictionaryFailure>(
      data: receivedWords,
      failure: wordSkipped > 0
          ? PartialDataFailure(
        fetchedWordCount: receivedWords.length,
        failedWordsCount: wordSkipped,
      )
          : null,
    );
  }

  /// Clean up resources when this repository is no longer needed.
  void dispose() {
    _dictionaryApiClient.dispose();
  }
}
