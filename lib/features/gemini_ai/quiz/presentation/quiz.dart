
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:gap/gap.dart';
import 'package:interactive_slider/interactive_slider.dart';
import 'package:text_to_speech/text_to_speech.dart';

import '../bloc/quiz_bloc.dart';

// ignore_for_file: constant_identifier_names




// Difficulty for quiz questions.
enum SliderDifficulty {
  VeryEasy(value: 0.0, name: 'Very Easy'),
  Easy(value: 0.15, name: 'Easy'),
  Beginner(value: 0.3, name: 'Beginner'),
  Intermediate(value: 0.45, name: 'Intermediate'),
  Hard(value: 0.6, name: 'Hard'),
  VeryHard(value: 0.75, name: 'Very Hard'),
  Expert(value: 0.9, name: 'Expert');

  final double value;
  final String name;
  const SliderDifficulty({required this.value, required this.name});
}


class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {

  // default language for text to speech.
  final String defaultLanguage = 'en-US';

  TextToSpeech tts = TextToSpeech();
  late final InteractiveSliderController _controller;
  double _bottomSheetHeight = 60;
  late final ValueNotifier<double> _difficultyValueNotifier;


  String text = '';
  double volume = 1; // Range: 0-1
  double rate = 1.0; // Range: 0-2
  double pitch = 1.0; // Range: 0-2

  String? language;
  String? languageCode;
  List<String> languages = <String>[];
  List<String> languageCodes = <String>[];
  String? voice;



