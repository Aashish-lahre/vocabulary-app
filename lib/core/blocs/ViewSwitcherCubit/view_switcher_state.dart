part of 'view_switcher_cubit.dart';

sealed class ViewSwitcherState extends Equatable {
  const ViewSwitcherState();
}

final class ViewSwitcherInitial extends ViewSwitcherState {
  @override
  List<Object> get props => [];
}
