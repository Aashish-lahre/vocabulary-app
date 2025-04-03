
import 'package:shared_preferences/shared_preferences.dart';

class WordFetchLimit {

  WordFetchLimit._();
  static final instance = WordFetchLimit._();

  factory WordFetchLimit() => instance;


  SharedPreferencesAsync prefs = SharedPreferencesAsync();

  Future<int> get getWordFetchLimit async {
    int? limit = await prefs.getInt('wordFetchLimit');

    limit ??= 5;

    return limit;
  }


  void changeWordFetchLimit(int newLimit) async {
    await prefs.setInt('wordFetchLimit', newLimit);
  }




}