  @override
  void initState() {
    _controller = InteractiveSliderController(context.read<QuizBloc>().wordDifficultyLevel);
    _difficultyValueNotifier = ValueNotifier(context.read<QuizBloc>().wordDifficultyLevel);
    context.read<QuizBloc>().add(LoadQuestionsEvent(difficulty: 0.3, limit: 5, filter: null));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initLanguages();
    });
    super.initState();
  }

  Future<void> initLanguages() async {
    /// populate lang code (i.e. en-US)
    languageCodes = await tts.getLanguages();

    /// populate displayed language (i.e. English)
    final List<String>? displayLanguages = await tts.getDisplayLanguages();
    if (displayLanguages == null) {
      return;
    }

    languages.clear();
    for (final dynamic lang in displayLanguages) {
      languages.add(lang as String);
    }

    final String? defaultLangCode = await tts.getDefaultLanguage();
    if (defaultLangCode != null && languageCodes.contains(defaultLangCode)) {
      languageCode = defaultLangCode;
    } else {
      languageCode = defaultLanguage;
    }
    language = await tts.getDisplayLanguageByCode(languageCode!);

    /// get voice
    voice = await getVoiceByLang(languageCode!);

    if (mounted) {
      setState(() {});
    }
  }

  Future<String?> getVoiceByLang(String lang) async {
    final List<String>? voices = await tts.getVoiceByLang(languageCode!);

    if (voices != null && voices.isNotEmpty) {
      return voices.first; 
    }
    return null;
  }



  SliderDifficulty getDifficultyFromValue(double value) {
    if (value <= SliderDifficulty.Easy.value) {
      return SliderDifficulty.Easy;
    } else if (value <= SliderDifficulty.Beginner.value) {
      return SliderDifficulty.Beginner;
    } else if (value <= SliderDifficulty.Intermediate.value) {
      return SliderDifficulty.Intermediate;
    } else if (value <= SliderDifficulty.Hard.value) {
      return SliderDifficulty.Hard;
    } else if (value <= SliderDifficulty.VeryHard.value) {
      return SliderDifficulty.VeryHard;
    } else {
      return SliderDifficulty.Expert;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _difficultyValueNotifier.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: BlocBuilder<QuizBloc, QuizState>(
        
        builder: (context, state) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SingleChildScrollView(
                child: Builder(
                  builder: (context) {
                    // Access `state` here
                    if (state is LoadingQuestionsState || state is QuizInitial) {
                      return Padding(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .45, left: MediaQuery.of(context).size.width * .35),
                          child: CircularProgressIndicator());
                    } else if (state is LoadedNextQuestion) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        tts.stop();
                        tts.speak(state.question);
                      });
                      return Column(
                        children: [
                          const Gap(100),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                  'Question ${context.read<QuizBloc>().currentShowingQuestionInUiIndex + 1}',
                                  style: textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                  '/${context.read<QuizBloc>().questionsListWithExpectedAnswer.length}',
                                  style: textTheme.titleLarge!.copyWith(
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ],
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                          const Gap(10),
                          ValueListenableBuilder<double>(
                            valueListenable: _difficultyValueNotifier,
                            builder: (context, difficulty, child) {
                              return InteractiveSlider(
                                unfocusedOpacity: 1,
                                controller: _controller,
                                min: 0.1,
                                centerIcon: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    getDifficultyFromValue(difficulty).name, // Dynamically change name
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFA8E6CF),
                                    Color(0xFFFFF3B0),
                                    Color(0xFFFFB3B3),
                                  ],
                                ),
                                unfocusedHeight: 30,
                                focusedHeight: 50,
                                onChanged: (value) {
                                  _difficultyValueNotifier.value = value; // Update the difficulty value
                                },
                                onProgressUpdated: (value) {
                                  context.read<QuizBloc>().add(ChangeDifficultyEvent(difficulty: value));
                                },
                              );
                            },
                          ),
                          
                          // question...
                          Text(
                            state.question,
                            style: textTheme.bodyMedium!.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const Gap(5),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              onPressed: () {
                                tts.stop();
                                tts.speak(state.question);

                              },
                              icon: const Icon(Icons.volume_up_rounded),
                            ),
                          ),
                          const Gap(5),

                          InkWell(
                              onTap: () {},
                              child: CircleAvatar(radius: 30, child: Icon(Icons.mic, size: 30,),)),

                          Gap(200),
                          // Skip question button...
                          Container(
                            width: double.infinity,
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                if(_bottomSheetHeight <=0) {
                                  setState(() {
                                    _bottomSheetHeight = 60;
                                  });
                                }
                    context.read<QuizBloc>().add(LoadNextQuestionEvent());
                    } ,
                              child: Container(
                                width: 100,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: colorScheme.primaryContainer,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Skip',
                                      style: textTheme.bodyMedium!.copyWith(
                                        color: colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      color: colorScheme.onPrimaryContainer,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else if (state is CheckingUserAnswerState) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          _bottomSheetHeight = 0;
                        });
                      });
                      return Column(
                        children: [
                          const Gap(100),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                  'Question ${context.read<QuizBloc>().currentShowingQuestionInUiIndex + 1}',
                                  style: textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                  '/${context.read<QuizBloc>().questionsListWithExpectedAnswer.length}',
                                  style: textTheme.titleLarge!.copyWith(
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ],
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                          const Gap(10),


                          // question...
                          Text(
                            state.question,
                            style: textTheme.bodyMedium!.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const Gap(5),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              onPressed: null,
                              icon: const Icon(Icons.volume_up_rounded),
                            ),
                          ),
                          const Gap(5),
                          // Chat bubble
                          Container(
                            width: double.infinity,
                            alignment: Alignment.centerRight,
                            child: Container(
                              decoration: BoxDecoration(
                                color: colorScheme.primaryFixed,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * .6,
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                state.userAnswer,
                                style: textTheme.bodyMedium!.copyWith(
                                  color: colorScheme.onPrimaryFixed,
                                ),
                              ),
                            ),
                          ),
                          const Gap(10),
                          Container(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IconButton(
                                  onPressed: null,
                                  icon: const Icon(Icons.volume_up_rounded),
                                ),


                                // AI Response...
                                Center(child: CircularProgressIndicator(),),
                              ],
                            ),
                          ),


                          // Next question button...
                          Container(
                            width: double.infinity,
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: null,
                              child: Container(
                                width: 100,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: colorScheme.primaryContainer,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Next',
                                      style: textTheme.bodyMedium!.copyWith(
                                        color: colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      color: colorScheme.onPrimaryContainer,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else if (state is CheckedUserAnswerState) {
                      assert(_bottomSheetHeight == 0);

                        WidgetsBinding.instance.addPostFrameCallback((_) {
    if(state.aiReactionToUserAnswer['isCorrect'] as bool) {
      Confetti.launch(
        context,
        options: const ConfettiOptions(
            particleCount: 100, spread: 70, y: 0.6),
      );
    }

                            tts.stop();
                            tts.speak(state.aiReactionToUserAnswer['feedback']);

                        });



                      return Column(
                        children: [
                          const Gap(100),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                  'Question ${context.read<QuizBloc>().currentShowingQuestionInUiIndex + 1}',
                                  style: textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                  '/${context.read<QuizBloc>().questionsListWithExpectedAnswer.length}',
                                  style: textTheme.titleLarge!.copyWith(
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ],
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                          const Gap(10),
                          ValueListenableBuilder<double>(
                            valueListenable: _difficultyValueNotifier,
                            builder: (context, difficulty, child) {
                              return InteractiveSlider(
                                unfocusedOpacity: 1,
                                controller: _controller,
                                min: 0.1,
                                centerIcon: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    getDifficultyFromValue(difficulty).name, // Dynamically change name
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFA8E6CF),
                                    Color(0xFFFFF3B0),
                                    Color(0xFFFFB3B3),
                                  ],
                                ),
                                unfocusedHeight: 30,
                                focusedHeight: 50,
                                onChanged: (value) {
                                  _difficultyValueNotifier.value = value; // Update the difficulty value
                                },
                                onProgressUpdated: (value) {
                                  context.read<QuizBloc>().add(ChangeDifficultyEvent(difficulty: value));
                                },
                              );
                            },
                          ),

                          // question...
                          Text(
                            state.question,
                            style: textTheme.bodyMedium!.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const Gap(5),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              onPressed: () {
                                tts.stop();
                                tts.speak(state.aiReactionToUserAnswer['feedback']);
                              },
                              icon: const Icon(Icons.volume_up_rounded),
                            ),
                          ),
                          const Gap(5),
                          // Chat bubble
                          Container(
                            width: double.infinity,
                            alignment: Alignment.centerRight,
                            child: Container(
                              decoration: BoxDecoration(
                                color: colorScheme.primaryFixed,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * .6,
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                state.userAnswer,
                                style: textTheme.bodyMedium!.copyWith(
                                  color: colorScheme.onPrimaryFixed,
                                ),
                              ),
                            ),
                          ),
                          const Gap(10),
                          Container(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    tts.stop();
                                    tts.speak(state.aiReactionToUserAnswer['feedback']);
                                  },
                                  icon: const Icon(Icons.volume_up_rounded),
                                ),


                                // AI Response...
                                Text(
                                  state.aiReactionToUserAnswer['feedback'],
                                  style: textTheme.bodyLarge!.copyWith(
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                Gap(10),
                                Text("Correct Answer : ${ state.aiReactionToUserAnswer['correctAnswer']}",
                                 
                                  style: textTheme.bodyLarge!.copyWith(
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),


                          // Next question button...
                          Container(
                            width: double.infinity,
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _bottomSheetHeight = 60;
                                });
                    context.read<QuizBloc>().add(LoadNextQuestionEvent());
                    } ,
                              child: Container(
                                width: 100,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: colorScheme.primaryContainer,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Next',
                                      style: textTheme.bodyMedium!.copyWith(
                                        color: colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      color: colorScheme.onPrimaryContainer,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    
                    else {
                      return Center(child: Text(state.runtimeType.toString(), style: TextStyle(fontSize: 30),),);
                    }
                  },
                ),
              ),
            ),

            bottomSheet: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: _bottomSheetHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _bottomSheetHeight == 0
                  ? const SizedBox.shrink()
                  : Center(
                child: TextField(
                  style: textTheme.bodyLarge!.copyWith(
                    color: colorScheme.onSecondaryContainer,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Type Answer...',
                    hintStyle: textTheme.bodyLarge!.copyWith(
                      color: colorScheme.onSecondaryContainer,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onSubmitted: (text) {
                    if (state is LoadedNextQuestion) {
                      context.read<QuizBloc>().add(
                        CheckUserAnswerEvent(
                          userAnswer: text,
                          question: state.question,
                          expectedAnswer: state.expectedAnswer,
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

}
