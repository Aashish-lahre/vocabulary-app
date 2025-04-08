
import 'package:google_generative_ai/google_generative_ai.dart';

import '../schema/scheme.dart';

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


