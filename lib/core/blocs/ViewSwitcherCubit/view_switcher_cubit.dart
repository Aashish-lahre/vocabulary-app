import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'view_switcher_state.dart';

enum ViewMode {

  dictionaryApi(value : 0),
  geminiAi(value: 1);

  final int value;

  const ViewMode({required this.value});
}


class ViewSwitcherCubit extends Cubit<ViewSwitcherState> {

  ViewMode viewMode;
  ViewSwitcherCubit( this.viewMode) : super(ViewSwitcherInitial(mode: viewMode));


  // changeViewMode is used to represent from where we are featching the data. i.e. Gemini AI or Dictionary API.
  void changeViewMode(ViewMode newMode) {
    viewMode = newMode;

    emit(ViewModeChanged(mode: newMode));
  }

  // updateViewMode handles the change in BlocConsumer in home_screen.
  void updateViewMode(ViewMode newMode) {

    viewMode = newMode;
    emit(ViewModeUpdate(mode: newMode));
  }
}


