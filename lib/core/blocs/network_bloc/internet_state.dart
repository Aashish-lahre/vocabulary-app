part of 'internet_bloc.dart';




 class InternetState extends Equatable {
  final bool status;
   const InternetState(
  {
    this.status = false,
 }
      );

  @override
  List<Object?> get props => [status];
}




