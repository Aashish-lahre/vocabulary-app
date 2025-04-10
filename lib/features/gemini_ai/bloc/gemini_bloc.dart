import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_improve_vocabulary/core/utility/base_class.dart';
import 'package:flutter_improve_vocabulary/features/gemini_ai/gemini_models/gemini_models.dart';
import 'package:flutter_improve_vocabulary/features/gemini_ai/prompts/prompts.dart';
import 'package:flutter_improve_vocabulary/features/gemini_ai/repository/gemini_ai_repository.dart';
import 'package:flutter_improve_vocabulary/features/gemini_ai/shared_Preference/gemini_status_storage.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:rxdart/rxdart.dart';

import '../../../api_key.dart';
import '../../dictionary/models/word.dart';
import '../data_model/ai_word.dart';

part 'gemini_event.dart';
part 'gemini_state.dart';

class GeminiBloc extends Bloc<GeminiEvent, GeminiState> {

  bool isAiWordsGenerationOn;
  final GeminiRepository repository;
  // List<String> examples = [];
  // List<String> synonyms = [];
  // List<String> antonyms = [];
  GeminiModels defaultModel = GeminiModels.Gemini15Flash;

  EventTransformer<E> throttleRestartable<E>() {
    return (events, mapper) {
      return events
          .throttleTime(Duration(seconds: 3), trailing: false) // ✅ Allow first event, block others for 3 sec
          .asyncExpand(mapper);
    };
  }

  String getWordName(BaseWord word) {
    return switch(word) {
    Word _ => word.word,
    AiWord _ => word.wordName,
    _ =>  throw UnimplementedError('Unknown subclass of BaseWord'),
    };
  }



  GeminiBloc({required this.repository, required this.isAiWordsGenerationOn}) : super(GeminiInitial()) {


    final model = GenerativeModel(
      // model: 'gemini-2.5-pro-exp-03-25',
      model : defaultModel.model,
      apiKey: apiKey,

    );

    on<ToggleGenerateWordsWithAiSwitchEvent>((event, emit) {
      isAiWordsGenerationOn = event.isOn;
      GeminiStatusStorage.instance.changeGeminiStatus(isAiWordsGenerationOn);
    });

    on<LoadAiWordsEvent>(transformer: throttleRestartable(), (event, emit) async {

        emit(AiWordsLoadingState());
        final response = await repository.generateWords(promptForWords(event.noOfAiWordsToLoad), model);
        if(response.isSuccess) {

          emit(AiWordsLoadedState(aiWords: response.data!));
        } else {
          emit(GeminiWordsLoadFailureState(errorMessage: response.failure!.errorMessage));
        }


    });


    on<SearchWordWithAiEvent>((event, emit) async {
        emit(SingleAiWordLoadingState());

        final response = await repository.generateSingleWord(event.wordName, model);

        if(response.isSuccess) {
          emit(SingleAiWordFetchedState(word: response.data!));
        } else {
          emit(GeminiSingleWordLoadFailureState(errorMessage: response.failure!.errorMessage));
        }

    });


    on<LoadExamplesEvent>((event, emit) async {
      emit(ExamplesLoadingState());
      final response = await repository.generateExamples(
          getWordName(event.word), event.limit, event.filterOut, model);

      if(response.isSuccess) {
        BaseWord word = event.word;
        var updatedWord = switch(word) {
          Word _ => word..allExamples.addAll(response.data!),
          AiWord _ => word..example.addAll(response.data!),
          _ => word,
        };
        emit(ExamplesLoadedState(examples: response.data!, word: updatedWord));
      } else {
        emit(GeminiFailureState(errorMessage: response.failure!.errorMessage));
      }


    });


    on<LoadSynonymsEvent>((event, emit) async {
      emit(SynonymsLoadingState());
      final response = await repository.generateSynonyms(
          getWordName(event.word), event.limit, event.filterOut, model);

      if(response.isSuccess) {
        BaseWord word = event.word;
        var updatedWord = switch(word) {
          Word _ => word..allSynonyms.addAll(response.data!),
          AiWord _ => word..synonyms.addAll(response.data!),
          _ => word,
        };

        emit(SynonymsLoadedState(synonyms: response.data!, word: updatedWord));
      } else {
        emit(GeminiFailureState(errorMessage: response.failure!.errorMessage));
      }


    });


    on<LoadAntonymsEvent>((event, emit) async {
      emit(AntonymsLoadingState());
      final response = await repository.generateAntonyms(
          getWordName(event.word), event.limit, event.filterOut, model);

      if(response.isSuccess) {
        BaseWord word = event.word;
        var updatedWord = switch(word) {
          Word _ => word..allAntonyms.addAll(response.data!),
          AiWord _ => word..antonyms.addAll(response.data!),
          _ => word,
        };

        emit(AntonymsLoadedState(antonyms: response.data!, word: updatedWord));
      } else {
        emit(GeminiFailureState(errorMessage: response.failure!.errorMessage));
      }


    });


    on<ChangeGeminiModelEvent>((event, emit) {

      defaultModel = event.modelType;


    });

  }
}
