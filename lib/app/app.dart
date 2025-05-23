import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/blocs/ViewSwitcherCubit/view_switcher_cubit.dart';
import '../core/blocs/network_bloc/internet_bloc.dart';
import '../core/theme/color_theme.dart';
import '../core/theme/cubit/theme_cubit.dart';
import '../features/gemini_ai/quiz/bloc/quiz_bloc.dart';
import '../features/gemini_ai/quiz/repository.dart';
import '../features/gemini_ai/word/bloc/gemini_bloc.dart';
import '../features/gemini_ai/word/repository/gemini_ai_repository.dart';
import '../app/home_screen.dart';
import '../features/dictionary/bloc/word_bloc.dart';
import '../features/dictionary/repository/dictionary_repository.dart';


class VocabularyApp extends StatelessWidget {

  final ThemeType themeType;
  final int wordFetchLimit;
  final bool isAiWordGenerationOn;

  const VocabularyApp(this.wordFetchLimit, this.themeType, this.isAiWordGenerationOn, {super.key});


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
            // ViewSwitcherCubit is used to switch between the dictionary API and the gemini ai.
            BlocProvider(create: (_) => ViewSwitcherCubit(isAiWordGenerationOn ? ViewMode.geminiAi : ViewMode.dictionaryApi)),

            BlocProvider(create: (_) => QuizBloc(repository: GeminiRepositoryForQuiz())),


            BlocProvider(
                lazy: false,
                create: (_) => GeminiBloc(repository: GeminiRepositoryForWord(), isAiWordsGenerationOn : isAiWordGenerationOn)),


            BlocProvider(create: (context) => InternetBloc(), lazy: false,),

            BlocProvider(
              create: (context) =>
                  WordBloc(
                      repository: context.read<DictionaryRepository>(), moreWordFetchLimit: wordFetchLimit),
              lazy: false,

            ),
          ],
          child: VocabularyAppView(),

        ),
      );
  }
}

class VocabularyAppView extends StatelessWidget {
  

  const VocabularyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeType>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          builder: (context, child) {

            if(themes[state]!.backgroundGradient != null) {
              // if Gradient is available in the current theme, then apply it to the whole app.
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
            // if gradient is available in the current theme, then make the scaffold background transparent 
            //because then only we can see the gradient. otherwise keep the default background color.
            scaffoldBackgroundColor: themes[state]!.backgroundGradient != null ? Colors.transparent : themes[state]!.colorScheme.surface,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ).copyWith(textTheme: GoogleFonts.akatabTextTheme()),
          home: HomeScreen(),
        );
      },
    );
  }


}

