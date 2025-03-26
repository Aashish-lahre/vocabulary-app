import 'package:dictionary_api/dictionary_api.dart';
import 'package:dictionary_repository/src/helpers/get_random_words.dart';

/*
get 10 words

search for each of them
  if success
    store them in a list.
  if wordNotFound failure
    get another word
 */

class DictionaryRepository {


  final DictionaryApiClient _dictionaryApiClient;

  final Map<int, Word>  words = {};

  DictionaryRepository._({DictionaryApiClient? dictionaryApiClient}) : _dictionaryApiClient = dictionaryApiClient ?? DictionaryApiClient();

  static DictionaryRepository? _instance;

  factory DictionaryRepository({DictionaryApiClient? apiClient}) {

    _instance ??=  DictionaryRepository._(dictionaryApiClient: apiClient);


    return _instance!;
   }


  Future<Word> fetchWord(String queryWord) async {
    print('fetchWord on repo arrived');
    final retrivedWord = await _dictionaryApiClient.searchWord(queryWord);
    return retrivedWord;
  }

  // void fetchRandomWords(int count) async {
  //   assert(count > 0);
  //   final Map<int, ({int index, String wordName})> randomWords = GetRandomWords().generateRandomWords(count: count);
  //
  //   while (words.length < count) {
  //     try {
  //       // itemNo is incrementing no. starting from 1.
  //       final int itemNo = words.length + 1;
  //       String wordString = randomWords[itemNo]!.wordName;
  //
  //       final retrivedWord = await _dictionaryApiClient.searchWord(wordString);
  //       words[itemNo] = retrivedWord;
  //
  //     } on WordNotFoundFailure catch (_) {
  //       // Retry mechanism with a max attempt limit
  //       int maxRetries = 5;
  //       int attempts = 0;
  //
  //       while (attempts < maxRetries) {
  //         try {
  //           attempts++;
  //           final Map<int, ({int index, String wordName})> randomWord = GetRandomWords().generateRandomWords(count: 1);
  //           final retrivedWord = await _dictionaryApiClient.searchWord(randomWord[1]!.wordName);
  //
  //           // If successful, add the word and exit the loop
  //           words[words.length + 1] = retrivedWord;
  //           break;
  //
  //         } on WordNotFoundFailure {
  //           // Continue retrying until maxRetries is reached
  //           if (attempts >= maxRetries) {
  //             print("Skipping word after $maxRetries failed attempts.");
  //             break;
  //           }
  //         } on WordRequestFailure {
  //           // If WordRequestFailure occurs, stop the loop immediately
  //           print("Request failed. Stopping retries.");
  //           return;
  //         }
  //       }
  //     }
  //   }
  // }

  Future<Map<int, Word>> fetchRandomWords(int count) async {
    assert(count > 0);
    // get "count" no. of random words from "getRandomWords" class.
    final Map<int, ({int index, String wordName})> randomWords = GetRandomWords().generateRandomWords(count: count);
    randomWords[3] = (index: 12, wordName: 'ddd');
    randomWords[5] = (index: 32, wordName: 'fff');
    // for loop all the words and search each word one by one.
    // if successfully retrived the word, store it in "words" map.
    for (var entry in randomWords.values) {
      try {
        final retrivedWord = await _dictionaryApiClient.searchWord(entry.wordName);
        words[words.length + 1] = retrivedWord;

      } on WordNotFoundFailure {

        // word is not available in dictionary Api

        // make this word does not come again in [generateRandomWords].
        GetRandomWords().wordNotAvailableInApi(entry);


        // Retry mechanism with max attempts for 1 new random word get from
        // "GetRandomWord" class.
        int maxRetries = 5;
        for (int i = 0; i < maxRetries; i++) {
          try {
            final Map<int, ({int index, String wordName})> newRandomWord = GetRandomWords().generateRandomWords(count: 1);
            final retrivedWord = await _dictionaryApiClient.searchWord(newRandomWord[1]!.wordName);

            // If successful, add the word in "words" map and exit retry loop
            words[words.length + 1] = retrivedWord;
            break;

          } on WordNotFoundFailure {
            // Continue retrying in the same loop
            if (i == maxRetries - 1) {
              print("Skipping word after $maxRetries failed attempts.");
            }

          } on WordRequestFailure {
            // "WordRequestFailure" is meant for No Internet Connection error.
            // If WordRequestFailure occurs, stop the entire function and
            // "fetchRandomWords" returns the updated "words" map.
            print("Request failed. Stopping word fetching.");

            throw WordRequestFailure();
          } catch(err){

            print('error catch on repo : $err');
            rethrow;
          }
        }
      }
    }
    return words;
  }


  void dispose() {
    _dictionaryApiClient.dispose();
  }

}