import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_improve_vocabulary/core/network/internet_bloc.dart';
import 'package:flutter_improve_vocabulary/core/theme/color_theme.dart';
import 'package:flutter_improve_vocabulary/core/theme/cubit/theme_cubit.dart';
import 'package:flutter_improve_vocabulary/core/theme/cubit/theme_cubit.dart';
import 'package:flutter_improve_vocabulary/features/homeScreen/presentation/screens/home_screen.dart';
import 'package:flutter_improve_vocabulary/features/settings/blocs/LaterWordFetchBloc/later_word_fetch_bloc.dart';
import 'package:flutter_improve_vocabulary/features/word/bloc/word_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../features/dictionary/repository/dictionary_repository.dart';


class VocabularyApp extends StatelessWidget {
  const VocabularyApp({super.key});
  final int initialWordFetchLimit = 3;
  final int initialLaterWordFetchLimit = 3;

  @override
  Widget build(BuildContext context) {
    return
      RepositoryProvider(
      create: (_) => DictionaryRepository(),
      dispose: (repository) => repository.dispose(),

      child: MultiBlocProvider(
        providers: [

          BlocProvider(
            create: (_) => ThemeCubit(),
          ),

          BlocProvider(
              lazy: false,
              create: (_) => LaterWordFetchBloc(laterWordFetchLimit: 3)..add(InitialLaterWordFetchCount(count: initialLaterWordFetchLimit))
          
          ),

          BlocProvider(create: (_) => InternetBloc(), lazy: false,),

          BlocProvider(
            // create: (context) => WordCubit(dictionary_repository:  context.read<DictionaryRepository>()),
            create: (context) => WordBloc(repository: context.read<DictionaryRepository>())..add(LoadWords(noOfWordToSearch: initialWordFetchLimit)),
            lazy: false,

          ),
        ],
        child: VocabularyAppView(initialWordFetchLimit: initialWordFetchLimit,),

      ),
    );
  }
}

class VocabularyAppView extends StatelessWidget {
  final int initialWordFetchLimit;
    const VocabularyAppView({required this.initialWordFetchLimit, super.key});

  @override
  Widget build(BuildContext context) {

    
    return BlocBuilder<ThemeCubit, ThemeType?>(
  builder: (context, state) {
    if(state == null) {
      return MaterialApp(
        theme: ThemeData.light(),
        home: SizedBox.expand(),
      );
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: themes[state],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ).copyWith(textTheme: GoogleFonts.akatabTextTheme()),
      home: HomeScreen(initialWordFetchLimit: initialWordFetchLimit),
    );
  },
);
  }
}

