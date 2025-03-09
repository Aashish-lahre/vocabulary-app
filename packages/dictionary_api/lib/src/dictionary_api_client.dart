


import 'dart:convert';


import 'package:dictionary_api/dictionary_api.dart';
import 'package:http/http.dart' as http;



// failure when no internet is available
class WordRequestFailure implements Exception {

}

// failure when word is not found in api
class WordNotFoundFailure implements Exception {}


class DictionaryApiClient {


  // final http.Client _httpClient;



  // if no dependency is provided, DictionaryApiClient will automatically takes one new http.Client as dependency
  DictionaryApiClient();

  static const url = "https://api.dictionaryapi.dev";



  // this method searches the word in api, fetches the word json, converts the word json into word object with all information embedded
  Future<Word> searchWord(String word) async {
    print('search word on api arrived');

    // final urlRequest = Uri.https(url, '/api/v2/entries/en/$word');
    // final urlResponse = await _httpClient.get(urlRequest);
    final urlResponse = await http.get(
    Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word'),
  );


    if(urlResponse.statusCode != 200) throw WordRequestFailure();

    final responseJsonArray = jsonDecode(urlResponse.body) as List<dynamic>;
    final responseJson = responseJsonArray.first;

    if(!responseJson.containsKey('word')) throw WordNotFoundFailure();

    return Word.fromJson(responseJson);

  }
  // void close() {
  //   _httpClient.close();
  // }

}