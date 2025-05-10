import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:google_generative_ai/google_generative_ai.dart';

import '../../../../api_key.dart';
import '../../../../core/utility/result.dart';
import '../../gemini_errors.dart';
import '../../gemini_models.dart';
import '../prompts.dart';
import '../repository.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {

final GeminiRepositoryForQuiz repository;
final int limit = 5;
final String quizContext = 'english words';
List<Map<String, String>> questionsListWithExpectedAnswer = [];
GeminiModels defaultModel = GeminiModels.Gemini15Pro;
late GenerativeModel model;
int currentShowingQuestionInUiIndex = -1;
double wordDifficultyLevel = 0.3;

  QuizBloc({required this.repository}) : super(QuizInitial()) {
    model = GenerativeModel(
      model: defaultModel.model,
      apiKey: apiKey,
    );

    on<ChangeModelEvent>((event, emit) {
      defaultModel = event.model;
      model = GenerativeModel(
        model: defaultModel.model,
        apiKey: apiKey,
      );
      // Reset the quiz state when model changes
      currentShowingQuestionInUiIndex = -1;
      questionsListWithExpectedAnswer.clear();
      add(LoadQuestionsEvent(
        limit: limit, 
        difficulty: wordDifficultyLevel,
        filter: questionsListWithExpectedAnswer.map((map) => map['question']!).toList(),
      ));
    });

    on<LoadQuestionsEvent>((event, emit) async {
      emit(LoadingQuestionsState());
      late List<String> questionsAlreadyShown;
      if(event.filter != null) {
        questionsAlreadyShown = event.filter!;
      } else {
        questionsAlreadyShown = questionsListWithExpectedAnswer.map((map) {
          return map['question']!;
        }).toList();
      }

      final Result<List<Map<String, String>>, GeminiError> response = await repository.generateQuizQuestions(promptForQuizQuestions(limit: limit, context: quizContext,filterOut: questionsAlreadyShown, difficultyLevel: event.difficulty), model);
        if(response.isSuccess) {
          questionsListWithExpectedAnswer.addAll(response.data!);
          emit(LoadedQuestionsState());
          add(LoadNextQuestionEvent());

        } else {

          if(response.failure!.runtimeType == GeminiInvalidApiKey) {
            emit(GeminiInvalidApiKeyState(errorMessage: response.failure!.errorMessage));
          } else {
            emit(GeminiGeneralFailureState(errorMessage: response.failure!.errorMessage));
          }
          
          
        }
    });




    on<LoadNextQuestionEvent>((event, emit) {
      emit(LoadingNextQuestion());
      final questions = questionsListWithExpectedAnswer.map((map) {
        return map['question']!;
      }).toList();
  if(++currentShowingQuestionInUiIndex < questions.length) {
        emit(LoadedNextQuestion(question: questions[currentShowingQuestionInUiIndex], expectedAnswer: questionsListWithExpectedAnswer[currentShowingQuestionInUiIndex]['expectedAnswer']!));
      } else {
        // else block means = index for words exceeds allWords items

        // subtract 1 index because, when LoadNextQuestionEvent added from LoadQuestionsEvent, will we show this index successfully when ++currentShowingQuestionInUiIndex evaluates, 
        // right now we can't see this index question.
        currentShowingQuestionInUiIndex = currentShowingQuestionInUiIndex - 1;
        add(LoadQuestionsEvent(limit: limit, difficulty: wordDifficultyLevel, filter: questions));
      }

    });
  
  
  
    on<CheckUserAnswerEvent>((event, emit) async {
      emit(CheckingUserAnswerState(userAnswer: event.userAnswer, question: event.question));

      final Result<Map<String, dynamic>, GeminiError> response = await repository.evaluateQuizAnswer(promptForAnswerEvaluation(context: quizContext, currentQuestion: event.question, expectedAnswer: event.expectedAnswer, userAnswer: event.userAnswer), model);
        if(response.isSuccess) {
          
          emit(CheckedUserAnswerState(question: event.question,userAnswer: event.userAnswer, aiReactionToUserAnswer: response.data!));
          

        } else {

          if(response.failure!.runtimeType == GeminiInvalidApiKey) {
            emit(GeminiInvalidApiKeyState(errorMessage: response.failure!.errorMessage));
          } else {
            emit(GeminiGeneralFailureState(errorMessage: response.failure!.errorMessage));
          }
          
          
        }
    });


    on<ChangeDifficultyEvent>((event, emit) {
      wordDifficultyLevel = event.difficulty;
      
      // reset to -1, so we can show 0 when LoadNextQuestionEvent added.
      currentShowingQuestionInUiIndex = -1;
      final questions = questionsListWithExpectedAnswer.map((map) {
        return map['question']!;
      }).toList();
      questionsListWithExpectedAnswer.clear();
      add(LoadQuestionsEvent(limit: limit, difficulty: wordDifficultyLevel, filter: questions));
    });
  
  
  
  
  
  
  }
}
