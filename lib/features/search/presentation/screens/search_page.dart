import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/shared/error_widget.dart';
import './searched_word_detail_screen.dart';
import 'package:gap/gap.dart';

import '../../../gemini_ai/word/bloc/gemini_bloc.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final SearchController _searchController;
  bool _isSearchControllerDisposed = false;

  @override
  void initState() {
    super.initState();
    _searchController = SearchController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isSearchControllerDisposed) {
        _searchController.openView();
      }
    });
  }

  @override
  void dispose() {
    _isSearchControllerDisposed = true;
    _searchController.dispose();
    super.dispose();
  }

  void _handlePop() {
    if (!_isSearchControllerDisposed) {
      _searchController.closeView(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GeminiBloc, GeminiState>(
      listenWhen: (_, currentState) {
        return [AiWordSearchCompleteState].contains(currentState.runtimeType);
      },
      listener: (context, state) {
        if (state is AiWordSearchCompleteState) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) =>
                  BlocProvider.value(
                    value: context.read<GeminiBloc>(),
                    child: SearchedWordDetailScreen(word: state.word)
                  )));
        }
      },
      buildWhen: (_, currentState) {
        return [GeminiSingleWordLoadFailureState, AiWordSearchingState]
            .contains(
            currentState.runtimeType);
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: kToolbarHeight + 50,
            title: _buildSearchBar(state),
          ),
          body: switch (state) {

            GeminiSingleWordLoadFailureState() =>
                errorWidget(
                  context, state.errorMessage, ElevatedButton(onPressed: () {
                  Navigator.of(context).pop();
                }, child: Text('Home'),),),

            AiWordSearchingState() =>
                SizedBox.expand(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Loading word from Gemini AI'),
                      Gap(10),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(),),
                    ],
                  ),
                ),
            _ => SizedBox.shrink(),
          },
        );
      },
    );
  }

  Widget _buildSearchBar(GeminiState state) {
    return SearchAnchor(
      searchController: _searchController,
      viewLeading: IconButton(
        onPressed: _handlePop,
        icon: const Icon(Icons.arrow_back_rounded),
      ),
      viewBackgroundColor: Theme
          .of(context)
          .colorScheme
          .surfaceContainer,
      builder: (context, controller) {
        if (_isSearchControllerDisposed) return const SizedBox.shrink();

        return SearchBar(
          shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          controller: controller,
          leading: const Icon(Icons.search),
          hintText: 'Search word',
          backgroundColor: WidgetStatePropertyAll(
              Theme
                  .of(context)
                  .colorScheme
                  .surfaceContainer),
          trailing: [
            IconButton(
              onPressed: () {
                controller.clear();
                if (controller.isOpen && !_isSearchControllerDisposed) {
                  controller.closeView(null);
                }
              },
              icon: const Icon(Icons.clear),
            )
          ],
          onTap: () {
            if (!_isSearchControllerDisposed) {
              controller.openView();
            }
          },
          onChanged: (_) {
            if (!_isSearchControllerDisposed) {
              controller.openView();
            }
          },
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        if (_isSearchControllerDisposed) return [];

        final query = controller.text;
        final words = all
            .where((word) => word.toLowerCase().startsWith(query))
            .toList();

        return [
          if(controller.text.isNotEmpty)
            ListTile(
              leading: const Icon(Icons.search),
              trailing: Transform.rotate(
                angle: -45 * 3.1415926535897932 / 180,
                child: const Icon(Icons.arrow_upward_rounded),
              ),
              title: Text(controller.text),
              onTap: () {
                if (!_isSearchControllerDisposed && context.mounted) {
                  controller.closeView(controller.text);

                  context.read<GeminiBloc>().add(
                      SearchWordWithAiEvent(wordName: controller.text));
                }
              },
            ),
          ...words.map((word) {
            return ListTile(
              leading: const Icon(Icons.search),
              trailing: Transform.rotate(
                angle: -45 * 3.1415926535897932 / 180,
                child: const Icon(Icons.arrow_upward_rounded),
              ),
              title: Text(word),
              onTap: () {
                if (!_isSearchControllerDisposed && context.mounted) {
                  controller.closeView(word);
                  controller.text = word;
                  context.read<GeminiBloc>().add(
                      SearchWordWithAiEvent(wordName: controller.text));
                }
              },
            );
          }),
        ];
      },
    );
  }


}
