import 'package:dictionary_api/dictionary_api.dart';

class DictionaryRepository {
  
  final DictionaryApiClient _dictionaryApiClient;

  DictionaryRepository({DictionaryApiClient? dictionaryApiClient}) : _dictionaryApiClient = dictionaryApiClient ?? DictionaryApiClient();

  Future<Word> fetchWord(String queryWord) async {
    print('fetchWord on repo arrived');
    final retrivedWord = await _dictionaryApiClient.searchWord(queryWord);
    return retrivedWord;
  }

  
}