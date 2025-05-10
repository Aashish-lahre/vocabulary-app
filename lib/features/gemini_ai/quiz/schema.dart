
import 'package:google_generative_ai/google_generative_ai.dart';


final schemaForQuizQuestions = Schema(
  SchemaType.object,
  description: 'A map containing an array of quiz question objects',
  nullable: false,
  properties: {
    'questions': Schema(
      SchemaType.array,
      description: 'List of quiz questions with their expected answers',
      nullable: false,
      items: Schema(
        SchemaType.object,
        description: 'A single quiz question and its expected answer',
        nullable: false,
        properties: {
          'question': Schema(
            SchemaType.string,
            description: 'Descriptive clue for the user to guess the word',
            nullable: false,
          ),
          'expectedAnswer': Schema(
            SchemaType.string,
            description: 'The correct word that answers the question',
            nullable: false,
          ),
        },
        requiredProperties: ['question', 'expectedAnswer'],
      ),
    ),
  },
  requiredProperties: ['questions'],
);




final schemaForAnswerEvaluation = Schema(
  SchemaType.object,
  description: 'Result of evaluating a user’s quiz answer',
  nullable: false,
  properties: {
    'isCorrect': Schema(
      SchemaType.boolean,
      description: 'Whether the user’s answer matches the expected answer',
      nullable: false,
    ),
    'correctAnswer': Schema(
      SchemaType.string,
      description: 'The correct word for the current question',
      nullable: false,
    ),
    'feedback': Schema(
      SchemaType.string,
      description: 'A casual, playful message telling the user if they were right or wrong and why',
      nullable: false,
    ),
  },
  requiredProperties: ['isCorrect', 'correctAnswer', 'feedback'],
);
