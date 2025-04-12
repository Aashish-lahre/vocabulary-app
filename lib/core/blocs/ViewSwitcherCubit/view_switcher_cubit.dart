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



  void changeViewMode(ViewMode newMode) {
    // if(newMode == viewMode) return;
    viewMode = newMode;
    print('viewMode changed = $viewMode');

    emit(ViewModeChanged(mode: newMode));
  }

  void updateViewMode(ViewMode newMode) {
    // if(newMode == viewMode) return;

    viewMode = newMode;
    print('viewMode updated : $viewMode');
    emit(ViewModeUpdate(mode: newMode));
  }
}


