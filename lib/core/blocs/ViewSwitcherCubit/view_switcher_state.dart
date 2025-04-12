part of 'view_switcher_cubit.dart';

sealed class ViewSwitcherState extends Equatable {
  final ViewMode mode;
  const ViewSwitcherState({required this.mode});
}

final class ViewSwitcherInitial extends ViewSwitcherState {



  const ViewSwitcherInitial({required super.mode});


  @override
  List<Object> get props => [mode];
}


final class ViewModeChanged extends ViewSwitcherState {


  const ViewModeChanged({required super.mode});

  @override
  List<Object?> get props => [mode];


}

final class ViewModeUpdate extends ViewSwitcherState {


  const ViewModeUpdate({required super.mode});

  @override
  List<Object?> get props => [mode];


}