import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_improve_vocabulary/core/error/screen/home_error_screen.dart';
import 'package:flutter_improve_vocabulary/features/gemini_ai/bloc/gemini_bloc.dart';
import 'package:flutter_improve_vocabulary/features/gemini_ai/screens/ai_word_card.dart';
import 'package:flutter_improve_vocabulary/features/homeScreen/presentation/utility/home_error_types_enum.dart';
import 'package:flutter_improve_vocabulary/features/word/screens/word_card.dart';
import 'package:flutter_improve_vocabulary/core/utility/loading_widget.dart';
import 'package:flutter_improve_vocabulary/features/settings/blocs/LaterWordFetchBloc/later_word_fetch_bloc.dart';
import 'package:flutter_improve_vocabulary/features/settings/presentation/screens/settings.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/network/internet_bloc.dart';
import '../../../../core/utility/word_slider.dart';
import '../../../dictionary/models/word.dart';
import '../../../gemini_ai/model/ai_word.dart';
import '../../../word/bloc/word_bloc.dart';
import '../../../../core/utility/above_banner.dart';

class HomeScreen extends StatefulWidget {
  final int initialWordFetchLimit;

  const HomeScreen({required this.initialWordFetchLimit, super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  void initState() {
    final isAiWordGenerationIsOn =  context.read<GeminiBloc>().isAiWordsGenerationOn;
    if(isAiWordGenerationIsOn) {
      context.read<GeminiBloc>().add(LoadAiWordsEvent(noOfAiWordsToLoad: 5));
    } else {
      context.read<WordBloc>().add(LoadWords(noOfWordToSearch: 5));
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (scaffoldContext) {
          return SizedBox.expand(
            child: MultiBlocListener(
  listeners: [
    BlocListener<InternetBloc, InternetState>(
              listener: (context, state) {
                String title = state.status ? 'Hooray!' : 'Oh Snap!';
                String message = state.status
                    ? "We are back Online!"
                    : 'No Internet Connection, try again!';
                ContentType contentType =
                    state.status ? ContentType.success : ContentType.failure;

                showOverlayBanner(scaffoldContext,
                    title: title, message: message, contentType: contentType);
              },
),
    BlocListener<GeminiBloc, GeminiState>(
      listenWhen: (previousState, currentState) {
        return [GeminiFailureState, AiWordsLoadingState, AiWordsLoadedState].contains(currentState.runtimeType);
      },
      listener: (context, state) {
        if(state is GeminiFailureState) {
          String title = '';
          String message = 'Something went wrong.';
          ContentType contentType = ContentType.failure;

          showOverlayBanner(scaffoldContext,
              title: title,
              message: message,
              contentType: contentType);
        }

        if(state is AiWordsLoadingState) {
          String title = '';
          String message = 'Loading AI words.';
          ContentType contentType = ContentType.help;

          showOverlayBanner(scaffoldContext,
              title: title,
              message: message,
              contentType: contentType);
        }

        if(state is AiWordsLoadedState) {
          String title = '';
          String message = 'Loaded more AI words.';
          ContentType contentType = ContentType.success;

          showOverlayBanner(scaffoldContext,
              title: title,
              message: message,
              contentType: contentType);
        }


      },
    ),
  ],
  child: Stack(
                children: [



                    BlocConsumer<WordBloc, WordState>(
                    listener: (context, state) {
                      if (state is NoMoreWordAvailableState) {
                        context
                            .read<WordBloc>()
                            .add(LaterLoadWords(noOfWordsToLoad: 5));
                      }

                      if (state is LaterWordsLoading) {
                        String title = '';
                        String message = 'Loading more words.';
                        ContentType contentType = ContentType.help;

                        showOverlayBanner(scaffoldContext,
                            title: title,
                            message: message,
                            contentType: contentType);
                      }

                      if (state is LaterWordsLoadingSuccess) {
                        String title = '';
                        String message = 'Loaded more words.';
                        ContentType contentType = ContentType.success;

                        showOverlayBanner(scaffoldContext,
                            title: title,
                            message: message,
                            contentType: contentType);
                      }

                      if (state is PartialDataState) {
                        String title = '';
                        String message =
                            'Only ${state.wordFetchedCount} words loaded.';
                        ContentType contentType = ContentType.warning;

                        showOverlayBanner(scaffoldContext,
                            title: title,
                            message: message,
                            contentType: contentType);
                      }

                      if (state is UnexpectedState) {
                        String errorMessage =
                            'Unexpected Error Occurred : ${state.errorMessage}';
                        final ({
                          String errorMessage,
                          HomeErrorType homeErrorType
                        }) errorData = (
                          errorMessage: errorMessage,
                          homeErrorType: HomeErrorType.unexpected
                        );
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (_) =>
                                HomeErrorScreen(errorData: errorData)));
                      }

                      if (state is InternetFailureState) {
                        String title = '';
                        ContentType contentType = ContentType.failure;
                        String message = '';

                        if (state.wordNotSearched == 0 ||
                            state.wordRetrived == 0) {
                          message = 'No Internet Connection.';
                        } else {
                          message =
                              'Only ${state.wordRetrived} words loaded. No Internet Connection.';
                        }

                        showOverlayBanner(scaffoldContext,
                            title: title,
                            message: message,
                            contentType: contentType,
                            );
                      }

                      if (state is HomeErrorScreenState) {
                        String errorMessage =
                            state.homeErrorType == HomeErrorType.internet
                                ? 'No Internet Connection'
                                : 'Unexpected Error Occurred';
                        final ({
                          String errorMessage,
                          HomeErrorType homeErrorType
                        }) errorData = (
                          errorMessage: errorMessage,
                          homeErrorType: state.homeErrorType
                        );
                        // WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) =>
                                HomeErrorScreen(errorData: errorData),
                          ),
                        );
                        // });
                      }
                    },
                    listenWhen: (previousState, currentState) {
                      return (previousState != currentState) &&
                          [
                            NoMoreWordAvailableState,
                            LaterWordsLoading,
                            LaterWordsLoadingSuccess,
                            PartialDataState,
                            UnexpectedState,
                            InternetFailureState,
                            HomeErrorScreenState,
                          ].contains(currentState.runtimeType);
                    },
                    buildWhen: (previousState, currentState) {
                      bool flag = false;
                      if (currentState is InternetFailureState) {
                        if (context.read<WordBloc>().allWords.isEmpty) {
                          flag = true;
                        }
                      }

                      return flag ||
                          [
                            WordInitial,
                            WordLoadingState,
                            FetchedSingleWordState,
                            GeminiFailureWordState,
                          ].contains(currentState.runtimeType);
                    },
                    builder: (context, state) {
                      switch (state) {
                        case WordInitial():
                          return LoadingWidget();
                        case WordLoadingState():
                          return LoadingWidget();
                        case FetchedSingleWordState():
                          return Positioned.fill(
                            left: 30,
                            right: 30,
                            top: 50,
                            bottom: 50,
                            child: Container(
                              color: Colors.transparent,
                              child: WordSlider(
                                wordsLength: context.read<WordBloc>().allWords.length,
                                  key: UniqueKey(),
                                  wordWidget: state.word is Word
                                      ? WordCard(word: state.word as Word)
                                      : AiWordCard(word: state.word as AiWord),

                              ),
                            ),
                          );
                        case InternetFailureState():
                          return Positioned.fill(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 20,
                              children: [
                                Text(
                                  'Oops!',
                                  style: Theme.of(context)
                                      .copyWith(
                                          textTheme:
                                              GoogleFonts.eaterTextTheme())
                                      .textTheme
                                      .displayLarge!
                                      .copyWith(
                                          fontSize: 70,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface),
                                ),
                                Text(
                                  'No Internet Connection',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface),
                                ),
                                ElevatedButton(
                                    onPressed: () => context
                                        .read<WordBloc>()
                                        .add(LoadWords(
                                            noOfWordToSearch:
                                                widget.initialWordFetchLimit)),
                                    child: Text('Retry')),
                              ],
                            ),
                          );
                        case GeminiFailureWordState() :
                          return Positioned.fill(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 20,
                              children: [
                                Text(
                                  'Oops!',
                                  style: Theme.of(context)
                                      .copyWith(
                                      textTheme:
                                      GoogleFonts.eaterTextTheme())
                                      .textTheme
                                      .displayLarge!
                                      .copyWith(
                                      fontSize: 70,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface),
                                ),
                                Text(
                                  state.errorMessage,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface),
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      final isAiWordGenerationIsOn =  context.read<GeminiBloc>().isAiWordsGenerationOn;
                                      if(isAiWordGenerationIsOn) {
                                        context.read<GeminiBloc>().add(LoadAiWordsEvent(noOfAiWordsToLoad: 5));
                                      } else {
                                        context.read<WordBloc>().add(LoadWords(noOfWordToSearch: 5));
                                      }
                                    },
                                    child: Text('Retry')),
                              ],
                            ),
                          );

                        default:
                          return Positioned.fill(
                              child: Center(child: Text('unknown state')));
                      }
                    },
                  )




                ],
              ),
),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primaryFixedDim,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                    value: BlocProvider.of<LaterWordFetchBloc>(context),
                    child: SettingScreen(),
                  )));
        },
        child: Icon(
          Icons.settings,
          color: Theme.of(context).colorScheme.onPrimaryFixed,
        ),
),
    );
  }
}
