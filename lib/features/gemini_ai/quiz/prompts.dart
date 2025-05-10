
String _difficultyClause(double level) {
  if (level <= 0.15) {
    return "Use extremely simple and common English words suitable for very young learners. Clues should be short, direct, and use basic everyday language.";
  } else if (level <= 0.3) {
    return "Use very easy and familiar English words. Clues should be simple, direct, and helpful for new language learners.";
  } else if (level <= 0.45) {
    return "Use beginner-level vocabulary. Clues should be clear and descriptive, using common language and real-world references.";
  } else if (level <= 0.6) {
    return "Use intermediate-level English words that may require some thinking. Clues should still be clear and unambiguous, but slightly more detailed.";
  } else if (level <= 0.75) {
    return "Use advanced vocabulary that might not be part of everyday conversation. Clues should remain direct and well-phrased to define the word clearly.";
  } else if (level <= 0.9) {
    return "Use rare or academic English words typically known to advanced or native speakers. Clues must remain precise, informative, and unambiguous.";
  } else {
    return "Use expert-level, uncommon, or domain-specific English words. Clues should be carefully crafted, direct, and clearly define the word without relying on figurative or poetic language.";
  }
}



String promptForQuizQuestions({
  required int limit,
  required String context,
  required List<String> filterOut,
  double difficultyLevel = 0.3,
}) {


  final filterClause = filterOut.isNotEmpty
      ? " Avoid using the following quiz questions or similar or even related questions because they have already been used: ${filterOut.join(', ')}. for example 'I have a flat top and legs, and I am used for eating or working on.' and 'I have a flat top and you can eat on me or write on me' are similar so do not use it similarly for others."
      : "";

  

  final difficultyClause = _difficultyClause(difficultyLevel);

  return """
Generate $limit very unique, new and well-crafted quiz questions for a word-guessing game focused on the topic: "$context".

Each question must:
- Be a **single descriptive clue** that clearly defines or explains the word.
- Use **simple, direct, and unambiguous language** appropriate to the specified difficulty.
- Avoid using the target word, its direct synonyms, or root forms.
- Focus on the **meaning, function, or real-world use** of the word to guide the guesser.

$difficultyClause

Return the output as a **JSON array**, where each item is an object containing:
- "question": the clue (a single sentence)
- "expectedAnswer": the correct word the player should guess

$filterClause
Ensure the final output is clean, parsable JSON with no additional commentary or formatting.
""";
}




String promptForAnswerEvaluation({
  required String context,
  required String currentQuestion,
  required String expectedAnswer,
  required String userAnswer,
}) {
  return """
You are a friendly and supportive quiz game host evaluating one quiz attempt.  
No prior chat or context exists—everything you need is right here.

CONTEXT: $context

CLUE:
"$currentQuestion"

CORRECT ANSWER:
"$expectedAnswer"

PLAYER’S GUESS:
"$userAnswer"

EVALUATION TASKS:
1. Determine if the player's answer is correct by checking:
   - If it **matches the expected answer** (case-insensitive).
   - If it is a **valid synonym** or a word that conveys the same meaning — count it as correct.
   - If it's **close in spelling** to the expected answer (minor typos or errors), treat it as correct, but gently point it out.
   - If the **spelling is quite wrong** but it's obvious what they meant, acknowledge the effort, and mark it as wrong, and mention the right word clearly.

2. Respond in a **casual, cheerful, and kind tone**:
   - If correct: Celebrate their success and still mention what the expected answer was.
   - If incorrect: Reveal the correct word, explain briefly and kindly, and give them credit if they were close in meaning or spelling.
   - Give One example using the correct Word.

3. Always end with a **supportive and encouraging line**, like:
   - “You're doing great!”
   - “Let’s keep going!”
   - “That one was tricky — nice try!”

IMPORTANT:
- Keep it warm, playful, and human-like.
- Do **not** provide a new question.
- Keep your response short, upbeat, and emotionally positive.
""";
}

