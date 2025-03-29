

sealed class DictionaryFailure {}


final class NoInternetFailure extends DictionaryFailure {}

// when api is unable to provide the valid data for the word you searched because the api does not have that word.
final class WordNotFoundFailure extends DictionaryFailure {}

final class UnexpectedFailure extends DictionaryFailure {
  final String? errorMessage;

  UnexpectedFailure({this.errorMessage});
}