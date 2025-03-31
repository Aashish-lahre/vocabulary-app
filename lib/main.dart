
import 'package:dictionary_api/dictionary_api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app/app.dart';
import 'app_restart_widget.dart';

Word word = Word(word: 'national', meanings: [
  Meaning(partOfSpeech: 'noun', definitions: [
    Definition(definition: 'national is a reference to own countries objects.'),
    Definition(definition: 'national is a reference to own countries objects.'),
    Definition(definition: 'national is a reference to own countries objects.'),

  ]),
  Meaning(partOfSpeech: 'verb', definitions: [
    Definition(definition: 'national is a reference to own countries objects.'),
    Definition(definition: 'national is a reference to own countries objects.'),
    Definition(definition: 'national is a reference to own countries objects.'),

  ]),
  Meaning(partOfSpeech: 'adjective', definitions: [
    Definition(definition: 'national is a reference to own countries objects.'),
    Definition(definition: 'national is a reference to own countries objects.'),
    Definition(definition: 'national is a reference to own countries objects.'),

  ]),

]);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );
  runApp(AppRestartWidget(child: VocabularyApp()));
}


