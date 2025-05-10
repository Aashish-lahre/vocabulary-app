import 'dart:convert';

import 'package:flutter_improve_vocabulary/features/gemini_ai/quiz/configuration.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../../core/utility/result.dart';
import "../gemini_errors.dart";







class GeminiRepositoryForQuiz {

  static GeminiRepositoryForQuiz?  instance;

  GeminiRepositoryForQuiz._();

  factory GeminiRepositoryForQuiz() {
    return instance ??= GeminiRepositoryForQuiz._();
  }

  Future<Result<List<Map<String, String>>, GeminiError>> generateQuizQuestions(String prompt, GenerativeModel model) async {
    final List<Content> content = [Content.text(prompt)];
    late Result<List<Map<String, String>>, GeminiError> response;
    try {

    final generateContentResponse = await model.generateContent(content, generationConfig: configurationForQuizQuestions);

    response = processResponseForQuizQuestions(generateContentResponse.text!);

    } on InvalidApiKey catch (err) {

      return Result(failure: GeminiInvalidApiKey(errorMessage: err.message));
    } 
    
    
    
    on GenerativeAIException catch(err) {
      // GenerativeAiException is a super type of all gemini exception,
      // so we don't require to handle other types of gemini exceptions because GenerativeAIException handles all of them.
      return Result(failure: GeminiGenerativeAiException(errorMessage: err.message));
    } catch (err) {
      // some unexpected exception
      return Result(failure: GeminiUnexpectedFailure(errorMessage: err.toString()));
    }





    return response;
  }

  Future<Result<Map<String, dynamic>, GeminiError>> evaluateQuizAnswer(String prompt, GenerativeModel model) async {
    final List<Content> content = [Content.text(prompt)];
    late Result<Map<String, dynamic>, GeminiError> response;
    try {

    final generateContentResponse = await model.generateContent(content, generationConfig: configurationForAnswerEvalution);

    response = processResponseForAnswerEvaluation(generateContentResponse.text!);

    } on InvalidApiKey catch (err) {

      return Result(failure: GeminiInvalidApiKey(errorMessage: err.message));
    } 
    
    
    
    on GenerativeAIException catch(err) {
      // GenerativeAiException is a super type of all gemini exception,
      // so we don't require to handle other types of gemini exceptions because GenerativeAIException handles all of them.
      return Result(failure: GeminiGenerativeAiException(errorMessage: err.message));
    } catch (err) {
      // some unexpected exception
      return Result(failure: GeminiUnexpectedFailure(errorMessage: err.toString()));
    }





    return response;
  }


Result<List<Map<String, String>>, GeminiError> processResponseForQuizQuestions(String text) {
  // Check if the response is empty
  if (text.trim().isEmpty) {
    return Result(
      failure: GeminiResponseFormatException(errorMessage: 'Response is empty.'),
    );
  }

  try {
    // Attempt to parse JSON
    
    final jsonData = jsonDecode(text) as Map<String, dynamic>;

    // Ensure the 'questions' key exists and is a list
    if (!jsonData.containsKey('questions') || jsonData['questions'] is! List) {
      return Result(
        failure: GeminiResponseFormatException(
          errorMessage: "Invalid format: 'questions' key is missing or not a list.",
        ),
      );
    }

    final questionsList = jsonData['questions'] as List;

    // Validate each item in the list
    final condition = questionsList.any(
      (item) => item is! Map || !item.containsKey('question') || !item.containsKey('expectedAnswer'),
    );

    if (condition) {
      return Result(
        failure: GeminiResponseFormatException(
          errorMessage: 'One or more questions are improperly formatted.',
        ),
      );
    }

    // Cast each item safely
    final List<Map<String, String>> quizQuestions = questionsList
        .map((item) => (item as Map).map(
              (key, value) => MapEntry(key.toString(), value.toString()),
            ))
        .toList();

    return Result(data: quizQuestions);
  } catch (e) {
    return Result(
      failure: GeminiResponseFormatException(
        errorMessage: 'Invalid JSON format: ${e.toString()}',
      ),
    );
  }
}

Result<Map<String, dynamic>, GeminiError> processResponseForAnswerEvaluation(String text) {
  // Check if the response is empty
  if (text.trim().isEmpty) {
    return Result(
      failure: GeminiResponseFormatException(errorMessage: 'Response is empty.'),
    );
  }

  try {
    // Attempt to parse JSON
  
    final jsonData = jsonDecode(text);

    if (jsonData is! Map<String, dynamic>) {
      return Result(
        failure: GeminiResponseFormatException(
          errorMessage: 'Invalid format: Expected a JSON object.',
        ),
      );
    }

    // Validate required keys
    if (!jsonData.containsKey('isCorrect') ||
        !jsonData.containsKey('correctAnswer') ||
        !jsonData.containsKey('feedback')) {
      return Result(
        failure: GeminiResponseFormatException(
          errorMessage: 'Missing one or more required keys: isCorrect, correctAnswer, feedback.',
        ),
      );
    }

    // Validate types
    if (jsonData['isCorrect'] is! bool ||
        jsonData['correctAnswer'] is! String ||
        jsonData['feedback'] is! String) {
      return Result(
        failure: GeminiResponseFormatException(
          errorMessage: 'One or more fields have incorrect types.',
        ),
      );
    }

    return Result(data: jsonData);
  } catch (e) {
    return Result(
      failure: GeminiResponseFormatException(
        errorMessage: 'Invalid JSON format: ${e.toString()}',
      ),
    );
  }
}




}