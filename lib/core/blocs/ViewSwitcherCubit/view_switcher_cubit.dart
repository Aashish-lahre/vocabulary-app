import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'view_switcher_state.dart';

class ViewSwitcherCubit extends Cubit<ViewSwitcherState> {
  ViewSwitcherCubit() : super(ViewSwitcherInitial());
}
