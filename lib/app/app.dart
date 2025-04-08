import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_improve_vocabulary/core/blocs/network_bloc/internet_bloc.dart';
import 'package:flutter_improve_vocabulary/core/theme/color_theme.dart';
import 'package:flutter_improve_vocabulary/core/theme/cubit/theme_cubit.dart';
import 'package:flutter_improve_vocabulary/features/gemini_ai/bloc/gemini_bloc.dart';
import 'package:flutter_improve_vocabulary/features/gemini_ai/repository/gemini_ai_repository.dart';
import 'package:flutter_improve_vocabulary/features/homeScreen/presentation/screens/home_screen.dart';
import 'package:flutter_improve_vocabulary/core/blocs/later_word_fetch_bloc/later_word_fetch_bloc.dart';
import 'package:flutter_improve_vocabulary/features/word/bloc/word_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../features/dictionary/repository/dictionary_repository.dart';


class VocabularyApp extends StatelessWidget {

  final ThemeType themeType;
  final int wordFetchLimit;
  final int initialWordFetchLimit = 2;

  const VocabularyApp(this.wordFetchLimit, this.themeType, {super.key});


  @override
  Widget build(BuildContext context) {
    return
      RepositoryProvider(
        create: (_) => DictionaryRepository(),
        dispose: (repository) => repository.dispose(),

        child: MultiBlocProvider(
          providers: [

            BlocProvider(
              create: (_) => ThemeCubit(themeType: themeType),
            ),

            BlocProvider(
                lazy: false,
                create: (_) => GeminiBloc(repository: GeminiRepository())),

            BlocProvider(
                lazy: false,
                // create: (_) => LaterWordFetchBloc(laterWordFetchLimit: 3)..add(InitialLaterWordFetchCount(count: initialLaterWordFetchLimit))
                create: (context) =>
                    LaterWordFetchBloc(laterWordFetchLimit: 2)

            ),

            BlocProvider(create: (context) => InternetBloc(), lazy: false,),

            BlocProvider(
              // create: (context) => WordCubit(dictionary_repository:  context.read<DictionaryRepository>()),
              create: (context) =>
                  WordBloc(geminiBloc: context.read<GeminiBloc>(),
                      repository: context.read<DictionaryRepository>()),
              lazy: false,

            ),
          ],
          child: VocabularyAppView(
            initialWordFetchLimit: initialWordFetchLimit,),

        ),
      );
  }
}

class VocabularyAppView extends StatelessWidget {
  final int initialWordFetchLimit;

  const VocabularyAppView({required this.initialWordFetchLimit, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeType>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          builder: (context, child) {
            print('later word bloc checking : ${context.read<LaterWordFetchBloc>().laterWordFetchLimit}');

            if(themes[state]!.backgroundGradient != null) {
              return Container(
                decoration: BoxDecoration(
                  gradient: themes[state]!.backgroundGradient
                ),
                child: child!,
              );
            } else {
              return child!;
            }
          },



          theme: ThemeData(
            colorScheme: themes[state]!.colorScheme,
            scaffoldBackgroundColor: themes[state]!.backgroundGradient != null ? Colors.transparent : themes[state]!.colorScheme.surface,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ).copyWith(textTheme: GoogleFonts.akatabTextTheme()),
          home: HomeScreen(initialWordFetchLimit: initialWordFetchLimit,),
        );
      },
    );
  }


}

