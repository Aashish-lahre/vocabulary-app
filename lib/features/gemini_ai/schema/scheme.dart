
import 'package:google_generative_ai/google_generative_ai.dart';

final schemaForWord = Schema(SchemaType.object,

  description: 'apply this scheme for provided number of english words',
  nullable: false,
  properties: {

  'wordName' : Schema(SchemaType.string, description: 'word name'),
  'partsOfSpeech': Schema(SchemaType.array, description: 'array of partOfSpeech strings for the "wordName". ',
                  nullable: false, items: Schema(SchemaType.string)
                  ),
  'definitions': schemaForDefinition,
  'synonyms': schemaForSynonyms,
  'antonyms': schemaForAntonyms,
  'examples': schemaForExample,

  },
  requiredProperties: [
    'wordName', 'partsOfSpeech', 'definitions', 'synonyms', 'antonyms', 'examples'
  ],

);

final schemaForWords = Schema(
SchemaType.array,
description :'JSON object containing multiple word items',
nullable : false,
items: schemaForWord,

);

final schemaForSynonyms = Schema(SchemaType.array,  description: 'array of synonyms string.', items: Schema(SchemaType.string), nullable: false);


final schemaForAntonyms = Schema(SchemaType.array, description: 'array of antonyms strings.', items: Schema(SchemaType.string), nullable: false);

const String promptForDefinition = "Give clear and concise definitions for the provided word. Provide up to 3 distinct meanings if the word has multiple common uses. If the word has only one widely accepted meaning, return just that.";
final schemaForDefinition = Schema(SchemaType.array, description: promptForDefinition, nullable: false, items: Schema(SchemaType.string));

final schemaForExample = Schema(SchemaType.array, description: promptForExample, items: Schema(SchemaType.string), nullable: false);
const String promptForExample = "Generate up to 3 detailed and context-rich example sentences for the provided word. Each example should be at least 20-30 words long and demonstrate the "
    "word’s meaning in a natural, real-world context. The sentences should vary in "
    "structure and tone, incorporating different grammatical forms (e.g., noun, verb, "
    "adjective if applicable). Avoid generic or repetitive usage—each example should feel "
    "unique and meaningful.";




