import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../features/homeScreen/presentation/utility/home_error_types_enum.dart';


class HomeErrorScreen extends StatelessWidget {
  final ({String errorMessage, HomeErrorType homeErrorType}) errorData;
  const HomeErrorScreen({required this.errorData, super.key});

  @override
  Widget build(BuildContext context) {
    if(errorData.homeErrorType == HomeErrorType.unexpected) {
      Future.delayed(Duration(seconds: 5), () => SystemNavigator.pop());

    }
    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20,
          children: [
            Theme(
                data: Theme.of(context).copyWith(textTheme: GoogleFonts.eaterTextTheme()),
                child: Text('Oops!', style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontSize: 70, color: Theme.of(context).colorScheme.onSurface),)),
            Text(errorData.errorMessage, style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.onSurface),),

          ],
        ),
      ),
    );
  }
}
