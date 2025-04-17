

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

part 'internet_event.dart';
part 'internet_state.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {

  // internet connection has changed this many times.
   int _internetConnectionChanged = 0;



  InternetBloc() : super(InternetState()) {

    Connectivity().onConnectivityChanged.listen((result) {
      if(result.contains(ConnectivityResult.none)) {
        add(InternetStatusChanged(isConnected: false));
      }


      /// when app starts and connection is true, we do not emit event.
      /// we only do it when connection is false and then becomes true.
      else if(result.contains(ConnectivityResult.mobile) && _internetConnectionChanged > 0) {
        add(InternetStatusChanged(isConnected: true));
      }


    _internetConnectionChanged++;
    });

    on<InternetStatusChanged>((event, emit) {
      event.isConnected == true ? emit(InternetState(status: true)) : emit(InternetState(status: false));
    });
  }
}
