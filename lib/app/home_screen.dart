import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_improve_vocabulary/core/blocs/ViewSwitcherCubit/view_switcher_cubit.dart';
import 'package:flutter_improve_vocabulary/core/error/screen/home_error_screen.dart';
import 'package:flutter_improve_vocabulary/features/gemini_ai/bloc/gemini_bloc.dart';
import 'package:flutter_improve_vocabulary/core/shared/word_card.dart';
import 'package:flutter_improve_vocabulary/app/home_error_types_enum.dart';
import 'package:flutter_improve_vocabulary/features/search/presentation/screens/search_page.dart';
import 'package:flutter_improve_vocabulary/core/shared/loading_widget.dart';

import 'package:flutter_improve_vocabulary/features/settings/presentation/screens/settings.dart';

import '../core/blocs/network_bloc/internet_bloc.dart';
import '../core/shared/error_widget.dart';
import '../core/shared/card_widgets/word_slider.dart';
import '../core/shared/word_card_shimmer.dart';
import '../features/dictionary/bloc/word_bloc.dart';
import '../core/utility/above_banner.dart';
import '../core/blocs/later_word_fetch_bloc/later_word_fetch_bloc.dart';

class HomeScreen extends StatefulWidget {
  final int initialWordFetchLimit;

  const HomeScreen({required this.initialWordFetchLimit, super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    final isAiWordGenerationIsOn =
        context.read<GeminiBloc>().isAiWordsGenerationOn;
    if (isAiWordGenerationIsOn) {
      context.read<GeminiBloc>().add(
          LoadAiWordsEvent(noOfAiWordsToLoad: widget.initialWordFetchLimit));
    } else {
      context
          .read<WordBloc>()
          .add(LoadWords(noOfWordToSearch: widget.initialWordFetchLimit));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext homeContext)  {
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
                    ContentType contentType = state.status
                        ? ContentType.success
                        : ContentType.failure;

                    showOverlayBanner(scaffoldContext,
                        title: title,
                        message: message,
                        contentType: contentType);
                  },
                ),

              ],
              child:
              BlocBuilder<ViewSwitcherCubit, ViewMode>(
  builder: (context, state) {
    return
      IndexedStack(
                index: state.value,
                children: [
                  BlocConsumer<WordBloc, WordState>(
                    listener: (context, state) {
                      if (state is NoMoreWordAvailableState) {
                        context
                            .read<WordBloc>()
                            .add(LaterLoadWords(noOfWordsToLoad: 5));
                      }

                      if (state is LaterWordsLoading) {
                        String message = 'Loading more words.';
                        ContentType contentType = ContentType.help;

                        showOverlayBanner(scaffoldContext,
                            message: message,
                            contentType: contentType);
                      }

                      if (state is LaterWordsLoadingSuccess) {
                        String message = 'Loaded more words.';
                        ContentType contentType = ContentType.success;

                        showOverlayBanner(scaffoldContext,
                            message: message,
                            contentType: contentType);
                      }

                      if (state is PartialDataState) {
                        String message =
                            'Only ${state.wordFetchedCount} words loaded.';
                        ContentType contentType = ContentType.warning;

                        showOverlayBanner(scaffoldContext,
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

                        ContentType contentType = ContentType.failure;
                        late String message;

                        if (state.wordNotSearched == 0 ||
                            state.wordRetrived == 0) {
                          message = 'No Internet Connection.';
                        } else {
                          message =
                          'Only ${state.wordRetrived} words loaded. No Internet Connection.';
                        }

                        showOverlayBanner(
                          scaffoldContext,
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
                        case WordLoadingState():
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(30, 50, 30, 50),
                          child: WordCardShimmer(),
                        );
                        case FetchedSingleWordState():
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(30, 50, 30, 50),
                            child: Container(
                              color: Colors.transparent,
                              child: WordSlider(
                                  wordsLength:
                                  context.read<WordBloc>().allWords.length,
                                  // key: UniqueKey(),
                                  wordWidget: WordCard(word: state.word)

                              ),
                            ),
                          );
                        case InternetFailureState():
                          ElevatedButton button = ElevatedButton(
                              onPressed: () => context
                                  .read<WordBloc>()
                                  .add(LoadWords(
                                  noOfWordToSearch:
                                  widget.initialWordFetchLimit)),
                              child: Text('Retry'));
                          return Positioned.fill(
                              child: errorWidget(context, 'No Internet Connection', button)

                          );
                        case GeminiFailureWordState():
                        // <editor-fold>
                          ElevatedButton button = ElevatedButton(
                              onPressed: () {
                                final isAiWordGenerationIsOn = context
                                    .read<GeminiBloc>()
                                    .isAiWordsGenerationOn;
                                if (isAiWordGenerationIsOn) {
                                  context.read<GeminiBloc>().add(
                                      LoadAiWordsEvent(noOfAiWordsToLoad: 5));
                                } else {
                                  context
                                      .read<WordBloc>()
                                      .add(LoadWords(noOfWordToSearch: 5));
                                }
                              },
                              child: Text('Retry'));
                          // </editor-fold>
                          return Positioned.fill(
                              child: errorWidget(
                                  context, state.errorMessage, button));

                        default:
                          return Positioned.fill(
                              child: Center(child: Text('unknown state')));
                      }
                    },
                  ),

                  BlocConsumer<GeminiBloc, GeminiState>(
                    listener: (context, state) {



                      if (state is NoMoreAiWordsAvailableState) {
                        context
                            .read<GeminiBloc>()
                            .add(LoadAiWordsEvent(noOfAiWordsToLoad: context.read<LaterWordFetchBloc>().laterWordFetchLimit));
                      }

                      if (state is GeminiFailureState) {
                        String message = 'Something went wrong.';
                        ContentType contentType = ContentType.failure;

                        showOverlayBanner(scaffoldContext,
                            message: message, contentType: contentType);
                      }

                      if (state is AiWordsLoadingState) {
                        String message = 'Loading AI words.';
                        ContentType contentType = ContentType.help;

                        showOverlayBanner(scaffoldContext,
                            message: message, contentType: contentType);
                      }

                      if (state is AiWordsLoadedState) {
                        String message = 'Loaded more AI words.';
                        ContentType contentType = ContentType.success;

                        showOverlayBanner(scaffoldContext,
                            message: message, contentType: contentType);
                      }


                    },
                    listenWhen: (previousState, currentState) {
                      return (previousState != currentState) &&
                          [
                            NoMoreAiWordsAvailableState,
                            GeminiFailureState,
                            AiWordsLoadingState,
                            AiWordsLoadedState,

                          ].contains(currentState.runtimeType);
                    },
                    buildWhen: (previousState, currentState) {
                      return [
                        GeminiInitial,
                        AiWordsLoadingState,
                        SingleAiWordFetchState,
                        GeminiFailureState,
                      ].contains(currentState.runtimeType);
                    },
                    builder: (context, state){
                      switch (state) {
                        case GeminiInitial():
                        case AiWordsLoadingState():
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(30, 50, 30, 50),
                            child: WordCardShimmer(),
                          );
                        case SingleAiWordFetchState():
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(30, 50, 30, 50),
                            child: Container(
                              color: Colors.transparent,
                              child: WordSlider(
                                  wordsLength:
                                  context.read<WordBloc>().allWords.length,
                                  // key: UniqueKey(),
                                  wordWidget: WordCard(word: state.word)

                              ),
                            ),
                          );
                        case GeminiFailureState():
                        // <editor-fold>
                          ElevatedButton button = ElevatedButton(
                              onPressed: () {
                                final isAiWordGenerationIsOn = context
                                    .read<GeminiBloc>()
                                    .isAiWordsGenerationOn;
                                if (isAiWordGenerationIsOn) {
                                  context.read<GeminiBloc>().add(
                                      LoadAiWordsEvent(noOfAiWordsToLoad: 5));
                                } else {
                                  context
                                      .read<WordBloc>()
                                      .add(LoadWords(noOfWordToSearch: 5));
                                }
                              },
                              child: Text('Retry'));
                          // </editor-fold>
                          print(' gemini failure happened');
                          return Positioned.fill(
                              child: errorWidget(
                                  context, state.errorMessage, button));

                        default:
                          print('gemini default reached');
                          return Positioned.fill(
                              child: Center(child: Text('unknown state')));
                      }
                    },
                  ),


                ],
              )
    ;
  },
),
            ),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: null,
            backgroundColor: Theme.of(context).colorScheme.primaryFixedDim,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onPressed: () {
              _navigateToSearchScreen(homeContext);
            },
            child: Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.onPrimaryFixed,
            ),
          ),
          SizedBox(height: 12),
          FloatingActionButton(
            heroTag: null,
            backgroundColor: Theme.of(context).colorScheme.primaryFixedDim,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onPressed: () {
              _navigateToSettingsScreen(homeContext);
            },
            child: Icon(
              Icons.settings,
              color: Theme.of(context).colorScheme.onPrimaryFixed,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToSettingsScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: BlocProvider.of<LaterWordFetchBloc>(context),
                ),
                BlocProvider.value(
                  value: BlocProvider.of<GeminiBloc>(context),
                ),
              ],
              child: SettingScreen(),
            )));
  }

  void _navigateToSearchScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: BlocProvider.of<WordBloc>(context),
                ),
                BlocProvider.value(
                  value: BlocProvider.of<GeminiBloc>(context),
                ),
              ],
              child: SearchPage(),
            )));
  }


  Positioned blocConsumerForWord(BuildContext context, BuildContext scaffoldContext) {
     BlocConsumer<WordBloc, WordState>(
      listener: (context, state) {
        if (state is NoMoreWordAvailableState) {
          context
              .read<WordBloc>()
              .add(LaterLoadWords(noOfWordsToLoad: 5));
        }

        if (state is LaterWordsLoading) {
          String message = 'Loading more words.';
          ContentType contentType = ContentType.help;

          showOverlayBanner(scaffoldContext,
              message: message,
              contentType: contentType);
        }

        if (state is LaterWordsLoadingSuccess) {
          String message = 'Loaded more words.';
          ContentType contentType = ContentType.success;

          showOverlayBanner(scaffoldContext,
              message: message,
              contentType: contentType);
        }

        if (state is PartialDataState) {
          String message =
              'Only ${state.wordFetchedCount} words loaded.';
          ContentType contentType = ContentType.warning;

          showOverlayBanner(scaffoldContext,
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

          ContentType contentType = ContentType.failure;
          late String message;

          if (state.wordNotSearched == 0 ||
              state.wordRetrived == 0) {
            message = 'No Internet Connection.';
          } else {
            message =
            'Only ${state.wordRetrived} words loaded. No Internet Connection.';
          }

          showOverlayBanner(
            scaffoldContext,
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
          case WordLoadingState():
            return Positioned.fill(
                left: 30,
                right: 30,
                top: 50,
                bottom: 50,
                child: WordCardShimmer());
          case FetchedSingleWordState():
            return Positioned.fill(
              left: 30,
              right: 30,
              top: 50,
              bottom: 50,
              child: Container(
                color: Colors.transparent,
                child: WordSlider(
                    wordsLength:
                    context.read<WordBloc>().allWords.length,
                    // key: UniqueKey(),
                    wordWidget: WordCard(word: state.word)

                ),
              ),
            );
          case InternetFailureState():
            ElevatedButton button = ElevatedButton(
                onPressed: () => context
                    .read<WordBloc>()
                    .add(LoadWords(
                    noOfWordToSearch:
                    widget.initialWordFetchLimit)),
                child: Text('Retry'));
            return Positioned.fill(
                child: errorWidget(context, 'No Internet Connection', button)

            );
          case GeminiFailureWordState():
          // <editor-fold>
            ElevatedButton button = ElevatedButton(
                onPressed: () {
                  final isAiWordGenerationIsOn = context
                      .read<GeminiBloc>()
                      .isAiWordsGenerationOn;
                  if (isAiWordGenerationIsOn) {
                    context.read<GeminiBloc>().add(
                        LoadAiWordsEvent(noOfAiWordsToLoad: 5));
                  } else {
                    context
                        .read<WordBloc>()
                        .add(LoadWords(noOfWordToSearch: 5));
                  }
                },
                child: Text('Retry'));
            // </editor-fold>
            return Positioned.fill(
                child: errorWidget(
                    context, state.errorMessage, button));

          default:
            return Positioned.fill(
                child: Center(child: Text('unknown state')));
        }
      },
    );
     return Positioned.fill(
         child: Center(child: Text('unknown state')));
  }


  Positioned blocConsumerForGeminiAi(BuildContext context, BuildContext scaffoldContext) {
     BlocConsumer<GeminiBloc, GeminiState>(
      listener: (context, state) {



        if (state is NoMoreAiWordsAvailableState) {
          context
              .read<GeminiBloc>()
              .add(LoadAiWordsEvent(noOfAiWordsToLoad: context.read<LaterWordFetchBloc>().laterWordFetchLimit));
        }

        if (state is GeminiFailureState) {
          String message = 'Something went wrong.';
          ContentType contentType = ContentType.failure;

          showOverlayBanner(scaffoldContext,
              message: message, contentType: contentType);
        }

        if (state is AiWordsLoadingState) {
          String message = 'Loading AI words.';
          ContentType contentType = ContentType.help;

          showOverlayBanner(scaffoldContext,
              message: message, contentType: contentType);
        }

        if (state is AiWordsLoadedState) {
          String message = 'Loaded more AI words.';
          ContentType contentType = ContentType.success;

          showOverlayBanner(scaffoldContext,
              message: message, contentType: contentType);
        }


      },
      listenWhen: (previousState, currentState) {
        return (previousState != currentState) &&
            [
        NoMoreAiWordsAvailableState,
    GeminiFailureState,
    AiWordsLoadingState,
    AiWordsLoadedState,

            ].contains(currentState.runtimeType);
      },
      buildWhen: (previousState, currentState) {
        return [
              GeminiInitial,
              AiWordsLoadingState,
              SingleAiWordFetchState,
              GeminiFailureState,
            ].contains(currentState.runtimeType);
      },
      builder: (context, state){
        switch (state) {
          case GeminiInitial():
            return Positioned.fill(
                left: 30,
                right: 30,
                top: 50,
                bottom: 50,
                child: WordCardShimmer());
          case AiWordsLoadingState():
            return Positioned.fill(
                left: 30,
                right: 30,
                top: 50,
                bottom: 50,
                child: WordCardShimmer());
          case SingleAiWordFetchState():
            return Positioned.fill(
              left: 30,
              right: 30,
              top: 50,
              bottom: 50,
              child: Container(
                color: Colors.transparent,
                child: WordSlider(
                    wordsLength:
                    context.read<WordBloc>().allWords.length,
                    // key: UniqueKey(),
                    wordWidget: WordCard(word: state.word)

                ),
              ),
            );
          case GeminiFailureState():
          // <editor-fold>
            ElevatedButton button = ElevatedButton(
                onPressed: () {
                  final isAiWordGenerationIsOn = context
                      .read<GeminiBloc>()
                      .isAiWordsGenerationOn;
                  if (isAiWordGenerationIsOn) {
                    context.read<GeminiBloc>().add(
                        LoadAiWordsEvent(noOfAiWordsToLoad: 5));
                  } else {
                    context
                        .read<WordBloc>()
                        .add(LoadWords(noOfWordToSearch: 5));
                  }
                },
                child: Text('Retry'));
            // </editor-fold>
            print(' gemini failure happened');
            return Positioned.fill(
                child: errorWidget(
                    context, state.errorMessage, button));

          default:
            print('gemini default reached');
            return Positioned.fill(
                child: Center(child: Text('unknown state')));
        }
      },
    );
     return Positioned.fill(
         child: Center(child: Text('unknown state')));
  }

}
