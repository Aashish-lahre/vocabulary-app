import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';



import '../../../../core/utility/result.dart';
import '../configuration/configuration.dart';
import '../prompts/prompts.dart';
import '../../gemini_errors.dart';
import '../../../../core/models/word.dart';







class GeminiRepositoryForWord {

  static GeminiRepositoryForWord?  instance;

  GeminiRepositoryForWord._();

  factory GeminiRepositoryForWord() {
    return instance ??= GeminiRepositoryForWord._();
  }

  Future<Result<List<Word>, GeminiError>> generateWords(String prompt, GenerativeModel model) async {
    final List<Content> content = [Content.text(prompt)];
    late Result<List<Word>, GeminiError> response;
    try {

    final generateContentResponse = await model.generateContent(content, generationConfig: configurationForWords);

    response = processResponseForWords(generateContentResponse.text!);

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

  Future<Result<Word, GeminiError>> generateSingleWord(String wordName, GenerativeModel  model) async {

    final List<Content> content = [Content.text(promptForSingleWord(wordName))];
    late Result<Word, GeminiError> response;
    try {

      final generateContentResponse = await model.generateContent(content, generationConfig: configurationForSingleWord);

      response = processResponseForWord(generateContentResponse.text!);

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


  Future<Result<List<String>, GeminiError>> generateExamples(String word, int limit, List<String> filterOut, GenerativeModel  model) async {

    final List<Content> content = [Content.text(promptForExample(word, limit, filterOut))];
    late Result<List<String>, GeminiError> response;
    try {

      final generateContentResponse = await model.generateContent(content, generationConfig: configurationForExample);

      response = processResponseForExamples(generateContentResponse.text!);

    }  on InvalidApiKey catch (err) {

      return Result(failure: GeminiInvalidApiKey(errorMessage: err.message));
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

    }  on InvalidApiKey catch (err) {

      return Result(failure: GeminiInvalidApiKey(errorMessage: err.message));
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

    }  on InvalidApiKey catch (err) {

      return Result(failure: GeminiInvalidApiKey(errorMessage: err.message));
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



Result<List<Word>, GeminiError> processResponseForWords(String text) {
  // Check if the response is empty
  if (text.trim().isEmpty) {
    return Result(
      failure: GeminiResponseFormatException(errorMessage: 'Response is empty.'),
    );
  }

  try {
    // Attempt to parse JSON
    final jsonData = jsonDecode(text)  as List<dynamic>;


    // Ensure every item in the list is a Map<String, dynamic>
    final condition = !jsonData.every((item) => item is Map<String, dynamic>);
    if (condition) {
      return Result(
        failure: GeminiResponseFormatException(
          errorMessage: 'List contains non-object elements.',
        ),
      );
    }

    // Parse all items into Word objects
    final List<Word> words = jsonData.map((jsonObj) {

      return Word.fromJson(jsonObj as Map<String, dynamic> );

    }).toList();
    return Result(data: words);
  } catch (e) {
    return Result(
      failure: GeminiResponseFormatException(
        errorMessage: 'Invalid JSON format: ${e.toString()}',
      ),
    );
  }
}



Result<Word, GeminiError> processResponseForWord(String text) {
  // Check if the response is empty
  if (text.trim().isEmpty) {
    return Result(
      failure: GeminiResponseFormatException(errorMessage: 'Response is empty.'),
    );
  }

  try {
    // Attempt to parse JSON
    final jsonData = jsonDecode(text)  as Map<String, dynamic>;



    // Parse all items into Word objects
    final Word word = Word.fromJson(jsonData);


    return Result(data: word);
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


