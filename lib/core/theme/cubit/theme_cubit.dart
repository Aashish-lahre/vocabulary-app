import 'package:bloc/bloc.dart';


import '../color_theme.dart';


class ThemeCubit extends Cubit<ThemeType> {

  ThemeCubit() : super(ThemeType.auto);


  void changeThemeType(ThemeType changeThemeType) {
    print('received theme type : $changeThemeType');
        emit(changeThemeType);
  }
}
