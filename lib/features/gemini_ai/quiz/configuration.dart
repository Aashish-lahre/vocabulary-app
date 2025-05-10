
import 'package:google_generative_ai/google_generative_ai.dart';

import './schema.dart';



/// If [topP = 1.0]: it considers all possibilities (like full randomness).
/// If [topP = 0.5]: it limits the choices to just the top few words whose combined probability mass is at least 50%.
/// topP is a parameter that controls the diversity of the generated text.
/// 
/// 
/// candidateCount is the number of variants of the output that are generated.

final configurationForQuizQuestions = GenerationConfig(
  candidateCount: 1,
  responseMimeType: 'application/json',
  topP: .5, 
  responseSchema: schemaForQuizQuestions,
);

final configurationForAnswerEvalution = GenerationConfig(
  candidateCount: 1,
  responseMimeType: 'application/json',
  topP: .5, 
  responseSchema: schemaForAnswerEvaluation,
);