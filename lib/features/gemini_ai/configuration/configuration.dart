
import 'package:google_generative_ai/google_generative_ai.dart';

import '../schema/scheme.dart';

final configurationForWords = GenerationConfig(
  candidateCount: 1,
  responseMimeType: 'application/json',
  topP: .5,
  responseSchema: schemaForWords,
);