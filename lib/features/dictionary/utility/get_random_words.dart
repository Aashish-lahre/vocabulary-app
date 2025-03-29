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
  final Map<int, ({String wordName, int index})> theseWordsNotFoundOnApi = {};
  final Map<int, ({String wordName, int index})> theseWordsFoundOnApi = {};
  final List<String> allWords = List.from(all);


  // when the word is not available in DictionaryApi, we call this function to
  // remove the word from "allWords" and include it in "theseWordsNotFoundOnApi".
  void wordNotAvailableInApi(({String wordName, int index}) word) {
    // we remove the word from "allWords" because we than do not have to filter
    // out these words again when randomly selecting word from "allWords".
    // allWords.removeAt(word.index);
      allWords.remove(word.wordName);
    // know what words does not have data on DictionaryApi

    final  addEntry = {
      theseWordsNotFoundOnApi.length + 1 : (wordName: word.wordName, index: word.index),
    };

    theseWordsNotFoundOnApi.addEntries(addEntry.entries);
  }

  void wordsAvailableInApi(({String wordName, int index}) word) {
    allWords.remove(word.wordName);

    final  addEntry = {
      theseWordsFoundOnApi.length + 1 : (wordName: word.wordName, index: word.index),
    };

    theseWordsFoundOnApi.addEntries(addEntry.entries);
  }


  // generate count no. of words from "allWords" list.
  // it also filter out all the words from wordNotAvailableInApi.
  Map<int, ({String wordName, int index})> generateRandomWords({required int count}) {

  final random = Random();
  // set of records is used to prevent duplicate record
  final Set<({String wordName, int index})> setOfWords = {};

  // while function to get "count" words in a "words" set.
  while (setOfWords.length < count) {

    // checking is allWords is not empty because in later code "allWords.length"
    // should be more than 0. it will prevent nextInt(0) error.
    assert(allWords.isNotEmpty);

    // random index of allWords
    final int index = random.nextInt(allWords.length);

    // adding a record of "words" set.
    setOfWords.add(
        (wordName: allWords[index], index: index) // record
    );


  }

  // this code converts the set of records into map<int, record>
  Map<int, ({String wordName, int index})> words = {
    for(var entry in setOfWords.toList().asMap().entries) entry.key + 1 : entry.value
  };

  return words;
  }









}