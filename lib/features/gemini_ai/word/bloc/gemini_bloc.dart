import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:google_generative_ai/google_generative_ai.dart';


import '../../gemini_models.dart';
import '../prompts/prompts.dart';
import '../repository/gemini_ai_repository.dart';
import '../shared_Preference/gemini_status_storage.dart';
import '../../../../api_key.dart';
import '../../../../core/models/word.dart';
import '../../../../core/utility/result.dart';
import '../../gemini_errors.dart';

part 'gemini_event.dart';
part 'gemini_state.dart';

class GeminiBloc extends Bloc<GeminiEvent, GeminiState> {

  bool isAiWordsGenerationOn;
  final GeminiRepositoryForWord repository;
  int wordIndex = 0;
  final List<Word> allWords = [];
  GeminiModels defaultModel = GeminiModels.Gemini15Flash;
  late GenerativeModel model;

  EventTransformer<E> throttleRestartable<E>() {
    return (events, mapper) {
      return events
          .throttleTime(Duration(seconds: 3), trailing: false) // ✅ Allow first event, block others for 3 sec
          .asyncExpand(mapper);
    };
  }




  GeminiBloc({required this.repository, required this.isAiWordsGenerationOn}) : super(GeminiInitial()) {


    model = GenerativeModel(
      // model: 'gemini-2.5-pro-exp-03-25',
      model : defaultModel.model,
      apiKey: apiKey,

    );
    /// event fired when user toggles the gemini AI switch in settings page to generate words using Gemini AI.
    on<ToggleGenerateWordsWithAiSwitchEvent>((event, emit) {
      isAiWordsGenerationOn = event.isOn;
      GeminiStatusStorage.instance.changeGeminiStatus(isAiWordsGenerationOn);
      emit(AiWordsSwitchChangedState(isOn: isAiWordsGenerationOn));
    });

    on<LoadAiWordsEvent>(transformer: throttleRestartable(), (event, emit) async {
        emit(AiWordsLoadingState());
        final Result<List<Word>, GeminiError> response = await repository.generateWords(promptForWords(event.noOfAiWordsToLoad), model);
        if(response.isSuccess) {
          allWords.addAll(response.data!);
          emit(AiWordsLoadedState(words: response.data!));
          if(event.autoLoad) {

            emit(SingleAiWordFetchState(word: allWords[wordIndex]));
          } else {

            if(wordIndex == 0) {
              wordIndex = -1;

            }
          }


        } else {

          if(response.failure!.runtimeType == GeminiInvalidApiKey) {
            emit(GeminiInvalidApiKeyState(errorMessage: response.failure!.errorMessage));
          } else {
            emit(GeminiFailureState(errorMessage: response.failure!.errorMessage));
          }
          
          
        }


    });


    on<LoadSingleAiWordInOrderEvent>((event, emit) {
      if(++wordIndex < allWords.length) {
        emit(SingleAiWordFetchState(word: allWords[wordIndex]));
      } else {
        // index for words exceeds allWords items
        emit(NoMoreAiWordsAvailableState());
      }
    });




    on<SearchWordWithAiEvent>((event, emit) async {
        emit(AiWordSearchingState());

        final response = await repository.generateSingleWord(event.wordName, model);

        if(response.isSuccess) {
          emit(AiWordSearchCompleteState(word: response.data!));
        } else {
          
            emit(GeminiSingleWordLoadFailureState(errorMessage: response.failure!.errorMessage));
          
        }

    });


    on<LoadExamplesEvent>((event, emit) async {
      emit(ExamplesLoadingState());
      final response = await repository.generateExamples(
          event.word.wordName, event.limit, event.filterOut, model);

      if(response.isSuccess) {
        Word word = event.word;
        word.examples.addAll(response.data!);


        emit(ExamplesLoadedState(examples: response.data!, word: word));
      } else {
        if(response.failure!.runtimeType == GeminiInvalidApiKey) {
          emit(GeminiInvalidApiKeyState(errorMessage: response.failure!.errorMessage));
        } else {
          emit(GeminiFailureState(errorMessage: response.failure!.errorMessage));
        }
      }


    });


    on<LoadSynonymsEvent>((event, emit) async {
      emit(SynonymsLoadingState());
      final response = await repository.generateSynonyms(
          event.word.wordName, event.limit, event.filterOut, model);

      if(response.isSuccess) {
        Word word = event.word;
        word.synonyms.addAll(response.data!);


        emit(SynonymsLoadedState(synonyms: response.data!, word: word));
      } else {
        if(response.failure!.runtimeType == GeminiInvalidApiKey) {
          emit(GeminiInvalidApiKeyState(errorMessage: response.failure!.errorMessage));
        } else {
          emit(GeminiFailureState(errorMessage: response.failure!.errorMessage));
        }
      }


    });


    on<LoadAntonymsEvent>((event, emit) async {
      emit(AntonymsLoadingState());
      final response = await repository.generateAntonyms(
          event.word.wordName, event.limit, event.filterOut, model);

      if(response.isSuccess) {
        Word word = event.word;
        word.antonyms.addAll(response.data!);


        emit(AntonymsLoadedState(antonyms: response.data!, word: word));
      } else {
        if(response.failure!.runtimeType == GeminiInvalidApiKey) {
          emit(GeminiInvalidApiKeyState(errorMessage: response.failure!.errorMessage));
        } else {
          emit(GeminiFailureState(errorMessage: response.failure!.errorMessage));
        }
      }


    });


    on<ChangeGeminiModelEvent>((event, emit) {
      defaultModel = event.modelType;
      model = GenerativeModel(
        model: defaultModel.model,
        apiKey: apiKey,
      );
    });

  }

}
