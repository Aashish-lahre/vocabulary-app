


import 'dart:async';
import 'dart:convert';
import 'dart:io';


import 'package:dictionary_api/dictionary_api.dart';
import 'package:http/http.dart' as http;

const url = "https://api.dictionaryapi.dev/api/v2/entries/en";

// failure when no internet is available
class WordRequestFailure implements Exception {

}

// failure when word is not found in api
class WordNotFoundFailure implements Exception {}


abstract class DictionaryServices {
  Future<Word> searchWord(String word);
}


class DictionaryApiClient implements DictionaryServices{
  final http.Client client;
  DictionaryApiClient({ http.Client? client}) : client = client ?? http.Client() ;

  // this method searches the word in api, fetches the word json, converts the word json into word object with all information embedded
  @override
  Future<Word> searchWord(String word) async {

    try {
      final uri = Uri.parse('$url/$word');


      final response = await client.get(uri);

      print('response code : ${response.statusCode}');

      if(response.statusCode != 200) throw WordNotFoundFailure();

      final responseJsonArray = jsonDecode(response.body) as List<dynamic>;
      final responseJson = responseJsonArray.first;

      if(!responseJson.containsKey('word')) throw WordNotFoundFailure();

      return Word.fromJson(responseJson);
    } on SocketException {
      throw WordRequestFailure();
    } on TimeoutException {
      throw WordRequestFailure();

    } on WordNotFoundFailure {
      throw WordNotFoundFailure();
    }

    catch(err) {
      print('error catch on api client : $err');
      throw Exception(err);
    }

  }

  void dispose() => client.close();
}