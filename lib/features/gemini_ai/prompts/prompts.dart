
String promptForWords(int noOfWords) {
  // return "Generate 2 english words 'intricate', 'follow' by the given schema";

  // return "Generate 2 english words with the given schema";
  return 'Generate $noOfWords english words with the given schema';
}

String promptForExample(String word, int limit, List<String> filterOut) {
  String filterClause = filterOut.isNotEmpty
      ? " Avoid using the following examples that have already been used: ${filterOut.join(', ')}."
      : "";

  return "Generate $limit detailed and context-rich example sentences for the English "
      "word '$word'. Each example should be at least 20-30 words long and demonstrate the "
      "word’s meaning in a natural, real-world context. The sentences should vary in "
      "structure and tone, incorporating different grammatical forms (e.g., noun, verb, "
      "adjective if applicable). Avoid generic or repetitive usage—each example should feel "
      "unique and meaningful.$filterClause";
}



String promptForSynonyms(String word, int limit, List<String> filterOut) {
  final excludedWords = filterOut.isNotEmpty ? " other than: ${filterOut.join(', ')}" : "";
  return "Generate $limit synonyms for the word '$word'$excludedWords.";
}

String promptForAntonyms(String word, int limit, List<String> filterOut) {
  final excludedWords = filterOut.isNotEmpty ? " other than: ${filterOut.join(', ')}" : "";
  return "Generate $limit antonyms for the word '$word'$excludedWords.";
}