import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/word.dart';
import './dictionary_failures.dart';

/// Base URL for the dictionary API.
/// We will append the word to this URL to form the full request.
const url = 'https://api.dictionaryapi.dev/api/v2/entries/en';

/// Defines how to search for a word in a dictionary.
/// Implement this to provide different dictionary backends.
abstract class DictionaryServices {
  /// Look up [word] and return a [Word] object.
  /// Throws a [DictionaryFailure] if the lookup fails.
  Future<Word> searchWord(String word);
}

/// Uses the free dictionary API to fetch word data.
/// Implements [DictionaryServices].
class DictionaryApiClient implements DictionaryServices {
  /// HTTP client used for network calls.
  final http.Client client;

  /// Create a client. You can pass a custom [client] for testing.
  DictionaryApiClient({http.Client? client})
      : client = client ?? http.Client();

  /// Search for [word] by sending an HTTP GET request.
  ///
  /// Steps:
  /// 1. Build the request URI: "\$url/\$word".
  /// 2. Send the GET request with a 10-second timeout.
  /// 3. Check status code:
  ///    - 404: throw [WordNotFoundFailure].
  ///    - 429: throw generic Exception('Rate limit exceeded').
  ///    - >=500: throw generic Exception('Server error').
  ///    - other !=200: throw generic Exception('Unexpected API response').
  /// 4. Parse the JSON response as a list, take first item.
  /// 5. If JSON lacks 'word' key: throw [WordNotFoundFailure].
  /// 6. Convert JSON to [Word] and return.
  ///
  /// Error handling:
  /// - [SocketException] or [TimeoutException]: throw [NoInternetFailure].
  /// - [WordNotFoundFailure]: rethrow for caller to handle.
  /// - [http.ClientException]: if message == 'Connection reset by peer',
  ///   throw [NoInternetFailure]; else throw [UnexpectedFailure].
  /// - any other error: wrap in [UnexpectedFailure] after logging.
  @override
  Future<Word> searchWord(String word) async {
    try {
      final uri = Uri.parse('\$url/\$word');
      final response = await client.get(uri).timeout(const Duration(seconds: 10));
      debugPrint('Response status: \${response.statusCode}');

      if (response.statusCode == 404) {
        // Word not found.
        throw WordNotFoundFailure();
      } else if (response.statusCode == 429) {
        // Rate limit exceeded.
        throw Exception('Rate limit exceeded. Please try again later.');
      } else if (response.statusCode >= 500) {
        // Server error.
        throw Exception('Server error. Please try again later.');
      } else if (response.statusCode != 200) {
        // Unexpected status code.
        throw Exception('Unexpected API response: \${response.statusCode}');
      }

      // Parse the response body as JSON array.
      final List<dynamic> jsonArray = jsonDecode(response.body);
      final Map<String, dynamic> jsonMap = jsonArray.first as Map<String, dynamic>;

      if (!jsonMap.containsKey('word')) {
        // Missing 'word' key means no valid data.
        throw WordNotFoundFailure();
      }

      // Convert JSON map to Word object.
      return Word.fromJson(jsonMap);
    } on SocketException {
      // No network connection.
      throw NoInternetFailure();
    } on TimeoutException {
      // Request timed out.
      throw NoInternetFailure();
    } on WordNotFoundFailure {
      // Rethrow so caller can handle missing word.
      rethrow;
    } on http.ClientException catch (e) {
      debugPrint('HTTP client error: \${e.message}');
      if (e.message == 'Connection reset by peer') {
        // Treat as no internet.
        throw NoInternetFailure();
      } else {
        throw UnexpectedFailure(errorMessage: e.message);
      }
    } catch (err, stack) {
      // Any other error: log and wrap.
      debugPrint('Unexpected error in API client: \$err');
      debugPrintStack(stackTrace: stack);
      throw UnexpectedFailure(errorMessage: err.toString());
    }
  }

  /// Close the HTTP client to free resources.
  void dispose() => client.close();
}
