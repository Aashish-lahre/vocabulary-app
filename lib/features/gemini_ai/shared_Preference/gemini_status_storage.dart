

import 'package:shared_preferences/shared_preferences.dart';

class GeminiStatusStorage {


      GeminiStatusStorage._();

      static final instance = GeminiStatusStorage._();

      factory GeminiStatusStorage() => instance;



      final prefs = SharedPreferencesAsync();

      Future<bool> get getGeminiStatus async {
        bool? status = await prefs.getBool('isOn');

        status ??= false;

        return status;
      }


       Future<void> changeGeminiStatus(bool newStatus) async {
        await prefs.setBool('isOn', newStatus);
      }
}