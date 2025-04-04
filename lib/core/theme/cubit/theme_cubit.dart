import 'package:bloc/bloc.dart';
import 'package:flutter_improve_vocabulary/core/theme/theme_storage.dart';


import '../color_theme.dart';


class ThemeCubit extends Cubit<ThemeType> {

  ThemeType themeType;
  ThemeCubit({required this.themeType}) : super(themeType);


  Future<void> changeThemeType(ThemeType changeThemeType) async {
        emit(changeThemeType);
        await ThemeStorage.instance.saveThemeType(changeThemeType);
  }


  Future<void> loadThemeType() async {
    ThemeType themeType = await ThemeStorage.instance.getThemeType();
    emit(themeType);
  }
}
