import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_improve_vocabulary/word/cubit/word_cubit.dart';
import 'package:flutter_improve_vocabulary/word/widgets/word_failure.dart';

import '../../search/view/search_page.dart';
import '../widgets/word_initial.dart';
import '../widgets/word_loading.dart';
import '../widgets/word_success.dart';

class WordPage extends StatelessWidget {
  const WordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(title: Text('Word Page'),),
      body: BlocBuilder<WordCubit, WordState>(
        builder: (context, state) {
          print('bloc builder running...');
          return switch (state.wordStatus) {
            WordStatus.initial => const WordEmpty(),
            WordStatus.loading => const WordLoading(),
              WordStatus.failure => const WordError(),
              WordStatus.success => WordPopulate(
                word: state.word,
              ),
          };
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        final wordQueryReceivedFromSearchPage = await Navigator.of(context).push(SearchPage.route());
        if(!context.mounted) return;
        await context.read<WordCubit>().getWord(wordQueryReceivedFromSearchPage as String);
        print('we got the word');
      }, 
      
      child: Icon(Icons.search),),
    );
  }
}