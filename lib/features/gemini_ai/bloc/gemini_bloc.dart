import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_improve_vocabulary/features/gemini_ai/prompts/prompts.dart';
import 'package:flutter_improve_vocabulary/features/gemini_ai/repository/gemini_ai_repository.dart';
import 'package:flutter_improve_vocabulary/features/gemini_ai/shared_Preference/gemini_status_storage.dart';
import 'package:rxdart/rxdart.dart';

import '../model/ai_word.dart';

part 'gemini_event.dart';
part 'gemini_state.dart';

class GeminiBloc extends Bloc<GeminiEvent, GeminiState> {

  bool isAiWordsGenerationOn = false;
  final GeminiRepository repository;
  // List<AiWord> aiWords = [];
  // int aiWordIndex = 0;
  // bool isAiWordsShow = false;

  EventTransformer<E> throttleRestartable<E>() {
    return (events, mapper) {
      return events
          .throttleTime(Duration(seconds: 3), trailing: false) // ✅ Allow first event, block others for 3 sec
          .asyncExpand(mapper);
    };
  }


  GeminiBloc({required this.repository}) : super(GeminiInitial()) {

    void loadGeminiStatus() async {
      isAiWordsGenerationOn = await GeminiStatusStorage().getGeminiStatus;
    }
    loadGeminiStatus();

    on<ToggleGenerateWordsWithAiSwitchEvent>((event, emit) {
      isAiWordsGenerationOn = event.isOn;
    });

    on<LoadAiWordsEvent>(transformer: throttleRestartable(), (event, emit) async {

        emit(AiWordsLoadingState());
        final response = await repository.generateWords(promptForWords(5));
        if(response.isSuccess) {
            // aiWords.addAll(response.data!);
            // emit(AiWordsLoadedState());
            // if(aiWordIndex == 0) {
            //   emit(SingleAiWordFetchedState(word: aiWords[aiWordIndex]));
            // }
          emit(AiWordsLoadedState(aiWords: response.data!));
        } else {
          emit(GeminiFailureState(errorMessage: response.failure!.errorMessage));
        }


    });

    // on<LoadSingleAiWordEvent>((event, emit) {
    //   if(++aiWordIndex < aiWords.length) {
    //     emit(SingleAiWordFetchedState(word: aiWords[aiWordIndex]));
    //   } else {
    //     // index for words exceeds allWords items
    //     emit(NoMoreAiWordsAvailableState());
    //   }
    // });


  }
}
