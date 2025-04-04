enum GeminiModels {


  Gemini20Flash(model: 'gemini-2.0-flash', label: "Gemini 2.0 Flash"),
  Gemini20FlashLite(model: 'gemini-2.0-flash-lite', label: "Gemini 2.0 Flash Lite"),
  Gemini15Pro(model: 'gemini-1.5-pro', label: "Gemini 1.5 Pro"),
  Gemini15Flash(model: 'gemini-1.5-flash', label: "Gemini 1.5 Flash"),
  Gemini15Flash8b(model: 'gemini-1.5-flash-8b', label: "Gemini 1.5 Flash 8-B"),
  Gemini25ProExp0325(model: 'gemini-2.5-pro-exp-03-25', label: "Gemini 2.5 Pro Exp 03-25");




  const GeminiModels({required this.model, required this.label});
  final String model;
  final String label;

}

