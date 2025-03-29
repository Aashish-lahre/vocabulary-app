part of 'internet_bloc.dart';

// Only classes in the same file can extend or implement a sealed class.
sealed class InternetEvent extends Equatable {
  const InternetEvent();
}

class InternetStatusChanged extends InternetEvent {

  final bool isConnected;

  const InternetStatusChanged({required this.isConnected});


  @override
  // TODO: implement props
  List<Object?> get props =>[];

}