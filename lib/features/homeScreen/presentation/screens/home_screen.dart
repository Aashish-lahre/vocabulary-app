import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_improve_vocabulary/features/homeScreen/presentation/widgets/word_slider.dart';

import '../../../word/bloc/word_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
            // word slider
            BlocBuilder<WordBloc, WordState>(
  builder: (context, state) {
    print('stated changed');
    if(state is FetchingSingleWordState) {
      print('entered in homescreen');
      return Positioned.fill(left: 30, right: 30, top: 50, bottom: 50, child: Container(
          color: Colors.deepPurpleAccent,
          child: WordSlider(
            key: ValueKey(state.word.word),
            wordWidget: Container(
              // width: 100,
                height: 200,
                color: Colors.green,
                child: Column(
                  children: [
                    Text(state.word.word),

                    Text(state.word.meanings.first.definitions.first.definition),
                  ],
                )),
          ),) , );
    } else {
      return Center(child: Text('error : ${state.toString()}'),);
    }

  },
),


            // bottomNavigation
          ],
        ),
      ),
    );
  }
}
