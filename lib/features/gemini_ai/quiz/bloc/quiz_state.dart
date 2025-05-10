part of 'quiz_bloc.dart';

sealed class QuizState extends Equatable {
  const QuizState();
  
  @override
  List<Object> get props => [];
}

final class QuizInitial extends QuizState {}


final class LoadingQuestionsState extends QuizState {

}

final class LoadedQuestionsState extends QuizState {}

final class LoadingNextQuestion extends QuizState {}

final class CheckingUserAnswerState extends QuizState {
  final String question;
  final String userAnswer;

  const CheckingUserAnswerState(
      {required this.userAnswer, required this.question});
}

final class CheckedUserAnswerState extends QuizState {
  final String question;
  final String userAnswer;
  final Map<String, dynamic> aiReactionToUserAnswer;

  const CheckedUserAnswerState({required this.question, required this.userAnswer, required this.aiReactionToUserAnswer});
}



final class LoadedNextQuestion extends QuizState {

  
  final String question;
  final String expectedAnswer;

  const LoadedNextQuestion({required this.question, required this.expectedAnswer});
}

final class GeminiInvalidApiKeyState extends QuizState {
  final String errorMessage;

  const GeminiInvalidApiKeyState({required this.errorMessage});
}

final class GeminiGeneralFailureState extends QuizState {
  final String errorMessage;

  const GeminiGeneralFailureState({required this.errorMessage});
}