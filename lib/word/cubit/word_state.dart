part of 'word_cubit.dart';



enum WordStatus {
  initial, loading, success, failure
}


extension WordStatusX on WordStatus {
  bool get isInitial => this == WordStatus.initial;
  bool get isLoading => this == WordStatus.loading;
  bool get isSuccess => this == WordStatus.success;
  bool get isFailure => this == WordStatus.failure;

}



@JsonSerializable()
final class WordState extends Equatable {

  WordState(
    {
      this.wordStatus = WordStatus.initial,
      Word? word
    }
  ) : word = word ?? Word.empty ;

  final WordStatus wordStatus;
  final Word word;


  factory WordState.fromJson(Map<String, dynamic> json) => _$WordStateFromJson(json);
  Map<String, dynamic> toJson() => _$WordStateToJson(this);

  WordState copyWith(
    {
      WordStatus? wordStatus,
      Word? word,
    }
  ) {
    return WordState(
      wordStatus: wordStatus ?? this.wordStatus,
      word: word ?? this.word,
    );
  }



 @override
  List<Object?> get props => [wordStatus, word];


}


