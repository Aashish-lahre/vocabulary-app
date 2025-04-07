

sealed class DictionaryFailure {}


final class NoInternetFailure extends DictionaryFailure {
  final int wordsRetrieved;
  final int wordsSkipped;
  final int wordsNotSearched;

  NoInternetFailure({this.wordsRetrieved = 0, this.wordsSkipped = 0, this.wordsNotSearched = 0});
}

// when api is unable to provide the valid data for the word you searched because the api does not have that word.
final class WordNotFoundFailure extends DictionaryFailure {}

final class UnexpectedFailure extends DictionaryFailure {
  final String errorMessage;

  UnexpectedFailure({required this.errorMessage});
}

// when we couldn't able to collect all the words as expected because of words
// not available on api and also in  5(initial limit, could have been changed) retries we couldn't find a word.
final class PartialDataFailure extends DictionaryFailure {
  final int failedWordsCount;
  final int fetchedWordCount;

  PartialDataFailure({required this.fetchedWordCount, required this.failedWordsCount});
}