part of 'quiz_bloc.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object> get props => [];
}

class LoadQuestionsEvent extends QuizEvent {
  final int limit;
  final double difficulty;
  final List<String>? filter;

  const LoadQuestionsEvent({required this.limit, required this.difficulty, this.filter});

  @override
  List<Object> get props => [limit, difficulty, filter ?? []];
}

class LoadNextQuestionEvent extends QuizEvent {}

class CheckUserAnswerEvent extends QuizEvent {
  final String question;
  final String expectedAnswer;
  final String userAnswer;

  const CheckUserAnswerEvent({required this.question, required this.expectedAnswer, required this.userAnswer});

  @override
  List<Object> get props => [question, expectedAnswer, userAnswer];
}

class ChangeDifficultyEvent extends QuizEvent {
  final double difficulty;

  const ChangeDifficultyEvent({required this.difficulty});

  @override
  List<Object> get props => [difficulty];
}

class ChangeModelEvent extends QuizEvent {
  final GeminiModels model;

  const ChangeModelEvent({required this.model});

  @override
  List<Object> get props => [model];
}