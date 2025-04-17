
import 'package:google_generative_ai/google_generative_ai.dart';

import '../schema/scheme.dart';


/// If [topP = 1.0]: it considers all possibilities (like full randomness).
/// If [topP = 0.5]: it limits the choices to just the top few words whose combined probability mass is at least 50%.
/// topP is a parameter that controls the diversity of the generated text.
/// 
/// 
/// candidateCount is the number of variants of the output that are generated.

final configurationForWords = GenerationConfig(
  candidateCount: 1,
  responseMimeType: 'application/json',
  topP: .5, 
  responseSchema: schemaForWords,
);

final configurationForSingleWord = GenerationConfig(
  candidateCount: 1,
  responseMimeType: 'application/json',
  topP: .5,
  responseSchema: schemaForWord,
);


final configurationForExample = GenerationConfig(
  candidateCount: 1,
  responseMimeType: 'application/json',
  topP: .5,
  responseSchema: schemaForExample,
);


final configurationForSynonyms = GenerationConfig(
  candidateCount: 1,
  responseMimeType: 'application/json',
  topP: .5,
  responseSchema: schemaForSynonyms,
);

final configurationForAntonyms = GenerationConfig(
  candidateCount: 1,
  responseMimeType: 'application/json',
  topP: .5,
  responseSchema: schemaForAntonyms,
);


