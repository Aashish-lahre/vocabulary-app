import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/blocs/ViewSwitcherCubit/view_switcher_cubit.dart';
import '../core/error/screen/home_error_screen.dart';
import '../features/gemini_ai/bloc/gemini_bloc.dart';
import '../core/shared/word_card.dart';
import './home_error_types_enum.dart';
import '../features/search/presentation/screens/search_page.dart';
import '../features/settings/presentation/screens/settings.dart';
import '../core/blocs/network_bloc/internet_bloc.dart';
import '../core/shared/error_widget.dart';
import '../core/shared/card_widgets/word_slider.dart';
import '../core/shared/word_card_shimmer.dart';
import '../features/dictionary/bloc/word_bloc.dart';
import '../core/utility/above_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // Initialize word loading based on the selected mode (AI or Dictionary API)
    final isAiWordGenerationIsOn =
        context.read<GeminiBloc>().isAiWordsGenerationOn;

    int moreWordFetchLimit = context.read<WordBloc>().moreWordFetchLimit;

    // Load initial words based on the selected mode
    if (isAiWordGenerationIsOn) {
      context.read<GeminiBloc>().add(LoadAiWordsEvent(
          noOfAiWordsToLoad: moreWordFetchLimit, autoLoad: true));
    } else {
      context
          .read<WordBloc>()
          .add(LoadWords(noOfWordToSearch: moreWordFetchLimit, autoLoad: true));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext homeContext) {
    return Scaffold(
      body: Builder(
        builder: (scaffoldContext) {
          return SizedBox.expand(
           // Listen for internet connectivity changes and show appropriate messages
            child: BlocListener<InternetBloc, InternetState>(
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
            
              // ViewSwitcherCubit manages switching between Dictionary API and Gemini AI modes
              child: BlocBuilder<ViewSwitcherCubit, ViewSwitcherState>(
                buildWhen: (_, currentState) {
                  return (currentState is! ViewModeChanged);
                },
                builder: (context, viewState) {
                  // IndexedStack to switch between Dictionary API and Gemini AI views
                  return IndexedStack(
                    index: viewState.mode.value,
                    children: [
                      // Dictionary API Word Display
                      BlocConsumer<WordBloc, WordState>(
                        listener: (context, state) {
                          if (state is NoMoreWordAvailableState) {
                            context.read<WordBloc>().add(LoadWords(
                                noOfWordToSearch:
                                    context.read<WordBloc>().moreWordFetchLimit,
                                autoLoad: true));
                          }

                          if (state is MoreWordsLoadingState) {
                            String message = 'Loading words.';
                            ContentType contentType = ContentType.help;

                            showOverlayBanner(scaffoldContext,
                                message: message, contentType: contentType);
                          }

                          if (state is MoreWordsLoadingSuccessState) {
                            String message = 'Loaded more words.';
                            ContentType contentType = ContentType.success;

                            showOverlayBanner(scaffoldContext,
                                message: message, contentType: contentType);
                          }

                          if (state is PartialDataState) {
                            String message =
                                'Only ${state.wordFetchedCount} words loaded.';
                            ContentType contentType = ContentType.warning;

                            showOverlayBanner(scaffoldContext,
                                message: message, contentType: contentType);
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
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
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
                        },
                        listenWhen: (previousState, currentState) {
                          return (previousState != currentState) &&
                              [
                                NoMoreWordAvailableState,
                                MoreWordsLoadingState,
                                MoreWordsLoadingSuccessState,
                                PartialDataState,
                                UnexpectedState,
                                InternetFailureState,
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
                                WordsLoadingState,
                                FetchedSingleWordState,
                              ].contains(currentState.runtimeType);
                        },
                        builder: (context, state) {
                          switch (state) {
                            case WordInitial():
                            case WordsLoadingState():
                              return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(30, 50, 30, 50),
                                child: WordCardShimmer(),
                              );
                            case FetchedSingleWordState():
                              return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(30, 50, 30, 50),
                                child: Container(
                                  color: Colors.transparent,
                                  child: WordSlider(
                                      key: UniqueKey(),
                                      wordWidget: WordCard(
                                        word: state.word,
                                        bannerName:
                                            'Dictionary API Generated Word.',
                                      )),
                                ),
                              );
                            case InternetFailureState():
                              ElevatedButton button = ElevatedButton(
                                  onPressed: () => context.read<WordBloc>().add(
                                      LoadWords(
                                          noOfWordToSearch: context
                                              .read<WordBloc>()
                                              .moreWordFetchLimit,
                                          autoLoad: true)),
                                  child: Text('Retry'));
                              return Positioned.fill(
                                  child: errorWidget(context,
                                      'No Internet Connection', button));

                            default:
                              return Positioned.fill(
                                  child: Center(child: Text('unknown state')));
                          }
                        },
                      ),
                      
                      // Gemini AI Word Display
                      BlocConsumer<GeminiBloc, GeminiState>(
                        listener: (context, state) {
                          if (state is NoMoreAiWordsAvailableState) {
                            context.read<GeminiBloc>().add(LoadAiWordsEvent(
                                noOfAiWordsToLoad:
                                    context.read<WordBloc>().moreWordFetchLimit,
                                autoLoad: false));
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
                            SingleAiWordFetchState,
                            GeminiFailureState,
                          ].contains(currentState.runtimeType);
                        },
                        builder: (context, state) {
                          switch (state) {
                            case GeminiInitial():
                            case AiWordsLoadingState():
                              return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(30, 50, 30, 50),
                                child: WordCardShimmer(),
                              );
                            case SingleAiWordFetchState():
                              return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(30, 50, 30, 50),
                                child: Container(
                                  color: Colors.transparent,
                                  child: WordSlider(
                                      key: UniqueKey(),
                                      wordWidget: WordCard(
                                        word: state.word,
                                        bannerName: 'AI Generated Word.',
                                      )),
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
                                          LoadAiWordsEvent(
                                              noOfAiWordsToLoad: 5,
                                              autoLoad: true));
                                    } else {
                                      context.read<WordBloc>().add(LoadWords(
                                          noOfWordToSearch: 5, autoLoad: true));
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
                    ],
                  );
                },
              ),
            ),
          
          );
        },
      ),
      // Navigation buttons for Search and Settings
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Search button
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
          // Settings button
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
                  value: BlocProvider.of<WordBloc>(context),
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
}
