import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_weather/weather/weather.dart';
// import 'package:google_fonts/google_fonts.dart';
import "package:dictionary_repository/dictionary_repository.dart";
import 'package:flutter_improve_vocabulary/core/network/internet_bloc.dart';
import 'package:flutter_improve_vocabulary/features/homeScreen/presentation/screens/home_screen.dart';
import 'package:flutter_improve_vocabulary/features/word/bloc/word_bloc.dart';

import '../word/cubit/word_cubit.dart';
import '../word/view/word_page.dart';

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => DictionaryRepository(),
      dispose: (repository) => repository.dispose(),
      
      child: MultiBlocProvider(
        providers: [

          BlocProvider(create: (_) => InternetBloc(), lazy: false,),

          BlocProvider(
            // create: (context) => WordCubit(dictionary_repository:  context.read<DictionaryRepository>()),
            create: (context) => WordBloc(repository: context.read<DictionaryRepository>())..add(LoadWords(noOfWordToSearch: 10)),
            lazy: false,
            
          ),
        ],
        child: const WeatherAppView(),

      ),
    );
  }
}

class WeatherAppView extends StatelessWidget {
  const WeatherAppView({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        // colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
        // textTheme: GoogleFonts.rajdhaniTextTheme(),
      ),
      home: const HomeScreen(),
    );
  }
}

