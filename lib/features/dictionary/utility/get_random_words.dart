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
  List<String> allWords = List.from(all);


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
  List<({String wordName, int index})> generateRandomWords({required int count}) {

    if(allWords.length <= count) {
      allWords.clear();
      theseWordsFoundOnApi.values.toList().forEach((item) {allWords.add(item.wordName);});
    }

  final random = Random();
  // set of records is used to prevent duplicate record
  final Set<({String wordName, int index})> setOfWords = {};

  // while function to get "count" no. of words in a "words" set.
  while (setOfWords.length < count) {


    // random index of allWords
    final int index = random.nextInt(allWords.length);

    // adding a record of "words" set.
    setOfWords.add(
        (wordName: allWords[index], index: index) // record
    );


  }

  List<({String wordName, int index})> words = setOfWords.toList();



  return words;
  }









}