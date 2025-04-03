
import 'package:google_generative_ai/google_generative_ai.dart';

final schemaForWord = Schema(SchemaType.object,

  description: 'apply this scheme for provided number of english words',
  nullable: false,
  properties: {

  'wordName' : Schema(SchemaType.string, description: 'word name'),
  'partOfSpeech': Schema(SchemaType.array, description: 'array of partOfSpeech strings for the "wordName" with up to 3 items',
                  nullable: false, items: Schema(SchemaType.string)
                  ),
  'definition': Schema(SchemaType.array, description: 'array of definition string with up to 3 items', nullable: false, items: Schema(SchemaType.string)),
  'synonyms': Schema(SchemaType.array, description: 'array of synonym strings for the "wordName" with up to 4 items', items: Schema(SchemaType.string), nullable: false),
  'antonyms': Schema(SchemaType.array, description: 'array of antonym strings for the "wordName" with up to 4 items', items: Schema(SchemaType.string), nullable: false),
  'example': Schema(SchemaType.array, description: 'array of example strings for the "wordName" with up to 4 items', items: Schema(SchemaType.string), nullable: false),

  },
  requiredProperties: [
    'wordName', 'partOfSpeech', 'definition', 'synonyms', 'antonyms', 'example'
  ],

);

final schemaForWords = Schema(
SchemaType.array,
description :'JSON object containing multiple word items',
nullable : false,
items: schemaForWord,

);

final schemaForSynonyms = Schema(SchemaType.array, format: '[stringItem, stringItem, stringItem, stringItem]', description: 'array of synonyms string with up to 4 items', items: Schema(SchemaType.string), nullable: false);


final schemaForAntonyms = Schema(SchemaType.array, format: '[stringItem, stringItem, stringItem, stringItem]', description: 'array of antonyms string with up to 4 items', items: Schema(SchemaType.string), nullable: false);

final schemaForDefinition = Schema(SchemaType.array, format: '[String, String, String]', description: 'array of definition strings with up to 3 items', nullable: false, items: Schema(SchemaType.string));

final schemaForExample = Schema(SchemaType.array, format: '[example1, example2, example3, example4]', description: 'array of example strings with up to 4 items', items: Schema(SchemaType.string), nullable: false);





