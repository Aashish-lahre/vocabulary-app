import 'dart:convert';

import 'package:flutter_improve_vocabulary/core/utility/result.dart';
import 'package:flutter_improve_vocabulary/features/gemini_ai/configuration/configuration.dart';
import 'package:flutter_improve_vocabulary/features/gemini_ai/prompts/prompts.dart';
import 'package:flutter_improve_vocabulary/features/gemini_ai/repository/gemini_errors.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_improve_vocabulary/api_key.dart';

import '../data_model/ai_word.dart';






class GeminiRepository {

  static GeminiRepository?  instance;

  GeminiRepository._();

  factory GeminiRepository() {
    return instance ??= GeminiRepository._();
  }







  Future<Result<List<AiWord>, GeminiError>> generateWords(String prompt, GenerativeModel  model) async {

    final List<Content> content = [Content.text(prompt)];
    late Result<List<AiWord>, GeminiError> response;
    try {

    final generateContentResponse = await model.generateContent(content, generationConfig: configurationForWords);

    response = processResponseForWords(generateContentResponse.text!);

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


  Future<Result<List<String>, GeminiError>> generateExamples(String word, int limit, List<String> filterOut, GenerativeModel  model) async {

    final List<Content> content = [Content.text(promptForExample(word, limit, filterOut))];
    late Result<List<String>, GeminiError> response;
    try {

      final generateContentResponse = await model.generateContent(content, generationConfig: configurationForExample);

      response = processResponseForExamples(generateContentResponse.text!);

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


  Future<Result<List<String>, GeminiError>> generateSynonyms(String word, int limit, List<String> filterOut, GenerativeModel  model) async {

    final List<Content> content = [Content.text(promptForSynonyms(word, limit, filterOut))];
    late Result<List<String>, GeminiError> response;
    try {

      final generateContentResponse = await model.generateContent(content, generationConfig: configurationForSynonyms);

      response = processResponseForSynonymsAndAntonyms(generateContentResponse.text!);

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



  Future<Result<List<String>, GeminiError>> generateAntonyms(String word, int limit, List<String> filterOut, GenerativeModel  model) async {

    final List<Content> content = [Content.text(promptForAntonyms(word, limit, filterOut))];
    late Result<List<String>, GeminiError> response;
    try {

      final generateContentResponse = await model.generateContent(content, generationConfig: configurationForAntonyms);

      response = processResponseForSynonymsAndAntonyms(generateContentResponse.text!);

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



Result<List<AiWord>, GeminiError> processResponseForWords(String text) {
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

Result<List<String>, GeminiError> processResponseForExamples(String text) {
  // Check if the response is empty
  if (text.trim().isEmpty) {
    return Result(
      failure: GeminiResponseFormatException(errorMessage: 'Response is empty.'),
    );
  }

  try {
    // Attempt to parse JSON
    final jsonData = jsonDecode(text)  as List<dynamic>;

    final condition = !jsonData.every((item) => item is String);
    if (condition) {
      return Result(
        failure: GeminiResponseFormatException(
          errorMessage: 'Example items are not String.',
        ),
      );
    }

    final List<String> examples = jsonData.map((item) => item as String).toList();

    return Result(data: examples);
  } catch (e) {
    return Result(
      failure: GeminiResponseFormatException(
        errorMessage: 'Invalid JSON format: ${e.toString()}',
      ),
    );
  }
}

Result<List<String>, GeminiError> processResponseForSynonymsAndAntonyms(String text) {
  // Check if the response is empty
  if (text.trim().isEmpty) {
    return Result(
      failure: GeminiResponseFormatException(errorMessage: 'Response is empty.'),
    );
  }

  try {
    // Attempt to parse JSON
    final jsonData = jsonDecode(text)  as List<dynamic>;

    final condition = !jsonData.every((item) => item is String);
    if (condition) {
      return Result(
        failure: GeminiResponseFormatException(
          errorMessage: 'items are not String.',
        ),
      );
    }

    final List<String> items = jsonData.map((item) => item as String).toList();

    return Result(data: items);
  } catch (e) {
    return Result(
      failure: GeminiResponseFormatException(
        errorMessage: 'Invalid JSON format: ${e.toString()}',
      ),
    );
  }
}


