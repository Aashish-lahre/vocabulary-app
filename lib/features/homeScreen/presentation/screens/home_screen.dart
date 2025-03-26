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
    if(WordLoadSuccess == state.runtimeType) {
      return Positioned.fill(left: 30, right: 30, top: 50, bottom: 50, child: Container(
          color: Colors.deepPurpleAccent,
          child: WordSlider(
            itemCount:(state as WordLoadSuccess).words.length,
            itemBuilder: (_, index) => Container(
                // width: 100,
                height: 200,
                color: Colors.green,
                child: Column(
                  children: [
                    Text(state.words[index].word),

                    Text(state.words[index].meanings.first.definitions.first.definition),
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
