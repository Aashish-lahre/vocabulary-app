import 'package:shared_preferences/shared_preferences.dart';

import 'color_theme.dart';

class ThemeStorage {

  ThemeStorage._();
  static final instance = ThemeStorage._();


  SharedPreferencesAsync prefsAsync = SharedPreferencesAsync();


  Future<void> saveThemeType(ThemeType themeType) async {


    await prefsAsync.setString('themeType', themeType.name);
  }


  Future<ThemeType> getThemeType() async {

    String? themeTypeName = await prefsAsync.getString('themeType');
    themeTypeName ??= 'auto';

    ThemeType themeType = ThemeType.values.firstWhere((e) => e.name == themeTypeName, orElse: () => ThemeType.auto);

    return themeType;



  }







}


