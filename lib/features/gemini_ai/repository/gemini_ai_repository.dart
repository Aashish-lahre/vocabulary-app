import 'dart:convert';

import 'package:flutter_improve_vocabulary/core/utility/result.dart';
import 'package:flutter_improve_vocabulary/features/gemini_ai/configuration/configuration.dart';
import 'package:flutter_improve_vocabulary/features/gemini_ai/repository/gemini_errors.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../model/ai_word.dart';



final String _apiKey = String.fromEnvironment("API_KEY");

class GeminiRepository {

  static GeminiRepository?  instance;

  GeminiRepository._();

  factory GeminiRepository() {
    return instance ??= GeminiRepository._();
  }




  final model = GenerativeModel(
    model: 'gemini-2.5-pro-exp-03-25',
    apiKey: _apiKey,

  );


  Future<Result<List<AiWord>, GeminiError>> generateWords(String prompt) async {

    final List<Content> content = [Content.text(prompt)];
    late Result<List<AiWord>, GeminiError> response;
    try {

    final generateContentResponse = await model.generateContent(content, generationConfig: configurationForWords);

    response = processResponse(generateContentResponse.text!);

    } on GenerativeAIException catch(err) {
      // GenerativeAiException is a super type of all gemini exception,
      // so we don't require to handle other types of gemini exceptions because GenerativeAIException handles all of them.
      return Result(failure: GeminiGenerativeAiException(errorMessage: err.message));
    } catch (err) {
      // some unexpected exception
      return Result(failure: GeminiUnexpectedFailure(errorMessage: err.toString()));
    }





    return response;
  }





}


// Result<List<AiWord>, GeminiError> processResponse(String text) {
//    List<AiWord> aiWords = [];
//   try {
//     // Attempt to parse the text as JSON
//     final dynamic jsonData = jsonDecode(text);
//
//     // Check if it's a List and contains only Maps
//     if (jsonData is List && jsonData.every((item) => item is Map<String, dynamic>)) {
//       // Loop through each object
//       for (Map<String, dynamic> jsonObj in jsonData) {
//
//         aiWords.add(AiWord.fromJson(jsonObj));
//       }
//     } else {
//       return Result(failure: GeminiResponseFormatException(errorMessage: 'Response is not in the expected JSON array format.'));
//
//     }
//   } catch (e) {
//     return Result(failure: GeminiResponseFormatException(errorMessage: 'Invalid JSON format: $e'));
//
//   }
//
//   return Result(data: aiWords);
// }


Result<List<AiWord>, GeminiError> processResponse(String text) {
  // Check if the response is empty
  if (text.trim().isEmpty) {
    return Result(
      failure: GeminiResponseFormatException(errorMessage: 'Response is empty.'),
    );
  }

  try {
    // Attempt to parse JSON
    final jsonData = jsonDecode(text)  as List<dynamic>;
    // Ensure jsonData is a List
    // if (jsonData is! List) {
    //   return Result(
    //     failure: GeminiResponseFormatException(
    //       errorMessage: 'Expected a JSON array but got ${jsonData.runtimeType}.',
    //     ),
    //   );
    // }

    // Ensure every item in the list is a Map<String, dynamic>
    final condition = !jsonData.every((item) => item is Map<String, dynamic>);
    if (condition) {
      return Result(
        failure: GeminiResponseFormatException(
          errorMessage: 'List contains non-object elements.',
        ),
      );
    }

    // Parse all items into AiWord objects
    final List<AiWord> aiWords = jsonData.map((jsonObj) {

      return AiWord.fromJson(jsonObj as Map<String, dynamic> );

    }).toList();
    return Result(data: aiWords);
  } catch (e) {
    return Result(
      failure: GeminiResponseFormatException(
        errorMessage: 'Invalid JSON format: ${e.toString()}',
      ),
    );
  }
}
