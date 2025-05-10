import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'core/shared_preference/word_fetch_limit.dart';
import 'core/theme/color_theme.dart';
import 'core/theme/theme_storage.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app/app.dart';
import 'features/gemini_ai/word/shared_Preference/gemini_status_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // This is to prevent the font from being fetched from the internet.
  GoogleFonts.config.allowRuntimeFetching = false;
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );

  // flutter run --dart-define-from-file=api_key.dart
  int wordFetchLimit = await WordFetchLimit.instance.getWordFetchLimit;
  ThemeType themeType = await ThemeStorage.instance.getThemeType();
  bool isAiWordsGenerationOn = await GeminiStatusStorage.instance.getGeminiStatus;

  runApp(VocabularyApp(wordFetchLimit, themeType, isAiWordsGenerationOn));
}


