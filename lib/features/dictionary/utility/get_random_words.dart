import 'dart:math';

import 'package:english_words/english_words.dart' show all;

class GetRandomWords {



  GetRandomWords._();

  static final GetRandomWords instance = GetRandomWords._();

  factory GetRandomWords() {
    return instance;
  }


  // These words are not available in DictionaryApi.
  //https://dictionaryapi.dev/
  final Map<int, String> theseWordsNotFoundOnApi = {};
  final Map<int, String> theseWordsFoundOnApi = {};

  // all Words from "all list in english_words" package
  List<String> allWords = List.from(all);


  // when the word is not available in DictionaryApi, we call this function to
  // remove the word from "allWords" and include it in "theseWordsNotFoundOnApi".
  void wordNotAvailableInApi(String wordName) {
    // we remove the word from "allWords" because we than do not have to filter
    // out these words again when randomly selecting word from "allWords".
      allWords.remove(wordName);



    // "theseWordsNotFoundOnApi" is used to know what words does not have data on DictionaryApi
    final  addEntry = {
      theseWordsNotFoundOnApi.length + 1 : wordName,
    };

    theseWordsNotFoundOnApi.addEntries(addEntry.entries);
  }

  void wordsAvailableInApi(String wordName) {

    // removing available word from "allWords" so this word can not be randomly selected again.
    allWords.remove(wordName);

    final  addEntry = {
      theseWordsFoundOnApi.length + 1 : wordName,
    };

    theseWordsFoundOnApi.addEntries(addEntry.entries);
  }


  // generate "count" number of words from "allWords" list.
  // it also filter out all the words from wordNotAvailableInApi.
  List<String> generateRandomWords({required int count}) {

    // if "allWords" about to go empty, we reassign "allWords" to "theseWordsFoundOnApi"
    // and repeat available words again.
    if(allWords.length <= count) {
      allWords.clear();
      theseWordsFoundOnApi.values.toList().forEach((item) {allWords.add(item);});
    }

  final random = Random();
  // set of records is used to prevent duplicate record
  final Set<String>  setOfWords = {};

  // while function to get "count" no. of words in a "words" set.
  while (setOfWords.length < count) {


    // random index of allWords
    final int index = random.nextInt(allWords.length);

    // adding word in "words" set.
    setOfWords.add(
        allWords[index]
    );


  }

  List<String> words = setOfWords.toList();



  return words;
  }









}