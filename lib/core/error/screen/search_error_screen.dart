import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../features/search/presentation/utility/search_error_type_enum.dart';

class SearchErrorScreen extends StatelessWidget {
  final ({String errorMessage, SearchErrorType searchErrorType}) errorData;
  const SearchErrorScreen({required this.errorData, super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20,
          children: [
            Theme(
                data: Theme.of(context).copyWith(textTheme: GoogleFonts.eaterTextTheme()),
                child: Text('Oops!', style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontSize: 70),)),
            Text(errorData.errorMessage, style: Theme.of(context).textTheme.bodyLarge,),

            errorData.searchErrorType == SearchErrorType.internet || errorData.searchErrorType == SearchErrorType.unexpected ? ElevatedButton(onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            }, child: Text('Home')) :  ElevatedButton(onPressed: () {
              Navigator.of(context).pop();
            }, child: Text('Try again!')),

          ],
        ),
      ),
    );
  }
}
