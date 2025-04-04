import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_improve_vocabulary/features/gemini_ai/gemini_models/gemini_models.dart';
import 'package:flutter_improve_vocabulary/features/gemini_ai/prompts/prompts.dart';
import 'package:flutter_improve_vocabulary/features/gemini_ai/repository/gemini_ai_repository.dart';
import 'package:flutter_improve_vocabulary/features/gemini_ai/shared_Preference/gemini_status_storage.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:rxdart/rxdart.dart';

import '../../../api_key.dart';
import '../data_model/ai_word.dart';

part 'gemini_event.dart';
part 'gemini_state.dart';

class GeminiBloc extends Bloc<GeminiEvent, GeminiState> {

  bool isAiWordsGenerationOn = false;
  final GeminiRepository repository;
  List<String> examples = [];
  List<String> synonyms = [];
  List<String> antonyms = [];
  GeminiModels defaultModel = GeminiModels.Gemini15Flash;

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

    final model = GenerativeModel(
      // model: 'gemini-2.5-pro-exp-03-25',
      model : defaultModel.model,
      apiKey: apiKey,

    );

    on<ToggleGenerateWordsWithAiSwitchEvent>((event, emit) {
      isAiWordsGenerationOn = event.isOn;
    });

    on<LoadAiWordsEvent>(transformer: throttleRestartable(), (event, emit) async {

        emit(AiWordsLoadingState());
        final response = await repository.generateWords(promptForWords(5), model);
        if(response.isSuccess) {

          emit(AiWordsLoadedState(aiWords: response.data!));
        } else {
          emit(GeminiFailureState(errorMessage: response.failure!.errorMessage));
        }


    });


    on<LoadExamplesEvent>((event, emit) async {
      emit(ExamplesLoadingState());
      final response = await repository.generateExamples(
          event.wordName, event.limit, event.filterOut, model);

      if(response.isSuccess) {
        examples.addAll(response.data!);
        emit(ExamplesLoadedState(examples: examples));
      } else {
        emit(GeminiFailureState(errorMessage: response.failure!.errorMessage));
      }


    });


    on<LoadSynonymsEvent>((event, emit) async {
      emit(SynonymsLoadingState());
      final response = await repository.generateSynonyms(
          event.word, event.limit, event.filterOut, model);

      if(response.isSuccess) {
        synonyms.addAll(response.data!);
        emit(SynonymsLoadedState(synonyms: response.data!));
      } else {
        emit(GeminiFailureState(errorMessage: response.failure!.errorMessage));
      }


    });


    on<LoadAntonymsEvent>((event, emit) async {
      emit(AntonymsLoadingState());
      final response = await repository.generateAntonyms(
          event.word, event.limit, event.filterOut, model);

      if(response.isSuccess) {
        antonyms.addAll(response.data!);
        emit(AntonymsLoadedState(antonyms: response.data!));
      } else {
        emit(GeminiFailureState(errorMessage: response.failure!.errorMessage));
      }


    });


    on<ChangeGeminiModelEvent>((event, emit) {

      defaultModel = event.modelType;

    });

  }
}
