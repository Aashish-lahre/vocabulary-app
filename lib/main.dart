
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_improve_vocabulary/core/shared_preference/word_fetch_limit.dart';
import 'package:flutter_improve_vocabulary/core/theme/color_theme.dart';
import 'package:flutter_improve_vocabulary/core/theme/theme_storage.dart';
import 'package:flutter_improve_vocabulary/features/word/bloc/word_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app/app.dart';
import 'features/search/presentation/screens/search_page.dart';





void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );

  // flutter run --dart-define-from-file=api_key.dart
  int wordFetchLimit = await WordFetchLimit().getWordFetchLimit;
  ThemeType themeType = await ThemeStorage().getThemeType();

  // runApp(VocabularyApp(wordFetchLimit, themeType));
  runApp(MaterialApp(home: SearchPage(),));

}


