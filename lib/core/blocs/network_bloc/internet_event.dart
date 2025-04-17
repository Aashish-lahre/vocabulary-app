part of 'internet_bloc.dart';

sealed class InternetEvent extends Equatable {
  const InternetEvent();
}

class InternetStatusChanged extends InternetEvent {

  final bool isConnected;

  const InternetStatusChanged({required this.isConnected});


  @override
  List<Object?> get props =>[];

}