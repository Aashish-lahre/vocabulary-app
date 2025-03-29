


import 'dart:async';
import 'dart:convert';
import 'dart:io';


import 'package:dictionary_api/dictionary_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dictionary_failures.dart';


const url = "https://api.dictionaryapi.dev/api/v2/entries/en";





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


      final response = await client.get(uri).timeout(Duration(seconds: 10));

      debugPrint('response code : ${response.statusCode}');

      if (response.statusCode == 404) {
        throw WordNotFoundFailure();
      } else if (response.statusCode == 429) {
        throw Exception('Rate limit exceeded. Please try again later.');
      } else if (response.statusCode >= 500) {
        throw Exception('Server error. Please try again later.');
      } else if (response.statusCode != 200) {
        throw Exception('Unexpected API response: ${response.statusCode}');
      }


      final responseJsonArray = jsonDecode(response.body) as List<dynamic>;
      final responseJson = responseJsonArray.first;

      if(!responseJson.containsKey('word')) throw WordNotFoundFailure();

      return Word.fromJson(responseJson);
    } on SocketException {
      throw NoInternetFailure();
    } on TimeoutException {
      throw NoInternetFailure();
    } on WordNotFoundFailure {
      rethrow;
    }

    catch(err, stackTrace) {
      debugPrint('error catch on api client : $err');
      debugPrintStack(stackTrace: stackTrace);
      throw UnexpectedFailure(errorMessage: err.toString());
    }

  }

  void dispose() => client.close();
}